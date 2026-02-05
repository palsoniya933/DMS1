import { LightningElement, api, wire, track } from 'lwc';
import getCsrCommentsFromAws from '@salesforce/apex/eDealerCSRViewCommentsController.getCsrCommentsFromAws';
import getCommentsColumnHeaders from '@salesforce/apex/eDealerCSRViewCommentsController.getCommentsColumnHeaders';
import fetchLoggedInUserDetails from '@salesforce/apex/eDealerCSRViewCommentsController.fetchLoggedInUserDetails';
import getCSRHeaderTranslations from '@salesforce/apex/eDealerCreateCsrController.getCSRHeaderTranslations';
import EDealer_CSR_Comments_Not_Found from '@salesforce/label/c.EDealer_CSR_Comments_Not_Found';
import { publish, MessageContext, subscribe, unsubscribe, createMessageContext, releaseMessageContext } from 'lightning/messageService';
import CSR_CHANNELS from '@salesforce/messageChannel/edealerCommentChannel__c';
export default class EdealerCsrViewComment extends LightningElement {

    @api csrNumber;
    @api phase;
    dealerUserName;

    authorizationComments
    dealerComments
    miscComments
    quotecomments
    letterTopParagraphComments
    letterBottomParagraphComments
    unknownCommentType
    isNonDealer;
    isLoading = true;
    isCommentFound = false;
    columnLabelByApiName = [];
    @track csrComments = [];
    label = { EDealer_CSR_Comments_Not_Found };
    subscription = null;
    @wire(MessageContext)
    messageContext;
    get showError() {
        return !this.isLoading && !this.isCommentFound;
    }

    async connectedCallback() {
        this.subscribeToMessageChannel();
        await this.fetchCommentsColumnHeaders();
        await this.getCsrTranslation();
        await this.fetchLoggedInUserDetails();
        if (this.csrNumber) {
            await this.fetchCsrComments();
        }


    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                CSR_CHANNELS,
                (message) => this.handleRefreshEvent(message),
            );
        }

    }

    async getCsrTranslation() {
        getCSRHeaderTranslations().then((result) => {
            console.log('result-121--' + JSON.stringify(result));
            this.authorizationComments = result.authorizationComments[0].label;
            this.dealerComments = result.dealerComments[0].label;
            this.miscComments = result.miscComments[0].label;
            this.quotecomments = result.quotecomments[0].label;
            this.letterTopParagraphComments = result.letterTopParagraphComments[0].label;
            this.letterBottomParagraphComments = result.letterBottomParagraphComments[0].label;
            this.unknownCommentType = result.duplicateWithSR[0].label;
        })
            .catch((error) => {
                this.isLoading = false;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleRefreshEvent(message) {
        this.csrComments = [...message];
        this.isCommentFound = this.csrComments.length > 0;

    }

    get getComments() {
        return this.csrComments;
    }
    get commentFound() {
        return this.csrComments.length > 0
    }

    async fetchCsrComments() {
        console.log('----csrnumber--' + this.csrNumber);
        console.log('----phase--' + this.phase);
        await getCsrCommentsFromAws({ csrNumber: this.csrNumber, csrPhase: this.phase })
            .then((results) => {
                console.log('----results--' + results);
                this.handleCsrComments(JSON.parse(results));
            })
            .catch((error) => {
                console.log(error);
                this.isLoading = false;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    async fetchCommentsColumnHeaders() {
        debugger;
        await getCommentsColumnHeaders({})
            .then((results) => {
                this.columnLabelByApiName = [...results];

            })
            .catch((error) => {
                console.log(error);
                this.isLoading = false;
            });

    }


    handleCsrComments(response) {

        let csrParseComments = JSON.parse(JSON.stringify(response));
        console.log('csrParseComments----' + JSON.stringify(csrParseComments));
        let comments = [];
        var commentId = 1;
        if (csrParseComments && csrParseComments.Data && csrParseComments.Data.HeaderCmts) {

            let headerComments = csrParseComments.Data.HeaderCmts;
            console.log('headerComments----' + JSON.stringify(headerComments));
            if (headerComments.length > 0) {
                headerComments.forEach(comment => {
                    console.log(' comment.HDteAdded.toString()====' + comment.HDteAdded.toString())
                    let hDate = comment.HDteAdded.toString();
                    let hTime = comment.HTimeAdded.toString();
                    let commentObj = {
                        cmtId: commentId++,
                        cmtType: comment.HCmtType,
                        cmtDesc: this.getCommentDescription(comment.HCmtType || ''),
                        cmt: comment.HComment,
                        cmtDate: this.getFormattedDate(hDate),
                        cmtTime: this.getFormattedTime(hTime),
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

        this.dispatchEvent(new CustomEvent("commentsloaded", {
            'detail': {
                'isDisableCommentPosting': this.csrComments?.length > 29 
            }
        }));

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

    async fetchLoggedInUserDetails() {
        await fetchLoggedInUserDetails({})
            .then((results) => {
                let user = results.asiUserName;
                this.isNonDealer = results.isNonDealer
            })
            .catch((error) => {
                console.log(error);
                this.isLoading = false;
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