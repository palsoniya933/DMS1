import { LightningElement, api } from 'lwc';
import getCsrStatus from '@salesforce/apex/EDealerCsrStatusController.getCsrStatus';
export default class EdealerCsrStatus extends LightningElement {
    @api currentStep;
    stages = [];
    allSteps = [];
    uniqueStages = [];
    isCompleted = true;
    connectedCallback() {
        getCsrStatus().then((result) => {
            let allSteps = [...result];
            this.allSteps = [...result];
            this.getUniqueLabels(allSteps);
        })
            .catch((error) => {
                this.error = error;
            });
    }

    get isIncomplete() {
        return this.isCompleted ? 'slds-path__item slds-is-complete' : 'slds-path__item slds-is-incomplete';
    }
    get isSelectedtab() {
        this.isCompleted = false;
        return 'slds-path__item slds-is-current slds-is-active';
    }
    get getStages() {
        this.getUniqueLabels(this.allSteps);
        return this.stages;
    }
    getUniqueLabels(allSteps) {
        let uniques = [];
        allSteps.forEach(({ label, value }) => {
            //Check if the label is not in the object, or has the specific value
            if (!uniques[label] || value === this.currentStep) {
                uniques[label] = { label, value, isSelected: value === this.currentStep };
            }
        });
        this.stages = Object.values(uniques);
    }
}