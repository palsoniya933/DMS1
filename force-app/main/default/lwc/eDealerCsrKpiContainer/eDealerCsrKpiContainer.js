import { LightningElement, api,wire} from 'lwc';
import { publish,MessageContext,subscribe,unsubscribe,createMessageContext,releaseMessageContext } from 'lightning/messageService';
import getCSRDashboardTranslations from '@salesforce/apex/EDealerActiveCsrController.getCSRDashboardTranslations'
import CSR_CHANNEL from '@salesforce/messageChannel/eDealerCSR__c';

export default class EDealerCsrKpiContainer extends LightningElement {
    @api selectedmenu 
    @api selectedlocation
    @api selectedlocationstring;

    @api selectedlocationlist
    @api division
    @api accessibledealerslocs
    @api isnondealer
    @api userDetail
    @api dealerCode
    @api dealerUserName
    
    activeSections = ['CSR'];

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
    }

    accordionTitle
    dashboardTranslation
    csrlistTranslation
    dealercodeListString 
    connectedCallback(){
        console.log('this.selectedlocationstring: '+this.selectedlocationstring);
    	this.selectedLocation = JSON.parse(this.selectedlocationstring);
        console.log(this.selectedlocation.listSelectedLoc);
        if(this.selectedLocation.listSelectedLoc!=null && this.selectedLocation.listSelectedLoc!= undefined){
          console.log('if connected callback');
            this.selectedlocationlist = this.selectedLocation.listSelectedLoc;
            
            this.dealercodeListString = JSON.stringify(this.selectedLocation.listSelectedLoc);


        }
        else if(this.selectedLocation.selectedLoc !=null && this.selectedLocation.selectedLoc!= undefined){
            let listDealerLoc = [];
            console.log('else if connected callback');

            listDealerLoc.push(this.selectedLocation.selectedLoc);
            
            let selectedlocobj = {
                selectedLoc : this.selectedLocation.selectedLoc,
                listSelectedLoc : listDealerLoc
            };

            this.selectedLocation = selectedlocobj;
            this.selectedlocationlist = this.selectedLocation.listSelectedLoc;
            this.dealerCode = this.selectedLocation.selectedLoc;
            this.dealercodeListString = JSON.stringify(this.selectedLocation.listSelectedLoc);
            this.selectedlocationstring = JSON.stringify(this.selectedLocation)
        }
        
        console.log('dealercodeListString: '+this.dealercodeListString);

        this.subscribeToMessageChannel();

        getCSRDashboardTranslations()
        .then((result) => {
            console.log(JSON.stringify(result));
            this.accordionTitle = result.csr.label
            this.dashboardTranslation = result.dashboard.label
            this.csrlistTranslation = result.activecsr.label
            console.log(' this.accordionTitle: '+ this.accordionTitle);
            console.log(' this.dashboardTranslation: '+ this.dashboardTranslation);
            console.log(' this.csrlistTranslation: '+ this.csrlistTranslation);
            

            const updateheader = new CustomEvent('updateheaderkpicontainer', {
                detail : {
                     "dashboardTranslation": this.dashboardTranslation,
                     "csrlistTranslation" : ''
                }
            });
            this.dispatchEvent(updateheader);
          })
            .catch((error) => {
              console.log('picklist error::' + JSON.stringify(error));
          });
    }
    disconnectedCallback(){
        this.unsubscribeToMessageChannel();
        
    }
    
   
    @wire(MessageContext)
    messageContext;
    
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                CSR_CHANNEL,
                (message) => this.handleMessageChannelEvent(message),
                );
                
            }
        }
        
        unsubscribeToMessageChannel() {
            
            unsubscribe(this.subscription);
            this.subscription = null;
        }
        handleMessageChannelEvent(message){

            if(message.detail == 'refreshlocation'){
                console.log('refreshlocation event received on kpi container')
                console.log('location obj refresh: '+JSON.stringify(this.selectedlocation));

                //this.selectedLocation = JSON.parse(this.selectedlocationstring);
                this.selectedlocationlist = this.selectedlocation.listSelectedLoc;
                this.dealercodeListString = JSON.stringify(this.selectedlocation.listSelectedLoc);
                this.updateChildrenKPI();
            }
            else if(message.detail == 'showlisting'){
                console.log('debug event kpicontainer'+JSON.stringify(message))
                const csrlistingoption = message.listingType;
                const dealercodes = message.dealercodes;
                const frequency = message.frequency;
                const csrtype = message.csrtype;
                
                if(message.listingType == 'activecsrlisting'){
                    const opencsrlistingEvent = new CustomEvent('opencsrlisting', {
                        detail: {csrlistingoption,dealercodes,frequency,csrtype}
                    });
                    this.dispatchEvent(opencsrlistingEvent);
                }
                else if(message.listingType == 'mycsrlisting'){
                    const dealercodes = message.dealercodes;
                    const opendraftcsrsEvent = new CustomEvent('opencsrlisting', {
                        detail: {csrlistingoption,dealercodes,frequency,csrtype}
                    });
                    this.dispatchEvent(opendraftcsrsEvent);
                }
                else if(message.listingType == 'pendingcsrlisting'){
                    const dealercodes = message.dealercodes;
                    const openpendingcsrsEvent = new CustomEvent('opencsrlisting', {
                        detail: {csrlistingoption,dealercodes,frequency,csrtype}
                    });
                    this.dispatchEvent(openpendingcsrsEvent);
                }
               
            }
           
            else if(message.detail== 'showlistingnewwindow'){
                console.log('debug event kpicontainer'+JSON.stringify(message))
                const csrlistingoption = message.listingType;
                const dealercodes = message.dealercodes;
                const frequency = message.frequency;
                const csrtype = message.csrtype;
                const opencsrlistingEvent = new CustomEvent('opencsrlistingnewwindow', {
                    detail: {csrlistingoption,dealercodes,frequency,csrtype},
                });
                this.dispatchEvent(opencsrlistingEvent);
            }
            else{
                console.log('event not mapped');
            }
            
        }

        updateChildrenKPI() {
            this.template.querySelector("c-e-dealer-active-csr-tile").handleLocUpdate(this.selectedlocationstring);
            this.template.querySelector("c-e-dealer-my-csr-tile").handleLocUpdate(this.selectedlocationstring);
            this.template.querySelector("c-e-dealer-pending-csr-tile").handleLocUpdate(this.selectedlocationstring);
          }
    }