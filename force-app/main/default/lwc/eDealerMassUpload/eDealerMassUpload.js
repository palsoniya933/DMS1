import { LightningElement, track, api } from 'lwc';
import getDownloadTemplateId from '@salesforce/apex/eDealerDownloadTemplate.getDownloadTemplateId';
import { loadScript } from "lightning/platformResourceLoader";
import EDealer_Download_Template from '@salesforce/label/c.EDealer_Download_Template';
import sheetjs from "@salesforce/resourceUrl/sheetJS";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import EDealer_Mass_Upload from '@salesforce/label/c.EDealer_Mass_Upload';
import edealerMassuploadbutton from '@salesforce/label/c.edealerMassuploadbutton';
import EDealerResources from '@salesforce/resourceUrl/EDealerResources';
import edealerMassUploadFileUpload from '@salesforce/label/c.edealerMassUploadFileUpload';
import getCSRHeaderTranslations from '@salesforce/apex/eDealerCreateCsrController.getCSRHeaderTranslations';
import CSRMassUploadEnglish from "@salesforce/resourceUrl/CSRMassUploadEnglish";
import CSRMassUploadFrench from "@salesforce/resourceUrl/CSRMassUploadFrench";
import CSRMassUploadSpanish from "@salesforce/resourceUrl/CSRMassUploadSpanish";
export default class EDealerMassUpload extends LightningElement {
    csrMassUploadEnglishURL = CSRMassUploadEnglish;
    csrMassUploadFrenchURL = CSRMassUploadFrench;
    csrMassUploadSpanishURL = CSRMassUploadSpanish;
    excelDownloadLogo = EDealerResources + '/icons/Excelliconwhite.svg' + '#Excelliconwhite';
    allowedFormatsMessage;
    allowedFileFormats;
    fileData;
    @api partsviewdata;
    label = {
        EDealer_Download_Template,
        EDealer_Mass_Upload,
        edealerMassuploadbutton,
        edealerMassUploadFileUpload
    };
    excelData;
    @track fileDetails = [];
    @track isModalOpen = false;
    @track disableUploadButton = true;
    @track acceptedFormats = ['.xls', '.xlsx'];
    renderedCallback() {
        console.log(sheetjs);
        Promise.all([loadScript(this, sheetjs)])
            .then(() => {
                console.log("success");
            })
            .catch(error => {
                console.log("failure");
            });



    }
    connectedCallback() {
        debugger;
        //getting picklist value for csr header from custom metadata(translation feature enabled)
        getCSRHeaderTranslations().then((result) => {
            //console.log('result-----'+JSON.stringify(result));
            this.allowedFormatsMessage = result.excelFileAllowed[0].label;
            this.allowedFileFormats = result.excelFileAccepted[0].label;

        })
            .catch((error) => {
            })
            .finally(() => {
                this.isShowSpinner = false;
            });
    }

    downloadTemplate() {      
        getDownloadTemplateId()
            .then((result) => {                
                if(result == 'es_MX'){
                    window.open(this.csrMassUploadSpanishURL, "_self");
                }
                else if(result == 'fr_CA'){
                    window.open(this.csrMassUploadFrenchURL, "_self");
                }
                else{
                    window.open(this.csrMassUploadEnglishURL, "_self");
                }
                
            }).catch((error) => {
                console.log('-e-' + JSON.stringify(error))
            });
    }
    openModal() {
        this.fileDetails = [];
        this.isModalOpen = true;
    }

    closeModal() {
        this.fileDetails = [];
        this.isModalOpen = false;
        this.disableUploadButton = true;
    }

    handleFileChange(event) {
        let partsviewdataSize;
        if (this.partsviewdata.length == 1 && !this.partsviewdata[0].Part.trim()) {
            partsviewdataSize = 0
        } else {
            partsviewdataSize = this.partsviewdata.length;
        }
        this.fileDetails = [];
        const uploadedFile = event.detail.files[0];

        const allowedFormats = ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'];
        if (!allowedFormats.includes(uploadedFile.type)) {
            this.handleToastMessage('Error', this.allowedFormatsMessage, 'error');
            return;
        }
        if (uploadedFile) {
            this.disableUploadButton = false;
        } else {
            this.disableUploadButton = true;
        }
        //const fileId = this.getNextFileId();
        const fileName = uploadedFile.name;

        const filetype = uploadedFile.type;

        const fileObject = {
            fileId: 0,
            fileName: fileName,
            filetype: filetype,
        };

        this.fileDetails.push(fileObject);
        this.readExcelData(uploadedFile);
    }
    readExcelData(uploadedFile) {
        let readExcelFileCell;
        if (this.partsviewdata.length == 1 && !this.partsviewdata[0].Part.trim()) {
            readExcelFileCell = 128;
        } else {
            readExcelFileCell = 128 - this.partsviewdata.length;
        }
        const reader = new FileReader();
        reader.onload = (e) => {
            try {
                const arrayBuffer = e.target.result;
                const workbook = XLSX.read(arrayBuffer, { type: 'array' });
                const sheetName = workbook.SheetNames[0];
                const worksheet = workbook.Sheets[sheetName];
                const newRange = {
                    s: { c: 0, r: 3 }, // Start from A4
                    e: { c: readExcelFileCell, r: readExcelFileCell }  // End at E100 (zero-based index)
                };
                this.fileData = XLSX.utils.sheet_to_row_object_array(worksheet, { range: newRange });
                this.convertToDesiredFormat(this.fileData);
            } catch (error) {
                console.error('Error reading Excel file:', error);
            }
        };
        reader.readAsArrayBuffer(uploadedFile);
    }
    get fileData() {

    }
    handleUpload(event) {
        this.massUpload();
        this.closeModal();
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

    handleToastMessage(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
    convertToDesiredFormat(inputData) {
        let partsviewdataSize;
        if (this.partsviewdata.length == 1 && !this.partsviewdata[0].Part.trim()) {
            partsviewdataSize = 0
        } else {
            partsviewdataSize = this.partsviewdata.length;
        }
        let outputData = [];
        const uniqueRandomNumbers = Array.from({ length: 300 }, (_, i) => i + 150).sort(() => Math.random() - 0.5).slice(0, 110);
        const headersMap = new Map();
        const firstObject = inputData[0];
        Object.keys(firstObject).forEach((key, index) => {
            headersMap.set(index, key);
        });
        inputData.forEach((item, index) => {
            if (headersMap.get(0)) {
                let outputItem = {
                    "Id": uniqueRandomNumbers[index],
                    "Part": (item[headersMap.get(0)].toString().toUpperCase()).trim(),
                    "PartDescription": "",
                    "Channel": "",
                    "Channels": [],
                    "srNum": partsviewdataSize + index + 1,
                    "Competitor": {
                        "Affiliation": ["0"],
                        "Confirmation": "",
                        "CompType": "",
                        "CompState": "",
                        "CompPostal": "",
                        "CompetitorName": item[headersMap.get(3)],
                        "CompCity": "",
                        "CompetitorCode": item[headersMap.get(4)]
                    },
                    "CompPart": item[headersMap.get(2)],
                    "CompPrice": item[headersMap.get(1)],
                    "Brand": "",
                    "isSelected": true,
                    "isMassUploadRow": true,
                };
                outputData.push(outputItem);
            }
            this.partData = outputData;
        });


    }
    massUpload() {
        const event = new CustomEvent('partdata', {
            detail: this.partData
        });
        this.dispatchEvent(event);
    }

}