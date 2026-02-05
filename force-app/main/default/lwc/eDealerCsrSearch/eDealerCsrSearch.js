import { LightningElement, api, track } from 'lwc';
import getCSRsWithFiles from '@salesforce/apex/EDealerActiveCsrController.getCSRsWithFiles'
import getDraftCsrDashboardTranslations from '@salesforce/apex/EDealerActiveCsrController.getDraftCSRDashboardTranslations';
import getDraftCsrDrilldownTranslations from '@salesforce/apex/EDealerActiveCsrController.getDraftCsrDrilldownTranslations';
import getCSRDrilldownTranslations from '@salesforce/apex/EDealerActiveCsrController.getCSRDrilldownTranslations';
import getStatusList from '@salesforce/apex/EDealerCsrStatusController.getCsrStatus';
import renewCSR from '@salesforce/apex/EDealerActiveCsrController.renewCSR';
import getCSRbySearchKey from '@salesforce/apex/EDealerCsrSearch.getCSRbySearchKey';
import cancelCSR from '@salesforce/apex/eDealerCsrPartListController.cancelCSR';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import Edealer_CSR_Cancelled from '@salesforce/label/c.Edealer_CSR_Cancelled';
import EDealer_Cancel_Operation_Failed from '@salesforce/label/c.EDealer_Cancel_Operation_Failed';
import EDealer_Yes from '@salesforce/label/c.EDealer_Yes';
import EDealer_No from '@salesforce/label/c.EDealer_No';
import No_Data_Found from '@salesforce/label/c.No_Data_Found';
import EDealer_Are_you_sure from '@salesforce/label/c.EDealer_Are_you_sure';
import EDealer_Success_Title from '@salesforce/label/c.EDealer_Success_Title';
import EDealer_Error_Title from '@salesforce/label/c.EDealer_Error_Title';
export default class VsCsrSearch extends LightningElement {
  label = {
    EDealer_Cancel_Operation_Failed,
    Edealer_CSR_Cancelled,
    EDealer_Success_Title,
    EDealer_Yes,
    EDealer_No,
    EDealer_Are_you_sure,
    EDealer_Error_Title,
    No_Data_Found

  };
  errorMsg
  isDataNotFound = false;
  paginationPageSize = 25
  paginationPageSizeHeader = 25
  totalCsr
  totalCsrHeader
  CSRData = []
  CSRDataHeader = []
  csrPhaseByCsrNumber = [];
  @track csrViewData = []
  isDataFoundOrNot
  dataresult
  hasDealerLoc
  pageNumber = 1
  pageNumberHeader = 1
  @api csrNum
  @api dealerCode
  @api selectedlocation
  displayLoading = false;
  @api selectedlocationlist
  detailtablecolumns
  headertilenames
  downloadlabel
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
  error
  statusMap = [];
  csrwithfilesList
  csrlistTranslation
  showlisting = false;
  cancelationConfirmationMessage
  renewalConfirmationMessage
  successRenewalMessage
  @api
  get isDraftListing() {
    return this.csrtype == 'mycsrlisting'
  }

  @api handleByContainer() {
    this.csrViewData = [];
    this.displayLoading = true;
    this.isDataFoundOrNot = false;
    this.getCsrdetailByDealerCodeAndSearchkey();
  }

