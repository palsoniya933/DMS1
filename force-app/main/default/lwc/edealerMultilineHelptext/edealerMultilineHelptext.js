import { LightningElement, api, track } from 'lwc';

export default class HelpIcon extends LightningElement {

    @api errorList = [];
    @track isPopoverVisible = false;

    get dislayErrorIcon(){
        console.log(this.errorList);
        if(this.errorList && this.errorList.length > 0){
            return true;
        }
        return false;
    }

    get errorData(){        
        return this.errorList;
    }

    get popoverClass() {
        return "slds-popover slds-popover_tooltip ms-help-popup-in-header ${this.isPopoverVisible ? '' : 'slds-hide'}";
    }

    popOver = "slds-popover slds-popover_tooltip slds-nubbin_right slds-fall-into-ground slds-hide"

    toggleHideShow() {
        this.popOver = this.popOver == 'slds-popover slds-popover_tooltip slds-nubbin_right slds-fall-into-ground slds-hide' ? "slds-popover slds-popover_tooltip slds-nubbin_right slds-rise-from-ground" : "slds-popover slds-popover_tooltip slds-nubbin_right slds-fall-into-ground slds-hide"
    }

}