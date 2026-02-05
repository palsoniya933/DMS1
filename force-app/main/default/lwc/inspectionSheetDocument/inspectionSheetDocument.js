import { LightningElement, api, track } from 'lwc';
import EDealerResources from '@salesforce/resourceUrl/EDealerResources';

const DOC_FILE_EXTENSIONS = ['.doc', '.docx'];
const EXCEL_FILE_EXTENSIONS = ['.xls', '.xlsx'];
const LABELS = { delete: 'Delete', cancel: 'Cancel' };

export default class InspectionSheetDocument extends LightningElement {
  @api documentName;
  @api documentExtension;
  @api documentSNo;
  @api documentUrl;
  @api documentLanguage;
  @api displayOnly;
  @api title;
  @api isAdminUser;
  labels = LABELS;
  editMode = false;
  deleteModeEnabled = false;
  deleteMessage = 'Are you sure you want to delete this document?';
  deleteIconURL = EDealerResources + '/icons/TrashIcon.svg';
  warningIconURL = EDealerResources + '/icons/AlertIcon.svg';

  get iconUrl() {
    let url = EDealerResources + '/icons/';
    const extension = '.' + this.documentExtension.toLowerCase();
    if (EXCEL_FILE_EXTENSIONS.includes(extension)) {
      url += 'ExcelIconGreen.svg';
    } else if (DOC_FILE_EXTENSIONS.includes(extension)) {
      url += 'wordIconBlue.svg';
    } else {
      url += 'PdfIconWineRed.svg';
    }
    return url;
  }

  get editIcon() {
    return EDealerResources + '/icons/loyalty_edit.svg';
  }

  get saveIcon() {
    return EDealerResources + '/icons/loyalty_save.svg';
  }

  get documentDownloadUrl() {
    return this.documentUrl ? this.documentUrl : '';
  }

  get showDocumentInfo() {
    return (this.documentName || this.editMode) && !this.deleteModeEnabled;
  }

  get showAdminActions() {
    return this.isAdminUser;
  }

  get documentInfoStyleClass() {
    return this.isAdminUser
      ? 'slds-col slds-size_10-of-12'
      : 'slds-col slds-size_12-of-12';
  }

  get showDocument() {
    return !this.deleteModeEnabled;
  }

  get containerStyleClass() {
    return !this.deleteModeEnabled
      ? 'content-style'
      : 'content-style warning-bg-color';
  }

  handleEditButtonClick() {
    this.editMode = true;
    this.dispatchEvent(
      new CustomEvent('editmodeenabled', {
        detail: {
          editingEnabledFor: this.documentLanguage,
        },
      })
    );
  }

  handleSaveButtonClick() {
    const valid = this.template.querySelector('lightning-input').validity.valid;
    if (valid && this.documentName) {
      this.editMode = false;
      this.dispatchEvent(
        new CustomEvent('editmodedisabled', {
          detail: {
            editingDisabledFor: this.documentLanguage,
            updatedName: this.documentName,
          },
        })
      );
    }
  }

  handleInputChange(event) {
    let value = event.detail.value.trim();
    if (value) {
      this.documentName = value;
    } else {
      this.documentName = '';
      event.detail.value = '';
    }
  }

  handleDelete() {
    this.deleteModeEnabled = true;
  }

  cancelDeleteDocument() {
    this.deleteModeEnabled = false;
  }

  confirmDeleteDocument() {
    this.dispatchEvent(
      new CustomEvent('deletedocument', {
        detail: {
          documentUniqueId: this.documentSNo,
        },
        bubbles: true,
        composed: true,
      })
    );
  }
}