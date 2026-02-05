import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import storeFileToS3Bucket from '@salesforce/apex/ServiceInspectionSheetController.storeFileToS3Bucket';
import fetchAllFileNamesFromS3Bucket from '@salesforce/apex/ServiceInspectionSheetController.fetchAllFileNamesFromS3Bucket';

const DOC_FILE_EXTENSIONS = ['.doc', '.docx'];
const EXCEL_FILE_EXTENSIONS = ['.xls', '.xlsx'];
const ACCEPTED_FILE_EXTENSIONS = [
  '.pdf',
  ...DOC_FILE_EXTENSIONS,
  ...EXCEL_FILE_EXTENSIONS,
];
const MAXIMUM_FILE_SIZE = 3000000;
const DIVISION = [
  { label: 'All', value: 'A' },
  { label: 'Kenworth', value: 'K' },
  { label: 'Peterbilt', value: 'P' },
];
const LABELS = {
  modalTitle: 'Upload Service Inspection Sheet',
  englishFile: 'English File',
  spanishFile: 'Spanish File',
  frenchFile: 'French File',
  fileMissingError: 'Please upload 3 files in ENG/SP/FR',
  division: 'Division',
  fileTooLargeTitle: 'File too large',
  fileTooLargeErrorPreFix: 'File size must be less than ',
  fileUploadSuccessMessage: 'Files Uploaded Successfully',
  save: 'Save',
  cancel: 'cancel',
};
const FILES_BY_FILE_LANGUAGE = {
  english: {
    title: 'English Title',
  },
  spanish: {
    title: 'Spanish Title',
  },
  french: {
    title: 'French Title',
  },
};

export default class InspectionSheetUploadModal extends LightningElement {
  @api existingFileIds = [];
  @track fileByFileLanguage = { ...FILES_BY_FILE_LANGUAGE };
  acceptedFileExtensions = ACCEPTED_FILE_EXTENSIONS;
  labels = LABELS;
  divisionOptions = DIVISION;
  editEnabledLanguages = [];
  showSpinner = false;
  isLoading = false;
  selectedDivision = 'A';

  get files() {
    const info = Object.keys(this.fileByFileLanguage).map((key) => {
      return {
        name: this.fileByFileLanguage[key].fileName,
        extension: this.fileByFileLanguage[key].fileExtension,
        title: this.fileByFileLanguage[key].title,
        language: key,
      };
    });
    return info;
  }

  get isDisplayOnly() {
    return false;
  }

  get isDisabled() {
    return (
      (this.editEnabledLanguages && this.editEnabledLanguages.length > 0) ||
      this.isLoading
    );
  }