  async connectedCallback() {
    await this.getStatusMap();
    this.getCSRsWithFiles();
    this.displayLoading = true;
    this.csrtype = 'mycsrlisting';
    this.getCsrdetailByDealerCodeAndSearchkey();
    this.getTranslations(this.csrtype);
    if (this.selectedlocation) {
      this.selectedlocationlist = this.selectedlocation.listSelectedLoc;
    }
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
          obj.showrenewbutton = ((expdate - currdate) / (60 * 60 * 24 * 1000) <= 30) && ((obj.status == 'P' || obj.status == 'E') && obj.csrtype != 'W') ? true : false;
          obj.renewalEnabled = ((expdate - currdate) / (60 * 60 * 24 * 1000) <= 30) && ((expdate - currdate) / (60 * 60 * 24 * 1000) >= 0) && ((obj.status == 'P' || obj.status == 'E') && obj.csrtype != 'W') ? true : false;
          obj.isExpired = ((expdate - currdate) / (60 * 60 * 24 * 1000) < 0) ? true : false;
        }
      }

      obj.hascomments = obj.hascomments 
                        && typeof obj.hascomments == 'string'
                        && obj.hascomments.toLowerCase() == 'y' 
                        && obj.cmttype 
                        && obj.cmttype?.toLowerCase() == "d" ? true : false;
                        console.log('--obj.hascomments--', obj.hascomments)
      obj.hasfiles = obj.hasfiles == 'Y' ? true : false;

      if (this.csrwithfilesList.includes(obj.dealercode + obj.csrnumber + obj.phase)) {
        obj.hasfiles = 'Y';
      }

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
          obj.csrtype = obj.csrtype || '';
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
          obj.dealertype = obj.dealertype || ''; 
          break;
      }
      obj.showDraftbuttons = obj.status == 'Draft' ? true : false;

    });
    return dataresult;
  }

  async getTranslations(csrtype) {
    if (csrtype == 'mycsrlisting') {
      await getDraftCsrDashboardTranslations()
        .then((result) => {
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
          this.dispatchEvent(updateheader);

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

        await getCSRDrilldownTranslations().then((result) => {

        this.error = undefined;
        this.tabtitle = result.csrList.label;
        this.headertilenames = result.csrHeader;
        this.downloadlabel = result.download.label;
        this.detailtablecolumns = result.tableHeader;
        this.successRenewalMessage = result.successRenewalMessage;
        this.renewalConfirmationMessage = result.renewalConfirmationMessage.label;
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
  }

  
  getCsrdetailByDealerCodeAndSearchkey() {
    var loc = [];
    if(this.selectedlocationlist == undefined){
        loc.push(this.dealerCode);
    }
    else{
      loc = this.selectedlocationlist;
    }

    let status = [];
    getCSRbySearchKey({ "dealerCode": loc, "status": status, "searchText": this.csrNum })
      .then((result) => {
        const jsonResponse = JSON.parse(result);

        if (jsonResponse.error && jsonResponse.error.length > 0) {

          // Display an error toast message
          this.errorMsg = this.label.No_Data_Found;
          this.isDataFoundOrNot = true;
          this.displayLoading = false;
        } else {

          let dataresult = JSON.parse(result).response;
          this.CSRDataHeader = dataresult;
          this.CSRData  = this.processListingResponsePayload([...dataresult]);
          this.totalCsr = this.totalCsrHeader = this.CSRData.length;
          this.csrViewData = [...this.CSRData.slice(0, this.paginationPageSize)];  
          this.showlisting = true;
          this.displayLoading = false;
        }
      })
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
    if ((this.selectedlocationlist && this.selectedlocationlist.length > 1) || (location != undefined || location != null || location != '')) {
      const opencsrDetailEvent = new CustomEvent('opencsrdetail', {
        detail: {
          csrNumber,
          csrphase,
          location
        }
      });
      this.dispatchEvent(opencsrDetailEvent);
    }
    else if ((this.selectedlocationlist && this.selectedlocationlist.length == 1) || (location != undefined || location != null || location != '')) {
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
  }
  
  handleShowListing(event) {
    this.openCommentsModal = false;
    this.openListingModal = true;
    this.openFilesModal = false;
  }

  renewCsr(event) {
    if (event.target.name === 'renew_btn') {
      this.isDialogVisible_renew = true;
      const rowIndex = event.currentTarget.dataset.index;
      const csrNumber = this.csrViewData[rowIndex].csrnumber;
      const csrphase = this.csrViewData[rowIndex].phase;
      const dealerId = this.csrViewData[rowIndex].dealercode;
      const expdate = this.csrViewData[rowIndex].expiration_date;
      this.csrNumber = csrNumber;
      this.csrPhase = csrphase;
      this.dealerId = dealerId;
    }
    else if (event.target.name === 'confirmModal' && event.detail.status == 'confirm') {
      renewCSR({ csrNumber: this.csrNumber, csrPhase: this.csrPhase, dealerId: this.dealerId })
        .then((result) => {

          const JSONresult = JSON.parse(result);
          let newCSRNumber = JSONresult.Data.NCSRnumber;
          let newPhase = JSONresult.Data.NPhase;


          if (JSONresult.ErrorResponse.IsSuccess == "False") {
            const evt = new ShowToastEvent({
              title: this.label.EDealer_Error_Title,
              message: JSONresult.ErrorResponse.ErrorMessages[0].ErrorDescription,
              variant: 'error',
              mode: 'sticky'
            });
            this.dispatchEvent(evt);
          }
          else if (JSONresult.ErrorResponse.IsSuccess == "True") {

            const successmsg = 'CSR ' + newCSRNumber + '-' + newPhase
            const evt = new ShowToastEvent({
              title: this.label.EDealer_Success_Title,
              message: successmsg,
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
            message: 'There was an error renewing the CSR',
            message: error,
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
      const dealerid = this.csrViewData[rowIndex].dealercode;
      this.csrNumber = csrNumber;
      this.csrPhase = csrphase;
      this.dealerId = dealerid;
    }
    else if (event.target.name === 'confirmModal' && event.detail.status == 'confirm') {
      cancelCSR({ userName: null, csrNumber: this.csrNumber, csrPhase: this.csrPhase, dealerId: this.dealerId })
        .then((result) => {
          const JSONresult = JSON.parse(result);
          const errorDescription = JSONresult.ErrorResponse.ErrorMessages;
          // Use an if condition to check the ErrorDescription
          if (errorDescription && errorDescription.ErrorDescription === "CSR Record Not Found") {
            const evt = new ShowToastEvent({
              message: errorDescription,
              variant: 'ERROR',
            });
            this.dispatchEvent(evt);
          } else {
            const evt = new ShowToastEvent({
              message: this.label.Edealer_CSR_Cancelled,
              variant: 'SUCCESS',
            });
            this.dispatchEvent(evt);

          }
          this.isDialogVisible_cancel = false;

        })
        .catch((error) => {
          this.error = error;
          const evt = new ShowToastEvent({
            message: this.label.EDealer_Cancel_Operation_Failed,
            variant: 'ERROR',
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