import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createCsrComment from '@salesforce/apex/eDealerCreateCsrCommentController.createCsrComment';
import getCSRHeaderTranslations from '@salesforce/apex/eDealerCreateCsrController.getCSRHeaderTranslations';
import Edealer_Create_Comment_Success from '@salesforce/label/c.Edealer_Create_Comment_Success';
import Edealer_CSR_Number_Missing from '@salesforce/label/c.Edealer_CSR_Number_Missing';
import Edealer_Ops_Failed from '@salesforce/label/c.Edealer_Ops_Failed';
import Edealer_POST from '@salesforce/label/c.Edealer_POST';
import { publish, MessageContext, subscribe, unsubscribe, createMessageContext, releaseMessageContext } from 'lightning/messageService';
import CSR_CHANNELS from '@salesforce/messageChannel/edealerCommentChannel__c';
import getCsrCommentsFromAws from '@salesforce/apex/eDealerCSRViewCommentsController.getCsrCommentsFromAws';
import fetchLoggedInUserDetails from '@salesforce/apex/eDealerCSRViewCommentsController.fetchLoggedInUserDetails';
export default class EdealerCreateCsrComment extends LightningElement {

    label = {
        Edealer_Create_Comment_Success,
        Edealer_CSR_Number_Missing,
        Edealer_Ops_Failed,
        Edealer_POST
    }
    @api disableCommentsPosting;
    @api csrNumber;
    @api dealerUserName;
    @api isNonDealer;
    csrComments = [];
    @api phase;
    @api disablePostBtn;
    comments = '';
    commentType;
    isShowSpinner = false;
    CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated
    @wire(MessageContext)
    messageContext;
    authorizationComments
    dealerComments
    miscComments
    quotecomments
    letterTopParagraphComments
    letterBottomParagraphComments
    unknownCommentType

    get disablePostMessage() {
        if (this.csrNumber) {
            if (this.disableCommentsPosting) {
                return true;
            }
           
            return false;
        }
        return true;
    }

    async connectedCallback() {
        //getting picklist value for csr header from custom metadata(translation feature enabled)
        getCSRHeaderTranslations().then((result) => {
            console.log('result getCSRHeaderTranslations---' + JSON.stringify(result));
            this.authorizationComments = result.authorizationComments[0].label;
            this.dealerComments = result.dealerComments[0].label;
            this.miscComments = result.miscComments[0].label;
            this.quotecomments = result.quotecomments[0].label;
            this.letterTopParagraphComments = result.letterTopParagraphComments[0].label;
            this.letterBottomParagraphComments = result.letterBottomParagraphComments[0].label;
            this.unknownCommentType = result.duplicateWithSR[0].label;
            this.CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated = result.CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated[0].label
        })
            .catch((error) => {
                console.log(JSON.stringify(error))
            })
            .finally(() => {
                this.isShowSpinner = false;
            });
        await this.fetchLoggedInUserDetails();
    }

    handleCreateCsrComment() {
        this.isShowSpinner = true;
        if (this.isNonDealer) {
            this.commentType = 'M';
        } else {
            this.commentType = 'D';
        }
        const detail = {
            CSRNumber: this.csrNumber,
            Phase: this.phase,
            CommentType: this.commentType,
            Comment: this.comments,
            UserName: this.dealerUserName
        };
        const textarea = this.template.querySelector('.textarea');
        if (this.csrNumber && textarea.value !== '') {
            createCsrComment({ commentsPayload: JSON.stringify(detail) })
                .then(result => {
                    this.fetchCsrComments()
                    //window.setTimeout(this.fetchCsrComments(), 5000);
                    textarea.value = '';
                    this.comments = '';
                    const evt = new ShowToastEvent({
                        title: 'CSR Comment',
                        message: this.label.Edealer_Create_Comment_Success,
                        variant: 'SUCCESS',
                    });
                    this.dispatchEvent(evt);
                    this.isShowSpinner = false;
                })
                .catch(error => {
                    const evt = new ShowToastEvent({
                        title: 'CSR Comment',
                        message: this.label.Edealer_Ops_Failed,
                        variant: 'ERROR',
                    });
                    this.dispatchEvent(evt);
                    this.isShowSpinner = false;
                });

        } else if (this.csrNumber && this.comments === '') {
            const evt = new ShowToastEvent({
                title: 'CSR Comment',
                message: 'Please fill Comment',
                variant: 'ERROR',
            });
            this.dispatchEvent(evt);
            this.isShowSpinner = false;
        }
        else {
            const evt = new ShowToastEvent({
                title: 'CSR Comment',
                message: this.label.Edealer_CSR_Number_Missing,
                variant: 'ERROR',
            });
            this.dispatchEvent(evt);
            this.isShowSpinner = false;
        }
    }

