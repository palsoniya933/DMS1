import { LightningElement, api } from 'lwc';

export default class EDealerCsrListingFileContainer extends LightningElement {
@api
csrnumber
@api
phase
@api
dealercode

    handleclosemodal(){
        this.dispatchEvent(new CustomEvent('closefilesmodal', {
            detail: {
                openlistingmodal: true
            }
        }));
        console.log('event dispatched');
    }

}