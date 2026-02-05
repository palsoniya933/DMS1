import { LightningElement,api } from 'lwc';
export default class EdealerCsrCommentContainer extends LightningElement {
 @api csrNumber;
 @api dealerUserName;
 @api isNonDealer;
 @api csrPhase;
 @api disablePostBtn;
 disableCommentsPosting = false;

 connectedCallback() {
     console.log('----csrNumber--' + this.csrNumber);
     console.log('----csrPhase--' + this.csrPhase);
 }
 handleCommentsLoaded(event){
    if(event?.detail?.isDisableCommentPosting){
        this.disableCommentsPosting = true;
    }
    else{
        this.disableCommentsPosting = false;
    }
 }
}