import { LightningElement, api, track, wire } from 'lwc';
import getAllowedQtyCSRType from '@salesforce/apex/eDealerCsrPartListController.getAllowedQtyCSRType';
import getCSRHeaderTranslations from '@salesforce/apex/eDealerCreateCsrController.getCSRHeaderTranslations';
import EDealer_DEALER_CUSTOMER_INFORMATION from '@salesforce/label/c.EDealer_DEALER_CUSTOMER_INFORMATION';
import EDealer_Dealer_Type from '@salesforce/label/c.EDealer_Dealer_Type';
import EDealer_CSR_Type from '@salesforce/label/c.EDealer_CSR_Type';
import EDealer_Competitive_Type from '@salesforce/label/c.EDealer_Competitive_Type';
import EDealer_Dealer from '@salesforce/label/c.EDealer_Dealer';
import EDealer_Customer_Name from '@salesforce/label/c.EDealer_Customer_Name';
import EDealer_Chassis_Number from '@salesforce/label/c.EDealer_Chassis_Number';
import EDealer_Insurance_Company from '@salesforce/label/c.EDealer_Insurance_Company';
import EDealer_Write_Off from '@salesforce/label/c.EDealer_Write_Off';
import EDealer_Dealer_Discount from '@salesforce/label/c.EDealer_Dealer_Discount';
//import EDealer_Duration from '@salesforce/label/c.EDealer_Duration';
//import EDealer_Expected_Markup from '@salesforce/label/c.EDealer_Expected_Markup';
import EDealer_Complete_This_Field_Error_Message from '@salesforce/label/c.EDealer_Complete_This_Field_Error_Message';
import EDealer_CSR_Number from '@salesforce/label/c.EDealer_CSR_Number';
import EDealer_CSR_Phase from '@salesforce/label/c.EDealer_CSR_Phase';
import EDEALER_ERROR from '@salesforce/label/c.eDealer_error';
import { publish, MessageContext, subscribe, unsubscribe, createMessageContext, releaseMessageContext } from 'lightning/messageService';
import CSR_CHANNEL from '@salesforce/messageChannel/eDealerCSR__c';
import getCsrRecordDetail from '@salesforce/apex/eDealerCsrRecordDataController.getCSRDetails';
import getFilesByCSRNumberAndPhase from '@salesforce/apex/eDealerCsrRecordDataController.getFilesByCSRNumberAndPhase';
import getCsrStatus from '@salesforce/apex/EDealerCsrStatusController.getCsrStatus';
import EDealer_Chassis_Number_Error_Message from '@salesforce/label/c.EDealer_Chassis_Number_Error_Message';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EDealerCreateCSR extends LightningElement {

  //custom label used for tranlslation and to show text or message on UI 
  label = {
    EDealer_DEALER_CUSTOMER_INFORMATION,
    EDealer_Dealer_Type,
    EDealer_CSR_Type,
    EDealer_Competitive_Type,
    EDealer_Dealer,
    EDealer_Customer_Name,
    EDealer_Complete_This_Field_Error_Message,
    EDealer_Chassis_Number,
    EDealer_Insurance_Company,
    EDealer_Write_Off,
    EDealer_Dealer_Discount,
    EDealer_CSR_Number,
    EDealer_CSR_Phase,
    EDEALER_ERROR,
    EDealer_Chassis_Number_Error_Message
  };

  @wire(MessageContext)
  messageContext;
  dealerCodeForFile;
  subscription = null;
  @api isValid = false;
  currentStatus = 'N';
  displayStatus = 'Draft';
  csrOptions;
  competitiveTypeOptions;
  dealerTypeOptions;
  @api dealerUserName;
  @api selectedLocation;
  @api selectedlocationstring;
  selectedlocationlist
  @api division;
  @api accessibleDealersLocs = [];
  @api isNonDealer;
  @api dealerCode;
  @api lstSelectedLocation;
  @api csrType;
  @api dealerType;
  @api customerName = '';
  @api competitiveType;
  @api chassisNumber = '';
  @api insuranceCompany = '';
  @api dealerDiscount = 0;
  @api writeOffvalue = 0;
  @api duration = 0;
  @api expectedMarkup = 0;
  isCsrDataSubmitted = false;
  @wire(getAllowedQtyCSRType, {})
  allowedQuantityCSRType;
  listLocation = [];
  @api csrNumber;
  @api csrPhase;
  @api enableCsrEditing;
  csrDetails;
  isCustomerNameRequired = false;
  isLoading = false;
  isShowSpinner = false;
  isCsrNumberVisible;
  isCsrPhaseVisible;
  @api blockquantityfieldonsearch;
  showHideWreck = false;
  showHideBlindBid = false;
  durationLabel

  expectedMarkupLabel
  positiveValidationError
  durationValidationError
  markupValidationError
  csrStatusLabel
  csrNumberLabel
  csrPhaseLabel
  invalidPartNumber
  duplicateWithSR
  authorizationComments
  dealerComments
  miscComments
  quotecomments
  letterTopParagraphComments
  letterBottomParagraphComments
  unknownCommentType
  CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated
  partList;
  @api mode;
  isCustomerNameRequired = true;
  receivedFile = [];
  @track base64result = [];
  fileDetails;
  errorOccurred = false;
  errorMessage = '';
  apiError = false;
  dealerCodeExistForCsr = true;
  csrIsNotAvailable;
  eDealerExpectedMarkupErrorMessage;



  async connectedCallback() {
    console.log('this.selectedlocationstring:::' + JSON.stringify(this.selectedlocationstring));
    this.selectedLocation = JSON.parse(this.selectedlocationstring);
    console.log('this.csrIsNotAvailable:::' + this.csrIsNotAvailable);
    if (this.isNonDealer && typeof this.selectedLocation === "string" && typeof this.selectedLocation.valueOf() === "string") {
      this.dealerCode = this.selectedLocation;
    }
    else {
      if (this.selectedLocation.listSelectedLoc != null && this.selectedLocation.listSelectedLoc != undefined) {
        this.selectedlocationlist = this.selectedLocation.listSelectedLoc;
      }
      else if (this.selectedLocation.selectedLoc != null && this.selectedLocation.selectedLoc != undefined) {
        console.log('no location list');
        let listDealerLoc = [];
        listDealerLoc.push(this.selectedLocation.selectedLoc);

        let selectedlocobj = {
          selectedLoc: this.selectedLocation.selectedLoc,
          listSelectedLoc: listDealerLoc
        };
        this.selectedLocation = selectedlocobj;
        this.selectedlocationlist = this.selectedLocation.listSelectedLoc;
        this.dealerCode = this.selectedLocation.selectedLoc;
      }
    }


    this.subscribeToMessageChannel();
    this.isShowSpinner = true;


    this.handleLocationChange();
    await this.getCSRTranslation();
    //getting csr and parts detail for edit mode

    if (this.csrNumber && this.csrPhase && this.enableCsrEditing) {

      this.isCsrDataSubmitted = false;
      this.mode = 'Edit';
      console.log('this.csrNumber.length----' + this.csrNumber.length);
      if (this.csrNumber.length != 8) {
        this.showError(this.csrIsNotAvailable);
      } else {
        this.editMode();
      }

      // this.editMode();
    }
    else if (this.csrNumber && this.csrPhase && !this.enableCsrEditing) {
      this.mode = 'View';
      if (this.csrNumber.length != 8) {
        this.showError(this.csrIsNotAvailable);
      } else {
        this.viewMode();
      }
      //this.viewMode();
    }
    else {
      console.log('createmode')
      this.mode = 'Create';
      this.isShowSpinner = false;
    }

  }

  get getMode() {
    return this.mode;
  }

  get isCsrFormSubmited() {
    return (this.isCsrDataSubmitted || !this.enableCsrEditing);
  }

  async getCSRTranslation() {
    //getting picklist value for csr header from custom metadata(translation feature enabled)
    await getCSRHeaderTranslations().then((result) => {
       console.log('result--444---'+JSON.stringify(result));
      this.dealerTypeOptions = result.dealerTypePicklist;
      this.competitiveTypeOptions = result.competitveTypePicklist;
      this.csrOptions = result.csrTypePicklist;
      this.durationLabel = result.duration[0].label;
      this.expectedMarkupLabel = result.expectedMarkup[0].label;
      //this.positiveValidationError = result.positiveValidationError[0].label;
      this.durationValidationError = result.durationValidationError[0].label;
      this.markupValidationError = result.markupValidationError[0].label;
      this.csrStatusLabel = result.csrStatus[0].label;
      this.csrNumberLabel = result.csrNumber[0].label;
      this.csrPhaseLabel = result.csrPhase[0].label;
      this.duplicateWithSR = result.duplicateWithSR[0].label;
      this.invalidPartNumber = result.invalidPartNumber[0].label;
      this.authorizationComments = result.authorizationComments[0].label;
      this.dealerComments = result.dealerComments[0].label;
      this.miscComments = result.miscComments[0].label;
      this.quotecomments = result.quotecomments[0].label;
      this.letterTopParagraphComments = result.letterTopParagraphComments[0].label;
      this.letterBottomParagraphComments = result.letterBottomParagraphComments[0].label;
      this.unknownCommentType = result.unknownCommentType[0].label;
      this.csrIsNotAvailable = result.CSRisNotAvailable[0].label;
      console.log('this.csrIsNotAvailable-----' + this.csrIsNotAvailable)
      this.CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated = result.CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated[0].label
      this.eDealerExpectedMarkupErrorMessage = result.addCompetitorAddress.EDealerExpectedMarkupErrorMessage[0].label
      console.log('Expected Markup Error ' + this.EDealerExpectedMarkupErrorMessage)
    })
      .catch((error) => {
        console.log(JSON.stringify(error))
      });
  }
  editMode() {
    let loc = JSON.parse(this.selectedlocationstring);
    if (loc.selectedLoc) {
      this.dealerCode = loc.selectedLoc;
    }

    getCsrRecordDetail({ csrNumber: this.csrNumber, csrPhase: this.csrPhase, dealerCode: this.dealerCode })
      .then((result) => {

        console.log('getCsrRecordDetail----' + JSON.stringify(result));

        this.csrDetails = JSON.parse(result);
        console.log('this.csrDetails----' + this.csrDetails);
        let apiError = this.csrDetails['apiError'];
        if (apiError) {
          this.showError(apiError);
        } else if (!this.csrDetails || !this.csrDetails.Data || !this.csrDetails.Data.CsrStat) {
          if (this.csrDetails?.ErrorResponse?.ErrorMessages?.[0]?.ErrorIdentifier) {
            this.showError(this.csrDetails.ErrorResponse.ErrorMessages[0].ErrorIdentifier);
          }
        } else {
          let doesDealHaveAccess = this.validateCSRWithDealerCodeForLoggedInUser(this.csrDetails.Data.DealerId);
          if (!doesDealHaveAccess) {
            this.isCsrDataSubmitted = true;
            return
          }
          this.csrStatus = this.csrDetails.Data.CsrStat;
          const inProcessStatusList = ['D', 'M', 'S', 'U', 'A', 'X', 'I'];
          this.displayStatus = this.csrStatus == 'N' ? 'Draft' :
            this.csrStatus == 'P' ? 'Posted' :
              this.csrStatus == 'R' ? 'Denied' :
                this.csrStatus == 'E' ? 'Expired' :
                  this.csrStatus == 'C' ? 'Canceled' :
                    this.csrStatus == 'T' ? 'Terminated' :
                      this.csrStatus == 'W' ? 'Waiting Dealer Response' :
                        inProcessStatusList.includes(this.csrStatus) ? 'In Process' : this.csrStatus

          const dealerCodeExist = this.listLocation.some(item => item.value === this.csrDetails.Data.DealerId || item.value === this.csrDetails.Data.DealerId + '-' + this.csrDetails.Data.DealerSfx);
          if (!dealerCodeExist) {
            this.accessibleDealersLocs = [...this.accessibleDealersLocs, { ASI_Dealer_Code__c: this.csrDetails.Data.DealerId, Sub_Code__c: this.csrDetails.Data.DealerSfx }];
          }
          this.dealerCode = this.csrDetails.Data.DealerId + (this.csrDetails.Data.DealerSfx ? '-' + this.csrDetails.Data.DealerSfx : '');
          this.dealerType = this.csrDetails.Data.DlrType;
          this.csrType = this.csrDetails.Data.CsrType;
          this.competitiveType = (this.csrDetails.Data.CompType === 'R' || this.csrDetails.Data.CompType === 'B') ? 'B' : 'A';
          const customerNameInput = this.template.querySelector('[data-id="customerNameInput"]');
          if (this.competitiveType == 'A') {
            customerNameInput.value = '';
            customerNameInput.disabled = true;

          } else {
            customerNameInput.disabled = false;
          }
          this.customerName = this.csrDetails.Data.CustomerName;
          this.chassisNumber = this.csrDetails.Data.Chassi;
          this.insuranceCompany = this.csrDetails.Data.InsComp;
          this.dealerDiscount = this.csrDetails.Data.DlrDisc;
          this.writeOffvalue = this.csrDetails.Data.WriteOff;
          this.duration = this.csrDetails.Data.DurBid;
          this.expectedMarkup = this.csrDetails.Data.ExpMarkUp;
          this.partList = this.csrDetails.Data.CsrLines;
          if (this.csrType == 'W') {
            this.showHideWreck = true;
            this.showHideBlindBid = false;
          }
          else if (this.csrType == 'B') {
            this.showHideWreck = false;
            this.showHideBlindBid = true;
          }
          else {
            this.showHideWreck = false;
            this.showHideBlindBid = false;

          }


          this.currentStatus = this.csrDetails.Data.CsrStat;
          if (this.currentStatus != 'N') {
            this.isCsrDataSubmitted = true;

            this.handleCsrType(this.csrType);
          }
          this.fileByCSRNumberAndPhase();

        }
      }).catch((error) => {
        this.partList = undefined;
      })
      .finally(() => {
        this.isShowSpinner = false;
      });
  }



  showError(apiError) {
    const evt = new ShowToastEvent({
      title: this.label.EDEALER_ERROR,
      message: apiError,
      variant: 'ERROR',
      mode: 'sticky'
    });
    this.dispatchEvent(evt);
  }
  viewMode() {
    let loc = JSON.parse(this.selectedlocationstring);
    if (loc.selectedLoc) {
      this.dealerCode = loc.selectedLoc;
    }
    getCsrRecordDetail({ csrNumber: this.csrNumber, csrPhase: this.csrPhase, dealerCode: this.dealerCode })
      .then((result) => {
        this.csrDetails = JSON.parse(result);
        console.log('this.csrDetails---' + JSON.stringify(this.csrDetails));
        let apiError = this.csrDetails['apiError'];


        if (apiError) {
          this.showError(apiError);
        } else if (!this.csrDetails || !this.csrDetails.Data || !this.csrDetails.Data.CsrStat) {
          if (this.csrDetails?.ErrorResponse?.ErrorMessages?.[0]?.ErrorIdentifier) {
            this.showError(this.csrDetails.ErrorResponse.ErrorMessages[0].ErrorIdentifier);//to show invalid toast message
          }
        } else {
          this.csrStatus = this.csrDetails.Data.CsrStat;
          let doesDealHaveAccess = this.validateCSRWithDealerCodeForLoggedInUser(this.csrDetails.Data.DealerId);
          if (!doesDealHaveAccess) {
            this.isCsrDataSubmitted = true;
            return;
          }
          const inProcessStatusList = ['D', 'M', 'S', 'U', 'A', 'X', 'I'];
          this.displayStatus = this.csrStatus == 'N' ? 'Draft' :
            this.csrStatus == 'P' ? 'Posted' :
              this.csrStatus == 'R' ? 'Denied' :
                this.csrStatus == 'E' ? 'Expired' :
                  this.csrStatus == 'C' ? 'Canceled' :
                    this.csrStatus == 'T' ? 'Terminated' :
                      this.csrStatus == 'W' ? 'Waiting Dealer Response' :
                        inProcessStatusList.includes(this.csrStatus) ? 'In Process' : this.csrStatus

          const dealerCodeExist = this.listLocation.some(item => item.value === this.csrDetails.Data.DealerId || item.value === this.csrDetails.Data.DealerId + '-' + this.csrDetails.Data.DealerSfx);
          if (!dealerCodeExist) {
            this.accessibleDealersLocs = [...this.accessibleDealersLocs, { ASI_Dealer_Code__c: this.csrDetails.Data.DealerId, Sub_Code__c: this.csrDetails.Data.DealerSfx }];
          }
          this.dealerCode = this.csrDetails.Data.DealerId + (this.csrDetails.Data.DealerSfx ? '-' + this.csrDetails.Data.DealerSfx : '');
          this.dealerType = this.csrDetails.Data.DlrType;
          this.csrType = this.csrDetails.Data.CsrType;
          this.competitiveType = (this.csrDetails.Data.CompType === 'R' || this.csrDetails.Data.CompType === 'B') ? 'B' : 'A'; this.customerName = this.csrDetails.Data.CustomerName;
          this.chassisNumber = this.csrDetails.Data.Chassi;
          this.insuranceCompany = this.csrDetails.Data.InsComp;
          this.dealerDiscount = this.csrDetails.Data.DlrDisc;
          this.writeOffvalue = this.csrDetails.Data.WriteOff;
          this.duration = this.csrDetails.Data.DurBid;
          this.expectedMarkup = this.csrDetails.Data.ExpMarkUp;
          this.partList = this.csrDetails.Data.CsrLines;

          this.currentStatus = this.csrDetails.Data.CsrStat;
          if (this.currentStatus != 'N') {
            this.isCsrDataSubmitted = true;
          this.handleCsrType(this.csrType);

          }
          this.fileByCSRNumberAndPhase();
          
        }
      }).catch((error) => {
        console.log('error---' + error);
        this.partList = undefined;
        console.error('**Error getting details => ', JSON.stringify(error));
      })
      .finally(() => {
        this.isShowSpinner = false;
      });
  }


  fileByCSRNumberAndPhase() {
    getFilesByCSRNumberAndPhase({ csrNumber: this.csrNumber, csrPhase: this.csrPhase, dealerCode: this.dealerCode })
      .then((result) => {
        console.log('getFilesByCSRNumberAndPhase')
        const response = JSON.parse(result);
        if (response.file_info.length > 0) {
          console.log('file- response',result);
          this.fileDetails = { ...response };
        }
      }).catch((error) => {
      });
  }

  get isEdit() {
    if (this.mode == 'Edit') {
      return true;
    }
    else {
      return false;
    }
  }
  get isView() {
    if (this.mode == 'View') {
      return true;
    }
    else {
      return false;
    }
  }

  get getCsrStatus() {
    return this.currentStatus;
  }
  @wire(MessageContext)
  messageContext;

  subscribeToMessageChannel() {
    if (!this.subscription) {
      this.subscription = subscribe(
        this.messageContext,
        CSR_CHANNEL,
        (message) => this.handleRefreshEvent(message),
      );
    }
  }

  unsubscribeToMessageChannel() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }

  get getshowHideWreck() {
    return this.showHideWreck;
  }
  get getshowHideBlindBid() {
    return this.showHideBlindBid;
  }
  get getCsrNumberVisible() {
    if (this.csrNumber) {
      console.log('this.csrNumber----' + this.csrNumber);
      return true;
    }
    else {
      return false;
    }
  }
  get getCsrPhaseVisible() {
    if (this.csrPhase) {
      return true;
    }
    else {
      return false;
    }
  }
  get getCsrNumber() {
    return this.csrNumber;
  }


  get getDealerCode() {
    
    if (this.mode == 'Edit' || this.mode == 'View') { 
      return this.dealerCode; 
    }
    else if (this.dealerType == 'S' || this.dealerType == 'G') {
      if (this.listLocation.length > 0) {
        this.dealerCode = this.listLocation[0].value;
      }
      return this.dealerCode;
    } else {
      return '';
    }
  }
  handleRefreshEvent(message) {
    this.dealerCode = '';
    this.csrType = ''
    this.dealerType = ''
    this.customerName = ''
    this.competitiveType = '';
    this.chassisNumber = '';
    this.insuranceCompany = '';
    this.dealerDiscount = 0;
    this.writeOffvalue = 0;
    this.duration = 0;
    this.expectedMarkup = '';
  }

  get getCsrTypeOptions() {
    return this.csrOptions;
  }

  get getCsrCompetitiveTypeOption() {
    return this.competitiveTypeOptions;
  }

  get getDealerTypeOptions() {
    return this.dealerTypeOptions;
  }
  //there is an issue on this method when calling from new tab
  handleLocationChange() {

    var isNonDealer = this.isNonDealer;
    if (isNonDealer != true) {

      if (this.selectedLocation.selectedLoc != undefined) {

        var selectedLocation = this.selectedLocation;
        this.dealerCode = this.selectedLocation.selectedLoc;

        if (typeof this.selectedLocation.listSelectedLoc == 'string') {
          this.listLocation.push({ label: this.selectedLocation.listSelectedLoc, value: this.selectedLocation.listSelectedLoc });
        }
        else {
          this.selectedLocation.listSelectedLoc.forEach(currentItem => {

            this.listLocation.push({ label: currentItem, value: currentItem });
          });

        }


      } else {

        var selectedLocation = this.selectedLocation;
        this.selectedLocation.listSelectedLoc.forEach(currentItem => {

          this.listLocation.push({ label: currentItem, value: currentItem });
          this.dealerCode = currentItem;
        });
        if (this.listLocation.length > 0) {
          this.dealerCode = this.listLocation[0].value;
        }

      }

      if (this.listLocation.length > 0) {
        this.isLoading = false;
      }
    } else if (isNonDealer == true && typeof this.selectedLocation === "string" && typeof this.selectedLocation.valueOf() === "string") {
      this.dealerCode = this.selectedLocation;
    } else if (isNonDealer == true) {
      if (this.selectedLocation.selectedLoc != undefined || selectedLocation.selectedLoc != null) {
        var selectedLocation = this.selectedLocation;
        this.dealerCode = this.selectedLocation.selectedLoc;
        this.selectedLocation.listSelectedLoc.forEach(currentItem => {
          this.listLocation.push({ label: currentItem, value: currentItem });
        });
      } else {
        var selectedLocation = this.selectedLocation;
        this.selectedLocation.listSelectedLoc.forEach(currentItem => {
          this.listLocation.push({ label: currentItem, value: currentItem });
          this.dealerCode = currentItem;
        });
        if (this.listLocation.length > 0) {
          this.dealerCode = this.listLocation[0].value;
        }
      }
      if (this.listLocation.length > 0) {
        this.isLoading = false;
      }
    }
    if (this.competitiveType == 'B') {
      this.isCustomerNameRequired = true;
    }
  }

  handleCompetitiveTypeChange(event) {
    this.competitiveType = event.target.value;
    const customerNameInput = this.template.querySelector('[data-id="customerNameInput"]');
    if (this.competitiveType == 'A') {
      customerNameInput.value = '';
      customerNameInput.disabled = true;

    } else {
      customerNameInput.disabled = false;
    }
    if (this.competitiveType == 'B') {
      this.isCustomerNameRequired = true;
    }
    else if (this.competitiveType != 'B') {
      this.isCustomerNameRequired = false;
    }
  }

  get csrHeadingTitle() {
    return this.label.EDealer_DEALER_CUSTOMER_INFORMATION;
  }

  @api get getAllDealerCodes() {

    this.listLocation = [];
    if (this.dealerType === 'G') {
      if (this.accessibleDealersLocs.length > 0) {
        let dealerGroups = this.accessibleDealersLocs.map(currentItem => ({
          label: currentItem.Dealer_Group__c,
          value: currentItem.Dealer_Group__c
        }));
        this.listLocation = this.handleUniqueValuesInPicklist(dealerGroups);
      } else {
        if (this.isNonDealer == true && typeof this.selectedLocation === "string" && typeof this.selectedLocation.valueOf() === "string") {
          this.listLocation.push({ label: this.selectedLocation, value: this.selectedLocation });
          this.dealerCode = this.selectedLocation;
        } else {
          this.selectedLocation.listSelectedLoc.forEach(currentItem => {
            this.listLocation.push({ label: currentItem, value: currentItem });
          });
        }
      }
    } else {
      if (this.accessibleDealersLocs.length > 0) {
        this.listLocation = this.accessibleDealersLocs.map(currentItem => ({
          label: currentItem.ASI_Dealer_Code__c + (currentItem.Sub_Code__c ? '-' + currentItem.Sub_Code__c : ''),
          value: currentItem.ASI_Dealer_Code__c + (currentItem.Sub_Code__c ? '-' + currentItem.Sub_Code__c : '')
        }));
      } else {
        if (this.isNonDealer == true && typeof this.selectedLocation === "string" && typeof this.selectedLocation.valueOf() === "string") {
          this.listLocation.push({ label: this.selectedLocation, value: this.selectedLocation });
          this.dealerCode = this.selectedLocation;
        } else {
          this.selectedLocation.listSelectedLoc.forEach(currentItem => {
            this.listLocation.push({ label: currentItem, value: currentItem });
          });
        }
      }
    }
    if (this.mode != 'Edit' && this.listLocation.length > 0 && !this.dealerCode) { 
      this.dealerCode = this.listLocation[0].value; 
    }
    this.listLocation = this.listLocation.filter(item => (item && item.label && !item.label.includes('-')));
    return this.listLocation;
  }

  handleCSRTypeChange(event) {
    this.csrType = event.detail.value;
    if (this.allowedQuantityCSRType.data.includes(this.csrType)) {
      this.blockquantityfieldonsearch = false;
    }
    else {
      this.blockquantityfieldonsearch = true;
    }
    this.handleCsrType(event.detail.value);
    this.template.querySelector('c-e-dealer-csr-part-list').handleCSRTypeChange(event.detail.value);
  }

  handleCsrType(csrType) {
    if (csrType == 'W') {
      this.showHideWreck = true;
      this.showHideBlindBid = false;
    }
    else if (csrType == 'B') {
      this.showHideWreck = false;
      this.showHideBlindBid = true;
    }
    else {
      this.showHideWreck = false;
      this.showHideBlindBid = false;
      this.chassisNumber = '';
      this.insuranceCompany = '';
      this.dealerDiscount = 0;
      this.writeOffvalue = 0;
      this.duration = 0;
      this.expectedMarkup = '';
    }
  }

  handleDealerCodeChange(event) {
    console.log('handleDealerCodeChange' + event.detail.value);
    this.dealerCode = event.detail.value;
    this.template.querySelector('c-e-dealer-file-upload').dealerUserName = event.detail.value;
    this.template.querySelector('c-e-dealer-csr-part-list').headerdealercode = event.detail.value;
  }

  handleDealerTypeChange(event) {
    this.dealerCode = '';
    this.dealerType = event.detail.value;
    this.listLocation = [];
    if (this.dealerType === 'G') {
      let dealerGroups = this.accessibleDealersLocs.map(currentItem => ({
        label: currentItem.Dealer_Group__c,
        value: currentItem.Dealer_Group__c
      }));
      this.listLocation = this.handleUniqueValuesInPicklist(dealerGroups);

    } else {
      this.listLocation = this.accessibleDealersLocs.map(currentItem => ({
        label: currentItem.ASI_Dealer_Code__c + (currentItem.Sub_Code__c ? '-' + currentItem.Sub_Code__c : ''),
        value: currentItem.ASI_Dealer_Code__c + (currentItem.Sub_Code__c ? '-' + currentItem.Sub_Code__c : '')
      }));
    }
   // this.template.querySelector('c-e-dealer-csr-part-list').headerdealercode = '';
  }
  handleCustomerNameChange(event) {
    this.customerName = event.detail.value;
  }

  handleChassisNumberChange(event) {
    this.chassisNumber = event.detail.value;
  }

  handleInsuranceCompanyChange(event) {
    this.insuranceCompany = event.detail.value;
  }

  handleWriteOffValueChange(event) {
    const input =  this.template.querySelector('lightning-input[data-id="writeoffvalue"]');
    let value = input.value;

    value = value.replace(/[^0-9.]/g, '');

    const dotCount = (value.match(/\./g) || []).length;
    if (dotCount > 1) {
        value = value.substring(0, value.lastIndexOf('.'));
    }

    const parts = value.split('.');
    const intPart = parts[0];
    const decPart = parts[1] || '';

    if (intPart.length > 6 || decPart.length > 2 || value.length > 9) {
        input.value = this.writeOffvalue || '';
        return;
    }

    this.writeOffvalue = value;
    input.value = value;
  }

  handleDealerDiscountChange(event) {
    this.dealerDiscount = event.detail.value;
  }

  handleDurationChange(event) {
    this.duration = event.detail.value;
  }

  handleExpectedMarkupChange(event) {
    this.expectedMarkup = event.detail.value;
  }
  get getIsValid() {
    return this.isValid;
  }
  validateAndSaveAllInputs(event) {
    let isChildValidated = event.detail.isValidated;
    let isParentValidated = this.handleValidation();
    this.template.querySelector('c-e-dealer-csr-part-list').isParentValidated = this.handleValidation();
    this.isValid = isParentValidated;
  }

  handleValidation() {
    let isValid = true;
    let inputFields = this.template.querySelectorAll(".validate");
    inputFields.forEach(inputField => {
      if (!inputField.checkValidity()) {
        inputField.reportValidity();
        isValid = false;
      }
    });
    return isValid;
  }
  captureCSRNumber(event) {
    this.csrNumber = event.detail.csrNumber;
    console.log('this.csrNumber ---' + this.csrNumber);
    this.csrPhase = event.detail.phase;
  }

  handleSpinner(event) {
    this.isShowSpinner = event.detail.isShowSpinner;
  }

  handleCurrentCsrStatus(event) {
    this.currentStatus = event.detail.csrStatus;
  }

  handleDisableCsrHeader(event) {
    this.isCsrDataSubmitted = event.detail.isCsrDataSubmitted;
  }

  handleFileUpload(event) {
    var receiveData = event.detail.fileDetails;
    this.receivedFile = [...receiveData];
  }
  // this method used to filter duplicates and show only unique in dealer picklist for dealer group.
  handleUniqueValuesInPicklist(results) {
    const uniqueValues = results.reduce((accumulator, currentValue) => {
      // Check if the value already exists in the accumulator array
      const exists = accumulator.some(obj => obj.value === currentValue.value);

      // If the value doesn't exist, push it to the accumulator array
      if (!exists) {
        accumulator.push(currentValue);
      }
      return accumulator;
    }, []);

    return uniqueValues;
  }

  // this method used to validate current user has access to given csr number or not.
  validateCSRWithDealerCodeForLoggedInUser(dealerId) {

    let isDealerCodeFound = this.getAllDealerCodes.some(item => item.value.toUpperCase() === dealerId);
    if (!isDealerCodeFound) {
      this.showError(this.csrIsNotAvailable);
    }
    return isDealerCodeFound;
  }
}