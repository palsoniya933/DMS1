import { LightningElement, api, wire } from 'lwc';
import getActiveCSRList from '@salesforce/apex/EDealerActiveCsrController.getActiveCSRList'
import EDealerResources from '@salesforce/resourceUrl/EDealerResources';
import getCSRDashboardTranslations from '@salesforce/apex/EDealerActiveCsrController.getCSRDashboardTranslations'
import getCSRDrilldownTranslations from '@salesforce/apex/EDealerActiveCsrController.getCSRDrilldownTranslations'
import getCSRsWithFiles from '@salesforce/apex/EDealerActiveCsrController.getCSRsWithFiles'
import getDraftCsrDashboardTranslations from '@salesforce/apex/EDealerActiveCsrController.getDraftCSRDashboardTranslations';
import getPendingCsrDashboardTranslations from '@salesforce/apex/EDealerActiveCsrController.getPendingCSRDashboardTranslations';
import getDraftCsrDrilldownTranslations from '@salesforce/apex/EDealerActiveCsrController.getDraftCsrDrilldownTranslations';
import getPendingCsrDrilldownTranslations from '@salesforce/apex/EDealerActiveCsrController.getPendingCsrDrilldownTranslations';
import getStatusList from '@salesforce/apex/EDealerCsrStatusController.getCsrStatus';
import renewCSR from '@salesforce/apex/EDealerActiveCsrController.renewCSR';
import getDraftCsrList from '@salesforce/apex/EDealerActiveCsrController.getDraftCsrList';
import getPendingCsrList from '@salesforce/apex/EDealerActiveCsrController.getPendingCsrList';
import getdownloadsize from '@salesforce/apex/EDealerActiveCsrController.getdownloadsize';
import cancelCSR from '@salesforce/apex/eDealerCsrPartListController.cancelCSR';
import { publish, MessageContext, subscribe, unsubscribe, createMessageContext, releaseMessageContext } from 'lightning/messageService';
import CSR_CHANNEL from '@salesforce/messageChannel/eDealerCSR__c';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import Edealer_CSR_Cancelled from '@salesforce/label/c.Edealer_CSR_Cancelled';
import EDealer_Cancel_Operation_Failed from '@salesforce/label/c.EDealer_Cancel_Operation_Failed';
import EDealer_Yes from '@salesforce/label/c.EDealer_Yes';
import EDealer_No from '@salesforce/label/c.EDealer_No';
import EDealer_Are_you_sure from '@salesforce/label/c.EDealer_Are_you_sure';
import EDealer_Success_Title from '@salesforce/label/c.EDealer_Success_Title';
import EDealer_Error_Title from '@salesforce/label/c.EDealer_Error_Title';
export default class EDealerCsrListing extends LightningElement {
  excelDownloadLogo = EDealerResources + '/icons/Excelliconwhite.svg' + '#Excelliconwhite';
  label = {
    EDealer_Cancel_Operation_Failed,
    Edealer_CSR_Cancelled,
    EDealer_Success_Title,
    EDealer_Yes,
    EDealer_No,
    EDealer_Are_you_sure,
    EDealer_Error_Title

  };
  totalpendingcsr = 0
  inprocesscsr = 0
  waitingresponsecsr = 0
  routingcsr = 0
  inqueuecsr = 0

  draftcsr = 0
  inprogresscsr = 0
  postedcsr = 0
  expiringcsr = 0
  closedcsr = 0
  deniedcsr = 0
  canceledcsr = 0
  expiredcsr = 0
  paginationPageSize = 25
  paginationPageSizeHeader = 25
  totalCsr
  totalCsrHeader
  CSRData = []
  CSRDataHeader = []
  csrViewData = []
  dataFound
  hasDealerLoc
  totalCsrCount
  pageNumber = 1
  pageNumberHeader = 1



  @api selectedlocation
  @api division
  @api dealerusername
  @api accessibledealerslocs
  @api isnondealer
  displayLoading
  @api
  selectedlocationlist

  subscription
  // translations

  tabtitle
  detailtablecolumns
  headertilenames
  downloadlabel


  reportColumns
  reportName

  isDialogVisible_renew
  isDialogVisible_cancel

  @api csrNumber
  @api csrPhase
  @api csrfrequency
  @api csrtype
  @api csrsubtype
  openCommentsModal = false
  openListingModal = true
  openFilesModal = false
  draftCSRData
  draftCSRDataHeader
  totalDraftCsr
  totalDraftCsrHeader
  error
  downloadChunkSize
  statusMap
  csrwithfilesList
  csrlistTranslation
  csrPhaseByCsrNumber = [];

