import { LightningElement, api } from 'lwc';
import EDealer_Choose_Add_Competitor from '@salesforce/label/c.EDealer_Choose_Add_Competitor';
import EDealer_Choose_Competitor from '@salesforce/label/c.EDealer_Choose_Competitor';
import EDealer_Add_Competitor from '@salesforce/label/c.EDealer_Add_Competitor';
export default class EdealerCompetitorContainer extends LightningElement {

  label = {
    EDealer_Choose_Add_Competitor,
    EDealer_Choose_Competitor,
    EDealer_Add_Competitor
  }; 
    // Attribute for selected part
    @api selectedPart;
    @api selectedCompId;
    @api dealerCode;
    @api selectedCompetitorDataForAddCompetitor={};
    activeTab = 'chooseCompetitor';
 selectedCompetitorData;

    connectedCallback() {
        console.log('this.selectedCompetitorData-----'+JSON.stringify(this.selectedCompetitorDataForAddCompetitor));
        if(this.selectedCompetitorDataForAddCompetitor && this.selectedCompetitorDataForAddCompetitor.CompetitorName){
            this.activeTab = this.selectedCompetitorDataForAddCompetitor.tab;
            this.selectedCompetitorData=this.selectedCompetitorDataForAddCompetitor;
            
        }
    }
    // Handle close modal on close button click
    handleCloseCompetitorModal() {
        this.dispatchEvent(new CustomEvent('closemodal', {
            detail: {
                openCompetitorModal: false
            }
        }));
    }

    // Handle close modal on cancel button click
    handleCancelEvent() {
        this.dispatchEvent(new CustomEvent('cancelmodal', {
            detail: {
                openCompetitorModal: false
            }
        }));
    }

    // Handle selected row data
    handleSelectedRowData(event) {
        this.dispatchEvent(new CustomEvent('selectedcompetitor', {
            detail: {
                selectedCompetitor: event.detail.selectedCompetitorData
            }
        }));
    }

    // Handle new added form data
    handleAddCompetitorFormData(event) {
        this.dispatchEvent(new CustomEvent('addcompetitor', {
            detail: {
                selectedCompetitor: event.detail.selectedCompetitorData
            }
        }));
    }
}