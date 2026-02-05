import { LightningElement, api } from 'lwc';
import getCsrFilesFromAws from '@salesforce/apex/eDealerCSRViewFilesController.getCsrFilesFromAws';
import getCsrLettersFromAws from '@salesforce/apex/eDealerCSRViewFilesController.getCsrLettersFromAws';
import getFilesColumnHeaders from '@salesforce/apex/eDealerCSRViewFilesController.getFilesColumnHeaders';

import fetchLoggedInUserDetails from '@salesforce/apex/eDealerCSRViewCommentsController.fetchLoggedInUserDetails';

import EDealer_CSR_Comments_Not_Found from '@salesforce/label/c.EDealer_CSR_Comments_Not_Found';

export default class edealerCsrViewFile extends LightningElement {

    @api csrNumber;
    @api csrPhase;
    @api dealerCode
    dealerUserName;
    isNonDealer;
    isLoading = true;
    isFileFound= false;
    isPostingLetterFound= false;
    
    columnLabelByApiName = [];
    csrFiles = [];
    csrPostingLetters = [];
    label = { EDealer_CSR_Comments_Not_Found };
    
    get showError(){
        return !this.isLoading && !this.isFileFound && !this.isPostingLetterFound ;
    }
    get hasfilesOrPostingLetter(){
        return  this.isFileFound || this.isPostingLetterFound ;
    }
    async connectedCallback() {
        await this.fetchLoggedInUserDetails();
        await this.fetchFilesColumnHeaders();
        if (this.csrNumber) {
             await this.fetchCsrFiles();
             await this.fetchCsrPostingLetters();
        }
        
    }

    async fetchCsrFiles() {
        console.log('fetchCsrFiles: '+this.csrNumber +'-'+this.csrPhase+'-'+this.dealerCode);
        this.isLoading = true;
        await getCsrFilesFromAws({ Dealercode : this.dealerCode ,csrNumber: this.csrNumber, csrPhase: this.csrPhase })
            .then((results) => {
                console.log('results ---- '+ results)
                if(JSON.parse(results).file_info){

                    if(JSON.parse(results).file_info.length>0){
                        this.csrFiles = JSON.parse(results).file_info
                        this.csrFiles.forEach(item => {
                            item.type = 'Attachment file'
                        });
                        this.isFileFound = true;

                    }
                }
                else{
                    this.isFileFound = false;
                }
               
            })
            .catch((error) => {
                console.log(error);
            })
            .finally(() => {
                this.isLoading = !this.isLoading;
            });
    }
    async fetchCsrPostingLetters() {
        console.log('fetchCsrFiles: '+this.dealerCode+'_'+this.csrNumber +'_00'+this.csrPhase);
        this.isLoading = true;
        await getCsrLettersFromAws({ Dealercode : this.dealerCode ,csrNumber: this.csrNumber, csrPhase: this.csrPhase })
            .then((results) => {

                console.log('letter : '+results)
                if(JSON.parse(results).Urls){

                    if(JSON.parse(results).Urls.length>0){
                        this.csrPostingLetters = JSON.parse(results).Urls;
                        this.csrPostingLetters.forEach(item => {
                            item.label = item.Fileurl.split('/')[4].split('?')[0]
                            item.type = 'Posting Letter'
                        });
                        this.isPostingLetterFound=  true;
                    }
                }
                else{
                    this.isPostingLetterFound = false;
                }
               
            })
            .catch((error) => {
                console.log(error);
            })
            .finally(() => {
                this.isLoading = !this.isLoading;
            });
    }
    async fetchFilesColumnHeaders() {
         await getFilesColumnHeaders({})
            .then((results) => {
                this.columnLabelByApiName = [...results];
            })
            .catch((error) => {
                console.log(error);
            });
    }

    async fetchLoggedInUserDetails() {
        await fetchLoggedInUserDetails({})
            .then((results) => {
                console.log('results::' + JSON.stringify(results));
                let user = results.asiUserName;
                console.log('user::' + user);
                this.isNonDealer = results.isNonDealer
                console.log('nonDealer::' + this.isNonDealer);
            })
            .catch((error) => {
                console.log(error);
            });

    }
    
}