    getCommentDescription(commentCode) {


        switch (commentCode.toUpperCase()) {
            case 'A':
                return this.authorizationComments;
            case 'D':
                return this.dealerComments;
            case 'M':
                return this.miscComments;
            case 'Q':
                return this.quotecomments;
            case '1':
                return this.letterTopParagraphComments;
            case '2':
                return this.letterBottomParagraphComments;
            default:
                return this.unknownCommentType;
        }

    }

    handleCommentsChange(event) {
        this.comments = event.target.value;
    }

    // show toast message on success
    showSuccessMessage(title, message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'SUCCESS',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    // show toast message on error
    showErrorMessage(title, message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'ERROR',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    fetchCsrComments() {
        this.isLoading = true;
        getCsrCommentsFromAws({ csrNumber: this.csrNumber, csrPhase: this.phase })
            .then((results) => {
                this.handleCsrComments(JSON.parse(results));
            })
            .catch((error) => {
                console.log(error);
            })
            .finally(() => {
                this.isLoading = !this.isLoading;
            });
    }

    handleCsrComments(response) {
        let csrParseComments = JSON.parse(JSON.stringify(response));
        let comments = [];
        var commentId = 1;
        if (csrParseComments && csrParseComments.Data && csrParseComments.Data.HeaderCmts) {
            let headerComments = csrParseComments.Data.HeaderCmts;
            if (headerComments.length > 0) {
                headerComments.forEach((comment) => {
                    let hDate = comment.HDteAdded.toString();
                    console.log('hDate----' + hDate);
                    let commentObj = {
                        cmtId: commentId++,
                        cmtType: comment.HCmtType,
                        cmtDesc: this.getCommentDescription(comment.HCmtType || ''),
                        cmt: comment.HComment,
                        cmtDate: this.getFormattedDate(hDate),
                        cmtTime: this.getFormattedTime(comment.HTimeAdded),
                        cmtUser: comment.HAddUser
                    };
                    comments.push(commentObj);
                });
            }
        }

        let filteredComments = [];

        if (this.isNonDealer) {
            filteredComments = [...comments];
        } else {
            filteredComments = comments.filter(comment => comment.cmtType === "D");
        }
        this.isCommentFound = filteredComments.length > 0;
        this.csrComments = filteredComments;
        if(this.csrComments?.length > 29){
            this.disableCommentsPosting = true;
        }
        console.log('CSR Comments:::' + this.csrComments);
        publish(this.messageContext, CSR_CHANNELS, this.csrComments);
    }

    async fetchLoggedInUserDetails() {
        await fetchLoggedInUserDetails({})
            .then((results) => {
                this.isNonDealer = results.isNonDealer
            })
            .catch((error) => {
                console.log(error);
            });
    }

    getFormattedDate(dateString) {
        let year = parseInt(dateString.substring(0, 4), 10);
        let month = parseInt(dateString.substring(4, 6), 10) - 1;
        let day = parseInt(dateString.substring(6, 8), 10);
        let convertedDate = new Date(year, month, day);
        let formattedDate = convertedDate.toLocaleString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        return formattedDate;
    }
    getFormattedTime(timeString) {
        let hours = parseInt(timeString.substring(0, 2), 10);
        let minutes = parseInt(timeString.substring(2, 4), 10);
        let seconds = parseInt(timeString.substring(4, 6), 10);
        let convertedTime = new Date();
        convertedTime.setHours(hours);
        convertedTime.setMinutes(minutes);
        convertedTime.setSeconds(seconds);
        let options = { hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true };
        let formattedTime = convertedTime.toLocaleTimeString('en-US', options);
        return formattedTime;
    }

}