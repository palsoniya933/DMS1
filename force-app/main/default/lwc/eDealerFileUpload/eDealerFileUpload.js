import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Edealer_allowedFormatsMessage from '@salesforce/label/c.Edealer_allowedFormatsMessage';
import getCSRHeaderTranslations from '@salesforce/apex/eDealerCreateCsrController.getCSRHeaderTranslations';
import Edealer_MaxFileLimitReachedMessage from '@salesforce/label/c.Edealer_MaxFileLimitReachedMessage';
import Edealer_TotalFileSizeErrorMessage from '@salesforce/label/c.Edealer_TotalFileSizeErrorMessage';
import Edealer_Single_File_Size from '@salesforce/label/c.Edealer_Single_File_Size';
import Edealer_Total_file_Size from '@salesforce/label/c.Edealer_Total_file_Size';

const MAX_FILE_SIZE = 3145728;

export default class EDealerFileUpload extends LightningElement {
    @track fileDetails = [];
    @api uploadedFiles;
    fileType;
    @api csrNumber;
    getTranslation;
    @api csrPhase;
    @api dealerUserName;
    @api disableImport;
    allowedFormatsMessage;
    Filesizecannotexceed3MBTotalfilesize;
    Filesizecannotexceed3MBSelectedfilesize;
    OnlyPDFandimagefilesareallowed;
    FilehasexceededtheuploadlimitUploadedfile3;
    Alluploadedfilesizecannotexceed3MB;

    files = {
        files: [],
        file_to_delete: []
    };
    uploadedFilesAdded = false;
    totalFileSizeErrorMessage = Edealer_TotalFileSizeErrorMessage;
    maxFileLimitReachedMessage = Edealer_MaxFileLimitReachedMessage;
    allowedFormatsMessage = this.OnlyPDFandimagefilesareallowed;

    connectedCallback() {
        this.gettranslation();
    }
    gettranslation() {
        getCSRHeaderTranslations().then((result) => {
            console.log('result getCSRHeaderTranslations34---' + JSON.stringify(result));
            this.Filesizecannotexceed3MBTotalfilesize = result.Filesizecannotexceed3MBTotalfilesize;
            this.Filesizecannotexceed3MBSelectedfilesize = result.Filesizecannotexceed3MBSelectedfilesize;
            console.log('file size-----'+ JSON.stringify(this.Filesizecannotexceed3MBSelectedfilesize));
            this.OnlyPDFandimagefilesareallowed = result.OnlyPDFandimagefilesareallowed;
            //console.log('file size-----' + JSON.stringify(this.OnlyPDFandimagefilesareallowed));
            this.FilehasexceededtheuploadlimitUploadedfile3 = result.FilehasexceededtheuploadlimitUploadedfile3;
            this.Alluploadedfilesizecannotexceed3MB = result.Alluploadedfilesizecannotexceed3MB;
        })
            .catch((error) => {
                console.log(JSON.stringify(error))
            })
            .finally(() => {
                this.isShowSpinner = false;
            });
    }

    get filesData() {
        if (this.uploadedFiles && this.uploadedFiles.file_info && this.uploadedFiles.file_info.length > 0 && !this.uploadedFilesAdded) {
            const files = this.uploadedFiles.file_info.map((fileInfo, index) => {
                return {
                    fileId: index,
                    fileName: this.getFileName(fileInfo.Key),
                    formatedfileSize: this.getFormatBytes(fileInfo.Size, 2),
                    key: fileInfo.Key,
                    s3_bucket: fileInfo.s3_bucket,
                    fileUrl: fileInfo.Fileurl,
                    filename_extension: this.getFileName(fileInfo.Key),
                    blobData: '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgs',
                    isEditMode: true
                };
            })
            this.fileDetails = [...files];
            this.uploadedFilesAdded = true;
        }
        return this.fileDetails;
    }

