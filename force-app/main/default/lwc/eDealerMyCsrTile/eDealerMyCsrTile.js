import { LightningElement, api, track, wire } from 'lwc';
import { publish,MessageContext,subscribe,unsubscribe,createMessageContext,releaseMessageContext } from 'lightning/messageService';
import CSR_CHANNEL from '@salesforce/messageChannel/eDealerCSR__c';
import getCSRTileTranslations from '@salesforce/apex/EDealerDraftCsrController.getMyCSRTileTranslations';
import getCSRs from '@salesforce/apex/EDealerDraftCsrController.getMyCSR';

export default class EDealerMyCsrTile extends LightningElement {
    @api dealercode;
    @api dealercodelist;
    @api selectedlocobj

    @track error;
    @track displayLoading = false;
    translations;
    title;
    hasDealerLoc;
    @api draftcsrcount;
    csrData;
    allcsr; //Frecuency All 
    @wire(MessageContext)
    messageContext;
    selectedTimespan='ALL'
    MyCsrValue = 'All'
    Edealer_My_CSR_Tile_Help = ""
    Edealer_My_CSR_Tile_ErrorMsg = ""

    connectedCallback(){
        //this.selectedlocobj = JSON.parse(this.selectedlocobj);
        console.log('selectedlocobj'+this.selectedlocobj);
        console.log('dealercodelist'+this.dealercodelist);
        this.displayLoading = true;
        this.draftcsrcount = 0;
        this.csrData = undefined;
        this.getCSRTileTranslations();
        this.getCSRs();
    }

    getCSRTileTranslations(){
        getCSRTileTranslations()
        .then((result) => {
            console.log('result: '+JSON.stringify(result))
            this.error = undefined;
            this.translations = result;
            this.title = result.csrTitle.label;
            this.MyCsrValue = result.csrType[0].label;
            this.Edealer_My_CSR_Tile_Help = result.helpText.label
            this.Edealer_My_CSR_Tile_ErrorMsg = result.errorMsg.label
        }).catch((error) => {
            this.displayLoading = false;
            this.title = undefined;
            this.translations = undefined;
            this.error = "Unknown error";
    
            console.log('**Get translation error => ' + JSON.stringify(error));
          });
    }
    