  handleFilesChange(event) {
    const file = event.target.files[0];
    if (!this.isFileAcceptable(file)) {
      return;
    }
    const fileLanguage = event.target.dataset.id;
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        const base64Data = reader.result.split(',')[1];
        const fullFileName = file.name;
        const fileExtension = fullFileName.split('.').pop();
        const fileName =
          fullFileName.substr(0, fullFileName.lastIndexOf('.')) || fullFileName;
        this.fileByFileLanguage[fileLanguage] = {
          ...this.fileByFileLanguage[fileLanguage],
          fileName,
          fileExtension,
          file64Data: base64Data,
          fileLanguage,
        };
      };
      reader.readAsDataURL(file);
    }
  }

  isFileAcceptable(file) {
    const isFileSizeValid = this.isFileSizeAcceptable(file.size);
    const isFileExtensionValid = this.isFileExtensionAcceptable(file.name);
    return isFileSizeValid && isFileExtensionValid;
  }

  isFileSizeAcceptable(size) {
    const isFileSizeUnderThreshold = size <= MAXIMUM_FILE_SIZE;
    if (!isFileSizeUnderThreshold) {
      this.showToast(
        this.labels.fileTooLargeTitle,
        this.labels.fileTooLargeErrorPreFix +
          Math.round(MAXIMUM_FILE_SIZE / 1024 / 1024) +
          ' MB.',
        'error'
      );
    }
    return isFileSizeUnderThreshold;
  }

  isFileExtensionAcceptable(fileName) {
    const fileExtension = '.' + fileName.split('.').pop().toLowerCase();
    const isFileExtensionAcceptable =
      this.acceptedFileExtensions.includes(fileExtension);
    if (!isFileExtensionAcceptable) {
      this.showToast(
        'Invalid file extension',
        'Only ' +
          this.acceptedFileExtensions.join(', ') +
          ' files are allowed.',
        'error'
      );
    }
    return isFileExtensionAcceptable;
  }

  handleClose() {
    this.dispatchEvent(new CustomEvent('closemodal'));
  }

  handleEditMode(event) {
    this.editEnabledLanguages = [
      event.detail.editingEnabledFor,
      ...this.editEnabledLanguages,
    ];
  }

  handleSaveMode(event) {
    this.fileByFileLanguage[event.detail.editingDisabledFor].fileName =
      event.detail.updatedName;
    this.editEnabledLanguages = this.editEnabledLanguages.filter((language) => {
      return event.detail.editingDisabledFor !== language;
    });
  }

  async handleSave() {
    const allValid = [...this.template.querySelectorAll('.validate')].reduce(
      (validSoFar, inputCmp) => {
        inputCmp.reportValidity();
        return validSoFar && inputCmp.checkValidity();
      },
      true
    );
    const areFileNamesUnique = await this.validateFileNames();
    if (allValid && areFileNamesUnique) {
      this.generateRequestBodyAndInitializeUploadingToS3Bucket();
    }
  }

  async generateRequestBodyAndInitializeUploadingToS3Bucket() {
    let allSuccess = true;
    try {
      this.showSpinner = true;
      this.isLoading = true;
      const id = this.findIdForFiles();
      for (const fileLanguage of Object.keys(this.fileByFileLanguage)) {
        const fileData = this.fileByFileLanguage[fileLanguage];
        const fileNameWithExtension =
          fileData.fileName + '.' + fileData.fileExtension;
        const language =
          fileLanguage.toLowerCase() == 'spanish'
            ? 'Spanish'
            : fileLanguage.toLowerCase() == 'french'
              ? 'French'
              : 'English';
        await storeFileToS3Bucket({
          base64Data: fileData.file64Data,
          fileNameWithExtension: fileNameWithExtension,
          fileId: id,
          language: language,
        });
      }
    } catch (error) {
      console.log(error);
      allSuccess = false;
    } finally {
      this.showSpinner = false;
      this.isLoading = false;
      if (allSuccess) {
        this.showToast(
          'Success',
          this.labels.fileUploadSuccessMessage,
          'success'
        );
        this.dispatchEvent(new CustomEvent('fileuploaded'));
      }
    }
  }

  findIdForFiles() {
    if (this.existingFileIds && this.existingFileIds.length > 0) {
      const fileIds = [...this.existingFileIds];
      fileIds.sort((a, b) => parseInt(a) - parseInt(b));
      for (let i = 0; i < fileIds.length; i++) {
        let expected = String(i).padStart(4, '0');
        let fileId = String(parseInt(fileIds[i])).padStart(4, '0');
        if (fileId !== expected) {
          return expected + this.selectedDivision;
        }
      }
      return String(fileIds.length).padStart(4, '0') + this.selectedDivision;
    } else {
      return '0000' + this.selectedDivision;
    }
  }

  async validateFileNames() {
    try {
      this.isLoading = true;
      const allFileNames = await fetchAllFileNamesFromS3Bucket();
      let allNamesValid = true;
      for (const fileLanguage of Object.keys(this.fileByFileLanguage)) {
        if (
          allFileNames.includes(
            this.fileByFileLanguage[fileLanguage].fileName?.toLowerCase()
          )
        ) {
          allNamesValid = false;
          this.showToast(
            'Error',
            `${fileLanguage} : ${this.fileByFileLanguage[fileLanguage].fileName}.${this.fileByFileLanguage[fileLanguage].fileExtension} already exists`,
            'error'
          );
        }
      }
      return allNamesValid;
    } catch (error) {
      console.log(error);
    } finally {
      this.isLoading = false;
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant,
    });
    this.dispatchEvent(event);
  }

  handleComboBoxChange(event) {
    this.selectedDivision = event.detail.value;
  }
}