  showlisting = true;

  cancelationConfirmationMessage
  renewalConfirmationMessage
  successRenewalMessage
  @api
  get isDraftListing() {
    return this.csrtype == 'mycsrlisting'
  }
  @api
  get isActiveListing() {
    return this.csrtype == 'activecsrlisting'

  }
  @api
  get isPendingListing() {
    return this.csrtype == 'pendingcsrlisting'

  }
  async getStatusMap() {

    await getStatusList()
      .then((result) => {


        this.statusMap = result;


      })
      .catch((error) => {
        console.log('error::' + JSON.stringify(error));
      })

  }

  async getDownloadChunkSize() {

    await getdownloadsize()
      .then((result) => {


        this.downloadChunkSize = result;


      })
      .catch((error) => {
        console.log('error::' + JSON.stringify(error));
      })

  }

  processListingResponsePayload(dataresult) {

    const inProcessStatusList = ['D', 'M', 'S', 'U', 'A', 'X', 'I'];
    this.csrPhaseByCsrNumber = this.getMaxPhaseMap(dataresult);
    dataresult.sort((a, b) => new Date(b.last_updated_at) - new Date(a.last_updated_at));
    dataresult.forEach((obj, index) => {
      obj.sr = index + 1;

      if (obj.expiration_date != null) {
        const expdate = new Date(obj.expiration_date);
        const currdate = new Date();
        //converts milisecond to days
        if (this.csrPhaseByCsrNumber.hasOwnProperty(obj.csrnumber.toString()) && this.csrPhaseByCsrNumber[obj.csrnumber.toString()] == obj.phase) {
          obj.showrenewbutton = ((expdate - currdate) / (60 * 60 * 24 * 1000) <= 30) && (obj.status == 'P' || obj.status == 'E') && obj.csrtype != 'W' ? true : false;
          obj.renewalEnabled = ((expdate - currdate) / (60 * 60 * 24 * 1000) <= 30) && ((expdate - currdate) / (60 * 60 * 24 * 1000) >= 0) && (obj.status == 'P' || obj.status == 'E') && obj.csrtype != 'W' ? true : false;
          obj.isExpired = ((expdate - currdate) / (60 * 60 * 24 * 1000) < 0) ? true : false;
        }
      }
      
      obj.hascomments = obj?.hascomments?.toLowerCase() == 'y' && obj?.cmttype?.toLowerCase() == "d"? true : false;
      

      if (this.csrwithfilesList.includes(obj.dealercode + obj.csrnumber + obj.phase)) {
        obj.hasfiles = 'Y';
      }
      obj.hasfiles = obj?.hasfiles?.toLowerCase() == 'y' ? true : false; //files check

      for (let statusobj of this.statusMap) {
        if (statusobj.value === obj.status) {
          obj.status = statusobj.label;
        }
      }


      switch (obj.csrtype) {
        case "W":
          obj.csrtype = 'Wreck';
          break;
        case "B":
          obj.csrtype = 'Blind Bid';
          break;
        case "C":
          obj.csrtype = 'Competitive Sales';
          break;
        case "V":
          obj.csrtype = 'Volume Sales';
          break;

        default:
          obj.csrtype = '';
          break;
      }
      switch (obj.dealertype) {
        case "G":
          obj.dealertype = 'Group';
          break;
        case "S":
          obj.dealertype = 'Store';
          break;

        default:
          obj.csrtype = '';
          break;
      }
      obj.showDraftbuttons = obj.Status == 'Draft' ? true : false;

    });
    return dataresult;
  }

  countStatusFromResponse(array) {
    const statusCounts = {};

    // Iterate through the array and count the occurrences of each status
    array.forEach(obj => {
      if (statusCounts[obj.status]) {
        statusCounts[obj.status]++;
      } else {
        statusCounts[obj.status] = 1;
      }
    });

    return statusCounts;
  }