    getCSRs(){
        const dealercodes = typeof this.dealercodelist == 'string'? JSON.parse(this.dealercodelist): this.dealercodelist ;
        //const dealercodes = [ "K270-100", "K270-200", "K290-002", "K290-003", "K290-005", "K290-006", "K290-007", "K290-008", "K291-001", "K291-006", "K300-001", "K301-001", "K302-001", "K302-002", "K302-003", "K302-004", "K302-005", "K302-006", "K302-007", "M535-001", "M535-100", "P181-017", "P187", "P255", "P255-004", "P255-007", "P255-009", "P255-010", "P255-011", "P255-012", "P255-013", "P255-014", "P255-015", "P255-016", "P255-017", "P255-018", "P255-019", "P255-020", "P255-021", "P255-022", "P255-024", "P255-026", "P255-027", "P255-028", "P255-029", "P255-030", "P255-031", "P255-032", "P255-033", "P255-034", "P255-036", "P255-037", "P255-038", "P255-039", "P255-040", "P255-042", "P255-043", "P255-044", "P255-045", "P256", "P256-002", "P256-003", "P256-004", "P257", "P257-005", "P257-006", "P258", "P258-002", "P259", "P259-001", "P260", "P260-001", "P260-002", "P260-003", "P265", "P265-004", "P266", "P267", "P267-001", "P353", "P353-001", "P410", "P410-001", "P410-002", "P410-003", "P411", "P411-001", "P411-002", "P411-003", "P412", "P412-001", "P412-002", "P412-003", "P412-004", "P413", "P413-001", "P413-002", "P413-003", "P413-004", "P413-005", "P414", "P416", "P416-001", "P418", "P418-001", "P418-002", "P418-003", "P418-004", "P418-005", "P419", "P419-001", "P419-002", "Q179", "R240-001", "R240-100", "R240-200", "V941", "V941-001", "V941-002", "V941-003", "V941-004", "V941-005", "V941-006", "V958", "Z016", "Z058", "Z058-001", "Z064", "Z064-001", "Z065", "Z065-001", "Z066", "Z066-001", "Z071", "Z071-001", "Z074", "Z074-001", "Z080", "Z080-001", "Z083", "Z083-001", "Z083-002", "Z083-003", "Z091", "Z091-001", "Z092", "Z092-001", "Z093", "Z093-001", "Z094", "Z094-001", "Z102", "Z102-001", "Z108-001", "Z109", "Z109-001", "Z110", "Z110-001", "Z119", "Z119-001", "Z127", "Z127-001", "Z160", "Z160-001", "Z175-001", "Z198", "Z198-001", "Z200", "Z200-001", "Z213", "Z213-001", "Z214", "Z214-001", "Z230", "Z230-001", "Z244", "Z250", "Z250-001", "Z263", "Z263-001", "Z280", "Z316", "Z316-001", "Z329", "Z329-001", "Z330", "Z330-001", "Z330-002", "Z330-003", "Z332", "Z332-001", "Z358", "Z358-001", "Z476", "Z504", "Z674", "Z717", "Z717-001", "Z762", "Z941", "Z941-001", "Z951", "Z951-001", "Z951-002" ];

       getCSRs({"dealerCodeList" : dealercodes})
          .then((result) => {
            console.log(result)
            this.error = undefined;
            this.displayLoading = false;
            this.csrData = JSON.parse(result);
            if(this.csrData){
                let draftcsrcount = this.csrData[this.selectedTimespan]['N'];
                console.log('draftcsrcount: '+ draftcsrcount)
                this.draftcsrcount = draftcsrcount; 
                this.hasDealerLoc = ((dealercodes!= null && dealercodes.length==1) && draftcsrcount != 0 ) ? true : false;
                this.enableSamePageListing = (dealercodes!= null && this.draftcsrcount != 0 ) ? true : false;

            }
          })
          .catch((error) => {
            this.displayLoading = false;
            this.csrData = undefined;
            this.error = "Unknown error";
            
            console.log('**Get CSR´s error => ' + JSON.stringify(error));
          });
    }

    
    @api
    handleLocUpdate(receiveddealerlist){
        console.log('handleLocUpdate');
        console.log('this.dealercodeList'+ typeof receiveddealerlist)
        console.log('this.dealercodeList'+  receiveddealerlist)
        this.displayLoading = true;
        this.selectedlocobj = typeof receiveddealerlist == 'string'? JSON.parse(receiveddealerlist): receiveddealerlist ;
        this.dealercodelist= typeof receiveddealerlist == 'string'? JSON.parse(receiveddealerlist).listSelectedLoc : receiveddealerlist.listSelectedLoc ;

        this.getCSRs();
      }

    openCsrListing() {
        console.log('this.selectedlocobj openCsrListing: '+typeof this.selectedlocobj);
        console.log('this.selectedlocobj openCsrListing: '+ this.selectedlocobj);
        const selectedobj = typeof this.selectedlocobj == 'string'? JSON.parse(this.selectedlocobj): this.selectedlocobj ;

        const message = { 
            "detail" : 'showlisting',
            "listingType" : 'mycsrlisting',
            "csrtype" : 'ALL',
            "dealercodes" : selectedobj,
            "frequency": 'ALL'
        };
        publish(this.messageContext, CSR_CHANNEL, message);
    }
    
    handleOpenInNewWindow() {
        // Add your logic here
        const selectedobj = typeof this.selectedlocobj == 'string'? JSON.parse(this.selectedlocobj): this.selectedlocobj ;
        const message = { 
            "detail" : 'showlistingnewwindow',
            "listingType" : 'mycsrlisting',
            "csrtype" : 'ALL',
            "dealercodes" : selectedobj,
            "frequency": 'ALL'
        };
        publish(this.messageContext, CSR_CHANNEL, message);
    }
}