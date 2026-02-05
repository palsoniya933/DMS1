import { LightningElement, wire } from 'lwc';
import getTemplateDetail from '@salesforce/apex/EDealerCSRTemplateAnnouncement.getTemplateDetail';
import getCSRAnnouncementTranslations from '@salesforce/apex/EDealerCSRTemplateAnnouncement.getCSRAnnouncementTranslations'

export default class eDealerCSRTemplateAnnouncement extends LightningElement {
    @wire(getTemplateDetail) detail;
    messageannouncement = '';
    connectedCallback(){
        getCSRAnnouncementTranslations()
        .then((result) => {
            console.log(JSON.stringify(result));
            this.messageannouncement = result.message.label
        })
        .catch((error) => {
            console.log('translation value error::' + JSON.stringify(error));
        });
    }      

    StartDate() {
        return this.detail && this.detail.data ? this.detail.data.CSR_Template_Start_Date__c : 'Loading...';
        
    }

    EndDate() {
        return this.detail && this.detail.data ? this.detail.data.CSR_Template_End_Date__c : 'Loading...';
    }

    get IsDisplay() {

        let today = new Date();
        today.setMinutes(new Date().getMinutes() - new Date().getTimezoneOffset());
      
        let date = today.toISOString().slice(0,10); 

        let NotificationStartDate = this.StartDate();
        let NotificationEndDate = this.EndDate();

        if (date >= NotificationStartDate && date <= NotificationEndDate) {
            return true;
        }
        else {
            return false;
        }
    }
}