    getFileName(fileKey) {
        if (fileKey !== '') {
            const splittedFileKey = fileKey.split('/');
            return splittedFileKey[splittedFileKey.length - 1];
        }
    }
    async handleFilesChange(event) {
        if (this.isUploadedFileSizeExceeded()) {
            this.handleToastMessage('Error', this.Alluploadedfilesizecannotexceed3MB[0].label, 'error');
            return;
        }
        if (this.isUploadedFileReachMaxLimit()) {
            this.handleToastMessage('Error', this.FilehasexceededtheuploadlimitUploadedfile3[0].label, 'error');
            return;
        }

        if (event.target.files.length > 0) {
            const filesUploaded = event.target.files;
            const file = filesUploaded[0];
            const allowedFormats = ['application/pdf', 'image/jpeg', 'image/jpg','image/png'];

            if (!allowedFormats.includes(file.type)) {
                if (Edealer_allowedFormatsMessage === 'Only PDF, JPEG and PNG files are allowed') {
                  
                    this.handleToastMessage('Error', this.OnlyPDFandimagefilesareallowed[0].label, 'error');
                    return;
                }
            }

            if (this.getFormatedFileSize(filesUploaded)) {
                var formatedFileSize = this.getFormatedFileSize(filesUploaded);
            } else {
                return;
            }

            const fileId = this.getNextFileId();
            const fileName = file.name;
            const filetype = file.type;
            const fileSizeInBytes = this.getFileSizeInBytes(filesUploaded);

            try {
                const blobData = await this.getBlobDataFromFile(file);

                const fileObject = {
                    fileId: fileId,
                    fileName: fileName,
                    filetype: filetype,
                    dealerCode: this.dealerUserName,
                    fileSizeInBytes: fileSizeInBytes,
                    formatedfileSize: formatedFileSize,
                    blobData: blobData,
                    isEditMode: false,
                    isDeleted: false,
                };

                this.fileDetails.push(fileObject);
                this.files.files.push(fileObject);
                const event = new CustomEvent('files', {
                    detail: { fileDetails: this.fileDetails }
                });
                this.dispatchEvent(event);
                this.getFileDetais();
            } catch (error) {

            }
        }
    }

    getBlobDataFromFile(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => {
                const fileContents = reader.result;
                const base64Mark = 'base64,';
                const dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                const base64Data = fileContents.substring(dataStart);
                resolve(base64Data);
            };
            reader.onerror = error => reject(error);
            reader.readAsDataURL(file);
        });
    }

    getNextFileId() {
        let index = 0;
        if (this.fileDetails.length > 0) {
            this.fileDetails.forEach(item => {
                if (item.fileId > index) {
                    index = item.fileId;
                }
            });
            return (index + 1);
        }
        return index;
    }

    getFormatedFileSize(uploadedFile) {
        
        var fileCon = uploadedFile[0];
        if (fileCon.size > MAX_FILE_SIZE) {
            let message = this.Filesizecannotexceed3MBSelectedfilesize[0].label + this.getFormatBytes(fileCon.size, 2);
            this.handleToastMessage('Error', message, 'error');
            return;
        }
        return this.getFormatBytes(fileCon.size, 2);
    }

    getFormatBytes(bytes, decimals) {
        if (bytes == 0) return '0 Bytes';
        var k = 1024,
            dm = decimals || 2,
            sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
            i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    }

    getFileSizeInBytes(uploadedFile) {
        var fileCon = uploadedFile[0];
        if (fileCon.size > MAX_FILE_SIZE) {
            let message = this.Filesizecannotexceed3MBTotalfilesize[0].label + this.getFormatBytes(fileCon.size, 2);
            this.handleToastMessage('Error', message, 'error');
        }

        return fileCon.size;
    }

    isUploadedFileSizeExceeded() {
        if (this.fileDetails.length > 0) {
            var fileSize = 0;
            this.fileDetails.forEach((item) => {
                fileSize += parseInt(item.fileSizeInBytes);
            });

            if (fileSize > MAX_FILE_SIZE) {
                return true;
            }
        }
        return false;
    }

    isUploadedFileReachMaxLimit() {
        let isDeletedCount = 0;
        this.fileDetails.forEach(file => {
            if (file.isDeleted === true) {
                isDeletedCount++;
            }
        });
        if (this.fileDetails.length >= 3 + isDeletedCount) {
            return true;
        } else {
            return false;
        }
    }

    handleToastMessage(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }

    handleRemoveFile(event) {
        const index = event.target.dataset.index;
        const fileToRemove = this.fileDetails[index];
        this.fileDetails[index].isDeleted = true;
        this.fileDetails = [...this.fileDetails];
        if (!fileToRemove.blobData) {
            this.files.file_to_delete.push({ Key: fileToRemove.key, s3_bucket: fileToRemove.s3_bucket });
        }
        if (this.fileDetails[index].isEditMode == false) {
            this.fileDetails.splice(index, 1);
            this.fileDetails = [...this.fileDetails];
        }
        this.getFileDetails();
    }

    getFileDetails() {
        const event = new CustomEvent('files', {
            detail: { fileDetails: this.fileDetails }
        });
        this.dispatchEvent(event);
    }
    handleViewFile(event) {
        const index = event.target.dataset.index;
        const fileToView = this.filesData[index];
        console.log('Viewing file:', fileToView);
    }
}