  async getTranslations(csrtype) {

    if (csrtype == 'activecsrlisting') {
      await getCSRDashboardTranslations()
        .then((result) => {
          console.log('activecsrlisting result: ' + JSON.stringify(result));
          this.accordionTitle = result.csr.label
          this.dashboardTranslation = result.dashboard.label
          this.csrlistTranslation = result.activecsr.label
          const updateheader = new CustomEvent('updateheaderkpicontainer', {
            detail: {
              "dashboardTranslation": this.dashboardTranslation,
              "csrlistTranslation": this.csrlistTranslation
            }
          });
          console.log(JSON.stringify(updateheader.detail))

          this.dispatchEvent(updateheader);
          console.log('updateheaderkpicontainer event dispatched')


        })
        .catch((error) => {
          console.log('picklist error::' + JSON.stringify(error));
        });

      this.hasDealerLoc = this.selectedlocationlist ? true : false;
      //gets translation to CSR drilldown component
      await getCSRDrilldownTranslations().then((result) => {

        this.tabtitle = result.csrList.label
        this.detailtablecolumns = result.tableHeader
        this.headertilenames = result.csrHeader
        this.downloadlabel = result.download.label
        this.successRenewalMessage = result.successRenewalMessage.label;
        this.renewalConfirmationMessage = result.renewalConfirmationMessage.label;

      })
        .catch((error) => {
          console.log('picklist error::' + JSON.stringify(error));
        });
    }
    else if (csrtype == 'mycsrlisting') {
      await getDraftCsrDashboardTranslations()
        .then((result) => {
          console.log('mycsrlisting result: ' + JSON.stringify(result));

          this.accordionTitle = result.csr.label
          this.dashboardTranslation = result.dashboard.label
          this.csrlistTranslation = result.activecsr.label
          this.error = undefined;
          var dashboardTranslation = result.dashboard.label;
          var draftcsrlistTranslation = result.activecsr.label;
          const updateheader = new CustomEvent('updateheaderkpicontainer', {
            detail: {
              "dashboardTranslation": this.dashboardTranslation,
              "csrlistTranslation": this.csrlistTranslation
            }
          });
          console.log(JSON.stringify(updateheader.detail))
          this.dispatchEvent(updateheader);
          console.log('updateheaderkpicontainer event dispatched')

        })
        .catch((error) => {
          this.displayLoading = false;
          this.error = "Unknown error";
          if (Array.isArray(error.body)) {
            this.error = error.body.map((e) => e.message).join(", ");
          } else if (typeof error.body.message === "string") {
            this.error = error.body.message;
          }
          console.log('**Error in dashboard translations => ' + JSON.stringify(error));
        });
      this.hasDealerLoc = this.selectedlocationlist ? true : false;

      await getDraftCsrDrilldownTranslations().then((result) => {
        console.log('activecsrlisting result: ' + JSON.stringify(result));

        this.error = undefined;
        this.tabtitle = result.csrList.label;
        this.headertilenames = result.csrHeader;
        this.downloadlabel = result.download.label;
        this.detailtablecolumns = result.tableHeader;
        this.cancelationConfirmationMessage = result.cancelationConfirmationMessage.label;
      })
        .catch((error) => {
          this.error = "Unknown error";
          if (Array.isArray(error.body)) {
            this.error = error.body.map((e) => e.message).join(", ");
          } else if (typeof error.body.message === "string") {
            this.error = error.body.message;
          }
          console.log('**Error in drilldown translations => ' + JSON.stringify(error));
        });
    }
    else if (csrtype == 'pendingcsrlisting') {
      await getPendingCsrDashboardTranslations()
        .then((result) => {
          console.log('pendingcsrlisting result: ' + JSON.stringify(result));

          this.accordionTitle = result.csr.label
          this.dashboardTranslation = result.dashboard.label
          this.csrlistTranslation = result.activecsr.label
          this.error = undefined;

          const updateheader = new CustomEvent('updateheaderkpicontainer', {
            detail: {
              "dashboardTranslation": this.dashboardTranslation,
              "csrlistTranslation": this.csrlistTranslation
            }
          });
          console.log(JSON.stringify(updateheader.detail))

          this.dispatchEvent(updateheader);
          console.log('updateheaderkpicontainer event dispatched')

        })
        .catch((error) => {
          this.displayLoading = false;
          this.error = "Unknown error";
          if (Array.isArray(error.body)) {
            this.error = error.body.map((e) => e.message).join(", ");
          } else if (typeof error.body.message === "string") {
            this.error = error.body.message;
          }
          console.log('**Error in dashboard translations => ' + JSON.stringify(error));
        });
      this.hasDealerLoc = this.selectedlocationlist ? true : false;

      await getPendingCsrDrilldownTranslations().then((result) => {

        this.error = undefined;
        this.tabtitle = result.csrList.label;
        this.headertilenames = result.csrHeader;
        this.downloadlabel = result.download.label;
        this.detailtablecolumns = result.tableHeader;
      })
        .catch((error) => {
          this.error = "Unknown error";
          if (Array.isArray(error.body)) {
            this.error = error.body.map((e) => e.message).join(", ");
          } else if (typeof error.body.message === "string") {
            this.error = error.body.message;
          }
          console.log('**Error in drilldown translations => ' + JSON.stringify(error));
        });
    }

  }
  async getListing(csrtype) {

    if (csrtype == 'activecsrlisting') {
      await getActiveCSRList({ "dealerCodeList": this.selectedlocationlist, "frequency": this.csrfrequency, "csrtype": this.csrsubtype })
        .then((result) => {
          console.log(result);
          if (result.includes("error")) {
            const evt = new ShowToastEvent({
              title: 'Error',
              message: 'No CSR found for the Dealer',
              variant: 'error',
            });
            this.dispatchEvent(evt);
            this.postedcsr = 0;
            this.deniedcsr = 0;
            this.expiredcsr = 0;
            this.canceledcsr = 0;
            this.totalCsr = this.totalCsrHeader = 0;
            this.displayLoading = false;
            this.showlisting = false;
          }
          else {
            let dataresult = JSON.parse(result).response;
            let countcsrbystatus = this.countStatusFromResponse(dataresult);
            this.postedcsr = countcsrbystatus['P'] ? countcsrbystatus['P'] : 0;
            this.deniedcsr = countcsrbystatus['R'] ? countcsrbystatus['R'] : 0;
            this.expiredcsr = countcsrbystatus['E'] ? countcsrbystatus['E'] : 0;
            this.canceledcsr = countcsrbystatus['C'] ? countcsrbystatus['C'] : 0;
            this.dataresult = this.processListingResponsePayload(dataresult);

            this.CSRData = this.CSRDataHeader = dataresult;
            this.totalCsr = this.totalCsrHeader = this.CSRData.length;
            this.csrViewData = this.CSRData.slice(0, this.paginationPageSize);
            this.showlisting = true;
            this.displayLoading = false;
          }
        })
        .catch((error) => {
          const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Error getting Processed CSR(s) List',
            variant: 'error',
          });
          this.dispatchEvent(evt);
          this.displayLoading = false;
          this.showlisting = false;
        });
    }
    else if (csrtype == 'mycsrlisting') {

      await getDraftCsrList({ "dealerCodeList": this.selectedlocationlist, "frequency": this.csrfrequency })
        .then((result) => {
          console.log(result);
          if (result.includes("error")) {
            const evt = new ShowToastEvent({
              title: 'Error',
              message: 'No CSR found for the Dealer',
              variant: 'error',
            });
            this.dispatchEvent(evt);
            this.totalCsr = this.totalCsrHeader = this.draftcsr = 0;
            this.displayLoading = false;
            this.showlisting = false;
          }
          else {
            this.error = undefined;
            let dataresult = JSON.parse(result).response;
            this.dataresult = this.processListingResponsePayload(dataresult);


            this.CSRData = this.CSRDataHeader = dataresult;
            this.totalCsr = this.totalCsrHeader = this.draftcsr = this.CSRData.length;
            this.csrViewData = this.CSRData.slice(0, this.paginationPageSize);
            this.showlisting = true;
            this.displayLoading = false;
          }


        })
        .catch((error) => {
          const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Error getting My CSR(s) List',
            variant: 'error',
          });
          this.dispatchEvent(evt);
          this.displayLoading = false;

        });
    }
    else if (csrtype == 'pendingcsrlisting') {
      await getPendingCsrList({ "dealerCodeList": this.selectedlocationlist, "frequency": this.csrfrequency, "csrtype": this.csrsubtype })
        .then((result) => {
          console.log(result);
          if (result.includes("error")) {
            const evt = new ShowToastEvent({
              title: 'Error',
              message: 'No CSR found for the Dealer',
              variant: 'error',
            });
            this.dispatchEvent(evt);
            this.inprocesscsr = 0;
            this.waitingresponsecsr = 0;
            this.totalCsr = this.totalCsrHeader = this.totalpendingcsr = 0;
            this.displayLoading = false;
            this.showlisting = false;
          }
          else {
            this.error = undefined;
            let dataresult = JSON.parse(result).response;

            let countcsrbystatus = this.countStatusFromResponse(dataresult);
            let countD = countcsrbystatus['D'] ? countcsrbystatus['D'] : 0;
            let countM = countcsrbystatus['M'] ? countcsrbystatus['M'] : 0;
            let countS = countcsrbystatus['S'] ? countcsrbystatus['S'] : 0;
            let countU = countcsrbystatus['U'] ? countcsrbystatus['U'] : 0;
            let countA = countcsrbystatus['A'] ? countcsrbystatus['A'] : 0;
            let countX = countcsrbystatus['X'] ? countcsrbystatus['X'] : 0;
            let countI = countcsrbystatus['I'] ? countcsrbystatus['I'] : 0;
            this.inprocesscsr = countD + countM + countS + countU + countA + countX + countI;
            this.waitingresponsecsr = countcsrbystatus['W'] ? countcsrbystatus['W'] : 0;
            this.dataresult = this.processListingResponsePayload(dataresult);

            this.CSRData = this.CSRDataHeader = dataresult;
            this.totalCsr = this.totalCsrHeader = this.totalpendingcsr = this.CSRData.length;
            this.csrViewData = this.CSRData.slice(0, this.paginationPageSize);
            this.showlisting = true;
            this.displayLoading = false;
          }


        })
        .catch((error) => {
          const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Error getting Pending CSR(s) List',
            variant: 'error',
          });
          this.dispatchEvent(evt);
          this.displayLoading = false;

        });
    }

  }
  async getCSRsWithFiles() {
    await getCSRsWithFiles({ "dealerCodeList": this.selectedlocationlist })
      .then((result) => {
        this.csrwithfilesList = [];
        const parsedResult = JSON.parse(result);
        for (let i = 0; i < parsedResult.length; i++) {
          let valuesList = Object.values(parsedResult[i])[0];
          for (let j = 0; j < valuesList.length; j++) {
            let dealerNumberPhaseKey = Object.keys(parsedResult[i])[0] + Object.keys(valuesList[j]) + Object.values(valuesList[j])
            if (!this.csrwithfilesList.includes(dealerNumberPhaseKey)) {
              this.csrwithfilesList.push(dealerNumberPhaseKey);
            }
          }
        }
      })
      .catch((error) => {
        console.log(error);
      })

    this.getListing(this.csrtype);

  }
  connectedCallback() {
    this.displayLoading = true;
    this.subscribeToMessageChannel();
    if (this.selectedlocation) {
      this.selectedlocationlist = this.selectedlocation.listSelectedLoc;
    }
    this.getTranslations(this.csrtype);
    this.getStatusMap();
    this.getDownloadChunkSize();

    setTimeout(() => {
      this.getCSRsWithFiles();
    }, 50);
    // setTimeout(() => {
    //   this.getListing(this.csrtype);
    // }, 100);

  }


  disconnectedCallback() {

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

  handleMessageChannelEvent(message) {

    if (message.detail == 'refreshlocation') {
      this.displayLoading = true;
      if (this.selectedlocation) {
        this.selectedlocationlist = this.selectedlocation.listSelectedLoc;
      }
      console.log('dealerCodeList: ' + this.selectedlocationlist);
      var currentUrl = window.location.href;
      var createCsrBaseURL = currentUrl.split('?')[0];

      if (currentUrl !== createCsrBaseURL) {
        history.replaceState(null, null, createCsrBaseURL);
      }
      this.getCSRsWithFiles();
      this.getListing(this.csrtype);

    }
  }


  handleTotalRecordChange(event) {
    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.csrViewData = this.CSRData.slice(indexes.startIndex, indexes.endIndex);
    this.filterCsrData();
  }


  //auxiliar methods to sync both paginators
  setPaginationIndexes(indexes) {
    this.paginationStartIndex = indexes.startIndex;
    this.paginationEndIndex = indexes.endIndex;
  }


  handleNextButton(event) {

    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.csrViewData = this.CSRData.slice(indexes.startIndex, indexes.endIndex);
  }

  handlePrevButton(event) {

    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.csrViewData = this.CSRData.slice(indexes.startIndex, indexes.endIndex);
  }

  handleChangeInPageNumber(event) {

    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.csrViewData = this.CSRData.slice(indexes.startIndex, indexes.endIndex);

  }

  handlePageNumberChange(event) {

    this.paginationPageSize = this.paginationPageSizeHeader = event.detail.pagesize;
    this.pageNumber = this.pageNumberHeader = event.detail.pagenumber;

  }
  //end of auxiliar methods to sync both paginators

  handlePreview(event) {

    const rowIndex = event.currentTarget.dataset.index;
    const csrNumber = this.csrViewData[rowIndex].csrnumber;
    const csrphase = this.csrViewData[rowIndex].phase;
    const location = this.csrViewData[rowIndex].dealercode;
    if (this.selectedlocationlist && this.selectedlocationlist.length > 1) {
      console.log('open on same tab');
      const opencsrDetailEvent = new CustomEvent('opencsrdetail', {
        detail: {
          csrNumber,
          csrphase,
          location
        }
      });
      this.dispatchEvent(opencsrDetailEvent);
    }
    else if (this.selectedlocationlist && this.selectedlocationlist.length == 1) {
      console.log('open on new tab');

      const opencsrDetailEvent = new CustomEvent('opencsrdetail', {
        detail: {
          csrNumber,
          csrphase,
          location
        }
      });
      this.dispatchEvent(opencsrDetailEvent);
    }

  }

  handleEdit(event) {

    const rowIndex = event.currentTarget.dataset.index;
    const csrNumber = this.csrViewData[rowIndex].csrnumber;
    const csrphase = this.csrViewData[rowIndex].phase;
    const location = this.csrViewData[rowIndex].dealercode;
    const opencsreditscreen = new CustomEvent('opencsreditscreen', {
      detail: {
        csrNumber,
        csrphase,
        location
      }
    });
    this.dispatchEvent(opencsreditscreen);

  }

  downloadCsv() {

    var stockData = this.CSRData;


    // getting report name
    var reportName = this.csrlistTranslation;

    //getting columns from lightning table
    var columns = [];
    for (let i = 0; i < this.detailtablecolumns.length; i++) {
      if (this.detailtablecolumns[i].fieldName != 'Actions' && this.detailtablecolumns[i].fieldName != 'CommentsFiles') {
        columns.push(this.detailtablecolumns[i]);
      }
    }
    var findChildComp = this.template.querySelector('[data-id="childLwcCompId"]');
    try {
      //needs to be changed (set as 10 as a matter of testing and POC)
      const chunkSize = this.downloadChunkSize;
      for (let i = 0; i < stockData.length; i += chunkSize) {
        const chunk = stockData.slice(i, i + chunkSize);
        findChildComp.downloadV1(columns, chunk, reportName);
      }
    }
    catch (e) {

      console.log('error ----- >>>>> ' + e.message);
    }

  }
  handleOpenCommentsModal(event) {
    this.openCommentsModal = true;
    this.openListingModal = false;
    this.openFilesModal = false;
    const rowIndex = event.currentTarget.dataset.index;
    const csrNumber = this.csrViewData[rowIndex].csrnumber;
    const csrphase = this.csrViewData[rowIndex].phase;
    this.csrNumber = csrNumber;
    this.csrPhase = csrphase;
  }
  handleOpenFilesModal(event) {
    this.openFilesModal = true;
    this.openCommentsModal = false;
    this.openListingModal = false;

    const rowIndex = event.currentTarget.dataset.index;
    const csrNumber = this.csrViewData[rowIndex].csrnumber;
    const csrphase = this.csrViewData[rowIndex].phase;
    const csrDealerCode = this.csrViewData[rowIndex].dealercode;
    this.csrNumber = csrNumber;
    this.csrPhase = csrphase;
    this.csrDealerCode = csrDealerCode;
    console.log(this.csrNumber + '-' + this.csrPhase);
  }
  handleShowListing(event) {
    this.openCommentsModal = false;
    this.openListingModal = true;
    this.openFilesModal = false;
  }

  renewCsr(event) {
    console.log(JSON.stringify(event.detail));
    if (event.target.name === 'renew_btn') {
      this.isDialogVisible_renew = true;
      const rowIndex = event.currentTarget.dataset.index;
      const csrNumber = this.csrViewData[rowIndex].csrnumber;
      const csrphase = this.csrViewData[rowIndex].phase;
      const dealerId = this.csrViewData[rowIndex].dealercode;     // added 05-01-2024 Chito
      const expdate = this.csrViewData[rowIndex].expiration_date;
      this.csrNumber = csrNumber;
      this.csrPhase = csrphase;
      this.dealerId = dealerId;     // added 05-01-2024 Chito
      console.log('Dealer Code is ' + this.dealerId);
    }
    else if (event.target.name === 'confirmModal' && event.detail.status == 'confirm') {
      renewCSR({ csrNumber: this.csrNumber, csrPhase: this.csrPhase, dealerId: this.dealerId })    // modified to add dealerID   05-01-2024 Chito
        .then((result) => {
          const JSONresult = JSON.parse(result)
          let newCSRNumber = JSONresult.Data.NCSRnumber;

          let newPhase = JSONresult.Data.NPhase;

          let newExpDate = JSONresult.Data.NExpDate;

          console.log('Renewal completed! New CSR info: ' + newCSRNumber + '-' + newPhase + ' with expiration date on: ' + newExpDate);
          console.log('Error Returned Message is ' + JSONresult.ErrorResponse.ErrorMessages[0].ErrorDescription);
          if (JSONresult.ErrorResponse.IsSuccess == "False") {
            const evt = new ShowToastEvent({
              title: this.label.EDealer_Error_Title,    // added 05-01-2024
              message: JSONresult.ErrorResponse.ErrorMessages[0].ErrorDescription,
              variant: 'error',
              mode: 'sticky'
            });
            this.dispatchEvent(evt);
          }
          else if (JSONresult.ErrorResponse.IsSuccess == "True") {
            const successmsg = 'CSR ' + newCSRNumber + '-' + newPhase
            const evt = new ShowToastEvent({
              title: this.label.EDealer_Success_Title,   //04-29-2024
              message: this.successRenewalMessage.replace("CSR", successmsg),
              variant: 'success',
              mode: 'sticky'
            });
            this.dispatchEvent(evt);
          }
          this.isDialogVisible_renew = false;
        })
        .catch((error) => {
          const evt = new ShowToastEvent({
            title: this.label.EDealer_Error_Title,
            //message: 'There was an error renewing the CSR',       // 05-01-2024
            message: JSONresult.ErrorResponse.ErrorMessages[0].ErrorDescription,
            variant: 'error',
            mode: 'sticky'
          });
          this.dispatchEvent(evt);
          this.isDialogVisible_renew = false;

        });

    }
    else if (event.target.name === 'confirmModal' && event.detail.status == 'cancel') {
      this.isDialogVisible_renew = false;
    }

  }

  cancelCsr(event) {
    if (event.target.name === 'delete_btn') {
      this.isDialogVisible_cancel = true;
      const rowIndex = event.currentTarget.dataset.index;
      const csrNumber = this.csrViewData[rowIndex].csrnumber;
      const csrphase = this.csrViewData[rowIndex].phase;
      const dealerid = this.csrViewData[rowIndex].dealercode;    //added 05-01-2024
      this.csrNumber = csrNumber;
      this.csrPhase = csrphase;
      this.dealerId = dealerid;
    }
    else if (event.target.name === 'confirmModal' && event.detail.status == 'confirm') {
      cancelCSR({ userName: null, csrNumber: this.csrNumber, csrPhase: this.csrPhase, dealerId: this.dealerId })     // modified to add dealerId, Chito 05-01-2024
        .then((result) => {
          const JSONresult = JSON.parse(result)                                   // added 05-01-2024

          console.log('success cancelCSR response: ' + result);
          const evt = new ShowToastEvent({
            message: this.label.Edealer_CSR_Cancelled,
            variant: 'SUCCESS',
          });
          this.dispatchEvent(evt);
          this.isDialogVisible_cancel = false;

        })
        .catch((error) => {
          this.error = error;
          console.log('error cancelCSR response: ' + result);
          const evt = new ShowToastEvent({
            message: JSONresult.ErrorResponse.ErrorMessages[0].ErrorDescription,  //this.label.EDealer_Cancel_Operation_Failed, 05-01-2024
            variant: 'SUCCESS',
          });
          this.dispatchEvent(evt);
          this.isDialogVisible_cancel = false;
        });

    }
    else if (event.target.name === 'confirmModal' && event.detail.status == 'cancel') {
      this.isDialogVisible_cancel = false;
    }
  }

  getMaxPhaseMap(response) {
    let csrMap = {};

    response.forEach(record => {
      let csrNumber = record.csrnumber;
      if (!csrMap[csrNumber] || csrMap[csrNumber] < record.phase) {
        csrMap[csrNumber] = record.phase;
      }
    });

    return csrMap;
  }
}