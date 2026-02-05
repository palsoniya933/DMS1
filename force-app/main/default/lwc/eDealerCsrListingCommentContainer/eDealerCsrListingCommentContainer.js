import { LightningElement, api } from 'lwc';

export default class EDealerCSRListingCommentContainer extends LightningElement {
@api
csrnumber
@api
phase
handleclosemodal(){
    this.dispatchEvent(new CustomEvent('closecommentmodal', {
        detail: {
            openlistingmodal: true
        }
    }));
    console.log('event dispatched');
}
}