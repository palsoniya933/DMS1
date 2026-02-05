import { LightningElement, api, wire, track } from 'lwc';
import EDealerResources from '@salesforce/resourceUrl/EDealerResources';
import saveCSRChanges from '@salesforce/apex/eDealerCsrPartListController.saveCSRChanges';
import getCSRHeaderTranslations from '@salesforce/apex/eDealerCreateCsrController.getCSRHeaderTranslations';
import submitCSR from '@salesforce/apex/eDealerCsrPartListController.submitCSR';
import cancelCSR from '@salesforce/apex/eDealerCsrPartListController.cancelCSR';
import getUsersCountry from '@salesforce/apex/eDealerCsrPartSearchController.getUsersCountry';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { publish, MessageContext, subscribe, unsubscribe, createMessageContext, releaseMessageContext } from 'lightning/messageService';
import CSR_CHANNEL from '@salesforce/messageChannel/eDealerCSR__c';
import getPartsColumnHeaders from '@salesforce/apex/eDealerCsrPartListController.getPartsColumnHeaders';
import EDealer_Part_List_Instruction from '@salesforce/label/c.EDealer_Part_List_Instruction';
import EDealer_Cancel from '@salesforce/label/c.EDealer_Cancel';
import EDealer_Save_As_Draft from '@salesforce/label/c.EDealer_Save_As_Draft';
import EDealer_Submit from '@salesforce/label/c.EDealer_Submit';
import EDealer_Cancel_Operation_Failed from '@salesforce/label/c.EDealer_Cancel_Operation_Failed';
import Edealer_CSR_Cancelled from '@salesforce/label/c.Edealer_CSR_Cancelled';
import Edealer_Missing_Competitor from '@salesforce/label/c.Edealer_Missing_Competitor';
import Edealer_Ops_Failed from '@salesforce/label/c.Edealer_Ops_Failed';
import Edealer_CSR_Submitted from '@salesforce/label/c.Edealer_CSR_Submitted';
import Edealer_Save_As_Draft_Msg from '@salesforce/label/c.Edealer_Save_As_Draft_Msg';
import EDealer_Yes from '@salesforce/label/c.EDealer_Yes';
import EDealer_No from '@salesforce/label/c.EDealer_No';
import EDealer_Are_you_sure from '@salesforce/label/c.EDealer_Are_you_sure';
import EDealer_Parts_List from '@salesforce/label/c.EDealer_Parts_List';
import EDealer_Communication from '@salesforce/label/c.EDealer_Communication';
import validatePartNumber from '@salesforce/apex/EDealerMassUploadValidation.validatePartNumber';
import EDealer_Complete_This_Field_Error_Message from '@salesforce/label/c.EDealer_Complete_This_Field_Error_Message';
import EDealer_Amount_Threshold_Error_Message from '@salesforce/label/c.EDealer_Amount_Threshold_Error';
import EDealer_Group_Wreck_Comb_Error_Message from '@salesforce/label/c.EDealer_Group_Wreck_Comb_Error_Message';
import EDealer_Dealer_and_CSR_Type_Error_Title from '@salesforce/label/c.EDealer_Dealer_and_CSR_Type_Error_Title'
import getWreckCSRMinPrice from '@salesforce/apex/eDealerCsrPartListController.getWreckCSRMinPrice';



export default class EDealerCsrPartList extends LightningElement {
  @track isModalOpen = false;
  @track disableUploadButton = true;
  @track acceptedFormats = ['.xls', '.xlsx'];
  cancelButtonLabel = EDealer_Cancel + ' CSR';
  recordId;
  isMassValid = false;
  buttonName = "slds-button slds-button_small btn-group black-btn";
  grayBtn = "slds-button slds-button_small btn-group gray-btn";
  partListColor = "test";
  rowHighlightShow = false;
  tooltipText = 'test';
  rows = [];
  removeValidation = [];
  isDialogVisible = false;
  excelDownloadLogo = EDealerResources + '/icons/Excelliconwhite.svg' + '#Excelliconwhite';
  label = {
    EDealer_Part_List_Instruction,
    EDealer_Cancel,
    EDealer_Save_As_Draft,
    EDealer_Submit,
    EDealer_Cancel_Operation_Failed,
    Edealer_CSR_Cancelled,
    Edealer_Missing_Competitor,
    Edealer_Ops_Failed,
    Edealer_CSR_Submitted,
    Edealer_Save_As_Draft_Msg,
    EDealer_Yes,
    EDealer_No,
    EDealer_Are_you_sure,
    EDealer_Parts_List,
    EDealer_Communication,
    EDealer_Group_Wreck_Comb_Error_Message,
    EDealer_Dealer_and_CSR_Type_Error_Title
  };
  @api isParentValidated = false;
  @api hasError = false;
  @api isDialogVisible = false;
  isValid = false;
  @wire(MessageContext)
  messageContext;
  @track errorIcon = 'utility:error';
  @track showTooltip = false;
  @api dealerCodes;
  @api headerdealercode
  @api headercsrtype
  @api headercompetitivetype
  @api headerdealertype
  @api headercustomername
  @api headerchassisnumber
  @api headerinsurancecompany
  @api headerwriteoffvalue
  @api headerdealerdiscount
  @api headerduration
  @api headerexpectedmarkup
  @api selectedPart = {};
  @api dealerCode;
  @api division;
  @api dealerUserName;
  @api isNonDealer;
  @api currentStatus;
  @api csrNumber;
  @api csrPhase;
  @api fileDetails = [];
  @api parts;
  columnLabelByApiName = [];
  @track base64result = [];
  @wire(MessageContext)
  messageContext;
  requredFieldMisssingError = EDealer_Complete_This_Field_Error_Message;
  itemAmountThresholdError = EDealer_Amount_Threshold_Error_Message;
  // groupwreckcombinationtitleerror = EDealer_Dealer_and_CSR_Type_Error_Title;
  //contains all info from selected Part and competitor
  partsData = [
    { Id: '1', Part: ' ', PartDescription: ' ', Quantity: ' ', Channel: '', Channels: [], srNum: 1, Competitor: { Id: '', CompetitorName: '', Affiliation: [], City: '', State: '', PostalCode: '', Type: '' }, CompPart: '', CompPrice: '', Brand: '', isSelected: false, isbestNetGreateThen200: false }
  ];
  stringPartsData = JSON.stringify(this.partsData);
  competitorsData = [];
  openCompetitorModal = false;
  searchIndex = 0;
  selectedRowData;
  addedCompetitor;
  selectedCompetitor = '';
  openPartSearchModal = false;
  payload = {}
  selectedCompId;
  selectedCompetitorsData = {};
  partsViewData = this.partsData;
  pageNumber = 1;
  paginationPageSize = 25;
  isShowSpinner = false;
  submitBtnDisabled = true;
  @api isCsrDataSubmitted = false;
  draftbtnDisabled = false;
  reqdInput
  duplicateWithSR
  invalidPartNumber
  partNumbershouldnotbemorethan18char
  compDisabled
  duplicatePartsbySrNum = new Map();
  selectedCompetitorForAddCompetitor = {};
  @api mode;
  @api editpartlist;
  @api channeltype = '';
  @api isBestNetGreaterThanThreshold = false;
  @api selectedlocation;
  userCountry;
  wreckCSRMinPrice;

  @wire(getWreckCSRMinPrice)
  wiredMinPrice({ error, data }) {
    if (data) {
      this.wreckCSRMinPrice = data;
    } else if (error) {
      console.error('Error fetching Wreck CSR Min Price:', error);
    }
  }
  connectedCallback() {

    this.base64result = [];
    this.isShowSpinner = true;
    this.fetchUserCountry();
    getCSRHeaderTranslations().then((result) => {
      this.duplicateWithSR = result.duplicateWithSR[0].label;
      this.invalidPartNumber = result.invalidPartNumber[0].label;
      this.partNumbershouldnotbemorethan18char = result.addCompetitorAddress.PartNumbershouldnotbe18characters[0].label;

    })
      .catch((error) => {
      })
      .finally(() => {
        this.isShowSpinner = false;
      });
    Promise.all([
      getPartsColumnHeaders({ reportName: 'partsTableHeader' })
    ])
      .then((results) => {
        var column = results[0];
        this.columnLabelByApiName = [...column];
      })
      .catch((error) => {

      })
      .finally(() => {
        this.isShowSpinner = false;
      });

  }

  fetchUserCountry() {
    getUsersCountry({})
      .then((result) => {
        this.userCountry = result ? result.toLowerCase() : '';
      })
      .catch((error) => {
        console.log('--error--', error?.message | error?.body?.message);
      })
  }

  get isCompetitveSales() {
    return this.headercsrtype == 'C';
  }

  get isEdit() {
    if (this.mode == 'Edit') {
      return true;
    } else {
      return false;
    }
  }
  get isView() {
    if (this.mode == 'View') {
      return true;
    } else {
      return false;
    }
  }

  get buttonClassName() {
    return this.buttonName;
  }

  get getSubmitBtnDisabled() {
    if (this.isCsrDataSubmitted) {
      this.submitBtnDisabled = true;
    }
    else if (!this.isCsrDataSubmitted) {
      this.submitBtnDisabled = false;
    }

    else {
      this.submitBtnDisabled = (this.stringPartsData === JSON.stringify(this.partsData));
    }

    return this.submitBtnDisabled;
  }

  get getDraftBtnDisabled() {
    return this.draftbtnDisabled;
  }

  get getPartSearchData() {
    let aa = this.csrParts();
    return aa;
  }


  csrParts() {
    if (this.isEdit || this.isView) {
      if (this.editpartlist) {
        let count = 0;
        const minBestNetThreshold = this.getMinThreshold();
        for (let key in this.editpartlist) {
          if (this.editpartlist.hasOwnProperty(key)) {
            let channeltype = this.editpartlist[key].Channel;
            if (channeltype == 'WHS') {
              channeltype = 'PDC';
            }
            if (this.editpartlist[key].Uspdcfnlnt > 0 && this.editpartlist[key].Uspdcfnlnt >= minBestNetThreshold) {
              this.isBestNetGreaterThanThreshold = true;
            } else if (this.editpartlist[key].Usdspfnlnt > 0 && this.editpartlist[key].Usdspfnlnt >= minBestNetThreshold) {
              this.isBestNetGreaterThanThreshold = true;
            }
            this.partsViewData[count] = {
              srNum: count + 1,
              Id: this.editpartlist[key].Itmid || '',
              Part: this.editpartlist[key].Itmid || '',
              PartDescription: this.editpartlist[key].ItemDesc || '',
              Channel: channeltype || '',
              Channels: [{ label: channeltype, value: channeltype }],
              Competitor: {
                CompetitorName: this.editpartlist[key].CompName || '',
                CompetitorCode: this.editpartlist[key].CompCode || '',
                CompCity: '', CompState: '', CompPostal: '', Affiliation: []
              },
              CompPart: this.editpartlist[key].CompPart || '',
              CompPrice: this.editpartlist[key].Price || '',
              Brand: this.editpartlist[key].CompName || '',
              isbestNetGreateThen200: this.isBestNetGreaterThanThreshold || ''
            }
          }

          count++;
        }
      }
    }

    if (this.isEdit || this.isView) {
      this.setPartsViewData();
    }
    return this.partsViewData.map((item, index) => ({ ...item, index: index + 1 }));
  }

  get totalPartsData() {
    return this.partsData.length;
  }

  get isDisplayPagination() {
    return this.partsData && this.partsData.length > 1;
  }

  get getCancelBtnDisabled() {
    if (!this.submitBtnDisabled) {
      this.buttonName = this.grayBtn;
    }
    if (!this.csrNumber || this.submitBtnDisabled || this.isCsrDataSubmitted) {
      this.buttonName = this.grayBtn;
      return true;
    }
    if (!this.isNonDealer && this.currentStatus == 'N'
      && (this.stringPartsData === JSON.stringify(this.partsData))
      && !this.csrNumber) {
      this.buttonName = this.grayBtn;
      return true;
    }
    else if (this.isNonDealer && (this.stringPartsData === JSON.stringify(this.partsData)) && !this.csrNumber) {
      this.buttonName = this.grayBtn;
      return true;
    }
    this.buttonName = "slds-button slds-button_small btn-group black-btn";
    return false;
  }


  @api
  get compDisabled() {
    if (this.headercsrtype == "B" || this.headercsrtype == "W" || this.isCsrDataSubmitted) {
      return true;
    }
    else {
      return false;
    }
  }

  get disabledForm() {
    if (this.isCsrDataSubmitted) {
      this.draftbtnDisabled = true;
      this.submitBtnDisabled = true;
    }
    return this.isCsrDataSubmitted;
  }

  @api
  get reqdInput() {
    if (this.headercsrtype == "B" || this.headercsrtype == "W") {
      return false
    }
    else {
      return true
    }
  }

  get deleteButtonVariant() {
    return this.partsData && this.partsData.length > 1 ? 'error' : 'base';
  }

  handleChannelOptionChange(event) {
    this.draftbtnDisabled = false;
    const rowIndex = event.target.dataset.index;
    const editedRow = this.partsData[rowIndex - 1];
    editedRow.Channel = event.target.value;
    let isBestNetGreaterThan200 = false;
    const minBestNetThreshold = this.getMinThreshold();
    if (editedRow.Channel === 'PDC') {
      isBestNetGreaterThan200 = editedRow.uspdcfnlnt >= minBestNetThreshold;
    } else if (editedRow.Channel === 'DSP') {
      isBestNetGreaterThan200 = editedRow.usdspfnlnt >= minBestNetThreshold;
    }

    editedRow.isbestNetGreateThen200 = isBestNetGreaterThan200
    this.partsData = [...this.partsData];

  }

  // use to add new row upon click on add button next to row
  handleAddRow() {
    this.draftbtnDisabled = false;
    const newRow = {
      srNum: this.partsData.length + 1,
      Id: (this.partsData.length + 1).toString,
      Part: '',
      PartDescription: '',
      //Quantity: '',
      Channel: '',
      Channels: [],
      Competitor: { Id: '', CompetitorName: '', Affiliation: [], City: '', State: '', PostalCode: '', Type: '' },
      CompPart: '',
      CompPrice: '',
      Brand: ''
    };
    this.partsData = [...this.partsData, newRow];
    debugger;
    this.setPartsViewData();
  }

  setPartsViewData() {
    //alert(JSON.stringify(this.partsData));
    debugger;
    if (this.pageNumber == 1) {
      this.partsViewData = this.partsData.slice(0, this.paginationPageSize);
    }
    else {
      let startIndex = (this.pageNumber - 1) * this.paginationPageSize;
      let endIndex = this.pageNumber * this.paginationPageSize;
      this.partsViewData = this.partsData.slice(startIndex, endIndex);
    }

  }
  // use to remove row upon click on delete button next to row
  handleDeleteRow(event) {
    if (this.partsData.length > 1) {
      // Handle delete row logic
      const index = event.target.dataset.index - 1;
      //Remove the record from the data array
      this.partsData.splice(index, 1);
      this.partsData = this.partsData.map((part, index) => ({ ...part, srNum: index + 1 }));
      this.partsData = [...this.partsData];
      this.draftbtnDisabled = false;
      if (this.paginationPageSize == this.partsData.length) {
        this.pageNumber = 1;
      }
      this.setPartsViewData();
    }
  }

  //use to open modal to show competitor list to choose or add
  handleOpenModalForCompetitorSelection(event) {
    if (this.headercsrtype != 'W' && this.headercsrtype != 'B') {
      this.openCompetitorModal = true;
      const srNum = event.target.dataset.index;
      this.searchIndex = srNum - 1;
      this.selectedPart = this.partsData[this.searchIndex];
      this.selectedCompetitorForAddCompetitor = { ...this.selectedPart.Competitor };
      if (this.selectedCompetitorForAddCompetitor && this.selectedCompetitorForAddCompetitor.tab === 'addCompetitor') {
        this.selectedCompId = '';
      } else {
        this.selectedCompetitorForAddCompetitor = {};
        if (this.selectedCompetitorsData && this.selectedCompetitorsData[this.searchIndex]) {
          this.selectedCompId = this.selectedCompetitorsData[this.searchIndex];
        }
        else {
          this.selectedCompId = '';
        }
      }
    } else {
      this.openCompetitorModal = false;
    }

  }

  // use to close modal opened for competitor list
  handleCloseCompetitorModal() {
    this.openCompetitorModal = false;
  }

  // this method use to get selected competitor data and store in part list
  handleChooseCompetitor(event) {
    this.draftbtnDisabled = false;
    this.selectedRowData = event.detail.selectedCompetitor;
    if (this.selectedRowData != null && this.selectedCompetitor == '') {
      this.openCompetitorModal = false;
      this.draftbtnDisabled = false;
      this.selectedCompetitor = this.selectedRowData.CompetitorName;
      this.selectedCompetitorsData[this.searchIndex.toString()] = this.selectedRowData.CompetitorName;
      this.partsData[this.searchIndex].Competitor = this.selectedRowData;
    } else if (this.selectedCompetitor != '') {
      this.openCompetitorModal = false;
      this.selectedCompetitor = this.selectedRowData.CompetitorName;
      this.selectedCompetitorsData[this.searchIndex.toString()] = this.selectedRowData.CompetitorName;
      this.partsData[this.searchIndex].Competitor = this.selectedRowData;
    }
    else {
      this.openCompetitorModal = false;
      this.partsData[this.searchIndex].Competitor = '';
    }
  }

  //this is for getting new added competitor form data
  handleAddCompetitor(event) {
    this.draftbtnDisabled = false;
    this.addedCompetitor = event.detail.selectedCompetitor;
    if (this.addedCompetitor != null) {
      this.openCompetitorModal = false;
    }
  }

  handleOpenModalForPartSelection(event) {
    this.openPartSearchModal = true;
    const srNum = event.target.dataset.index;
    this.searchIndex = srNum - 1;
    const editedRow = this.partsData[searchIndex];
    this.csrPartvalid(editedRow);
    this.partsData = [...this.partsData];
    this.setPartsViewData();
  }

  handleClosePartSearchModal() {
    this.openPartSearchModal = false;
  }

  // adds line from PartSearch to CSR lines
  handleAddToCSR(event) {
    this.selectedRows = event.detail.selectedRows;
    const minBestNetThreshold = this.getMinThreshold();

    this.openAlternativePartSearchModal = false;
    this.showSearchResults = false;
    this.partNumberValue = "";
    //this.qty = 1;
    let index = this.searchIndex;
    let tempData = [];
    let firstInserted = false;
    let counter = 0;
    if (this.selectedRows.length > 0) {

      //Remove the record from the data array
      for (let i = 0; i < this.selectedRows.length; i++) {

        let partDataInfo = { Id: (parseInt(this.searchIndex) + i).toString(), Part: ' ', PartDescription: ' ', Channel: '', Channels: [], srNum: 1, Competitor: { Id: '', CompetitorName: '', Affiliation: [], City: '', State: '', PostalCode: '', Type: '' }, CompPart: '', CompPrice: '', Brand: '', isSelected: false };
        partDataInfo.Part = this.selectedRows[i].partnumber;
        partDataInfo.PartDescription = this.selectedRows[i].description;
        //partDataInfo.Quantity = parseInt(this.selectedRows[i].qty);
        partDataInfo.Channel = this.selectedRows[i].channel;
        partDataInfo.Channels = this.selectedRows[i].channels;
        //partDataInfo.isbestNetGreateThen200 = this.selectedRows[i].isbestNetGreateThen200;
        partDataInfo.isSelected = true;
        partDataInfo.uspdcfnlnt = this.selectedRows[i].uspdcfnlnt;
        partDataInfo.usdspfnlnt = this.selectedRows[i].usdspfnlnt;
        if (partDataInfo.Channel === 'PDC') {
          partDataInfo.isbestNetGreateThen200 = partDataInfo?.uspdcfnlnt >= minBestNetThreshold;
        } else if (partDataInfo.Channel === 'DSP') {
          partDataInfo.isbestNetGreateThen200 = partDataInfo?.usdspfnlnt >= minBestNetThreshold;
        } else {
          partDataInfo.isbestNetGreateThen200 = false;
        }
        if (!firstInserted) {
          this.partsData[index] = partDataInfo;
          firstInserted = !firstInserted;
          index++;
          continue;
        }
        counter = 0;
        if (index < this.partsData.length) {
          for (let j = index; j < this.partsData.length; j++) {
            if (this.partsData[j].Part == '') {
              this.partsData[j] = partDataInfo;
              index = j + 1;
              break;
            }
            counter = j;
          }
        }
        else {
          tempData.push(partDataInfo);
        }
        if (counter == (this.partsData.length - 1) && counter != 0) {
          tempData.push(partDataInfo);
        }
      }
      if (tempData.length > 0) {
        this.partsData = [...this.partsData, ...tempData];
      }
      let srNum = 1;
      for (let element of this.partsData) {

        element.srNum = srNum;
        element.Id = srNum - 1;
        srNum++;
      }
      this.setPartsViewData();
      this.selectedRows = [];
      this.draftbtnDisabled = false;

      if (this.headercsrtype == 'W') {
        this.openCompetitorModal = false;
        this.wreckcompDisabled = true;
        this.reqdInput = false;
      }
    }
  }

  handleCompPartChange(event) {
    this.draftbtnDisabled = false;
    // Get the row index from the custom data attribute
    const rowIndex = event.target.dataset.index - 1;
    const editedRow = this.partsData[rowIndex];
    editedRow.CompPart = event.target.value;
    //this.csrPartvalid(editedRow);
    this.partsData = [...this.partsData];
    this.setPartsViewData();
  }

  handleCompPriceChange(event) {
    this.draftbtnDisabled = false;
    const rowIndex = event.target.dataset.index - 1;
    const editedRow = this.partsData[rowIndex];
    editedRow.CompPrice = event.target.value;
    //this.csrPartvalid(editedRow);
    this.partsData = [...this.partsData];
    this.setPartsViewData();
  }


  handleBrandChange(event) {
    this.draftbtnDisabled = false;
    const rowIndex = event.target.dataset.index - 1;
    const editedRow = this.partsData[rowIndex];
    editedRow.Brand = event.target.value;
    //this.csrPartvalid(editedRow);
    this.partsData = [...this.partsData];
    this.setPartsViewData();
  }
  isCSRPartDataValid() {
    let isValid = true;

    let selectedpart = [...this.payload.partDataList];
    // Iterate over each object in partsViewData
    selectedpart.forEach(part => {
      let isPartValid = this.csrPartvalid(part);
      if (!isPartValid) {
        isValid = false;
      }
    });
    this.partsViewData = selectedpart;
    return isValid;

  }
  //used to validate input form
  isCSRPartDataValidBeforeApiCall() {
    let isValid = true;

    let selectedpart = [...this.payload.partDataList];
    // Iterate over each object in partsViewData
    selectedpart.forEach(part => {
      let isPartValid = this.csrPartvalid(part);
      if (!isPartValid) {
        isValid = false;
      }
    });
    this.partsViewData = selectedpart;
    return isValid;

  }
  csrPartvalid(part) {
    let isValid = true;
    var errors = [];

    if (part.errorMessages.length>0) {
      errors = part.errorMessages;
        isValid = false;
    }



    if (!part.Part
      || !part.Channel
      || !part.Competitor.CompetitorName
      || !part.CompPart
      || this.checkAndTrimWhitespace(part.CompPart)
      || !part.CompPrice
      || isNaN(part.CompPrice)
      || !this.validateForNumberOrDecimal(part.CompPrice)
      || part.isDuplicate) {


      errors = errors.filter(item => item !== this.requredFieldMisssingError);

      if (!part.Part.trim() || !part.PartDescription.trim()) {
        if (!errors.includes(this.requredFieldMisssingError)) {
          errors.push(this.requredFieldMisssingError);
          isValid = false;
          part.className = 'part-List-Color';
        }
        part.errorPart = 'errorInput';
      } else {
        part.errorPart = '';
      }
      if (!part.Channel) {
        if (!errors.includes(this.requredFieldMisssingError)) {
          errors.push(this.requredFieldMisssingError);
          isValid = false;
          part.className = 'part-List-Color';
        }
        part.errorChannel = 'errorInput';
      } else {
        part.errorChannel = '';
      }

      if (this.headercsrtype == 'C') {
        if (!part.Competitor || !part.Competitor.CompetitorName) {
          if (!errors.includes(this.requredFieldMisssingError)) {
            errors.push(this.requredFieldMisssingError);
            isValid = false;
            part.className = 'part-List-Color';
          }
          part.errorCompetitorName = 'errorInput';

        } else {
          part.errorCompetitorName = '';

        }
        if (!part.CompPart || this.checkAndTrimWhitespace(part.CompPart)) {
          if (!errors.includes(this.requredFieldMisssingError)) {
            errors.push(this.requredFieldMisssingError);
            isValid = false;
            part.className = 'part-List-Color';
          }
          part.errorCompPart = 'errorInput';

        } else {
          part.errorCompPart = '';

        }
        if (!part.CompPrice || isNaN(part.CompPrice) || !this.validateForNumberOrDecimal(part.CompPrice)) {
          if (!errors.includes(this.requredFieldMisssingError)) {
            errors.push(this.requredFieldMisssingError);
            isValid = false;
            part.className = 'part-List-Color';
          }
          part.errorCompPrice = 'errorInput';
        } else {
          part.errorCompPrice = '';
        }
      }
      if (this.headercsrtype == 'W') {
        if (part.isbestNetGreateThen200 == false) {
          part.errorMessages.push(this.itemAmountThresholdError);
          part.className = 'part-List-Color';
          isValid = false;

        }
      }
      if (part.isDuplicate) {
        isValid = false;
        part.className = 'part-List-Color';
      }
      part.errorMessages = errors;
    }

    else {
      part.errorMessages = [];
      part.className = '';
      part.errorCompPart = '';
      part.errorChannel = '';
      part.errorCompetitorName = '';
      part.errorCompPrice = '';
      part.errorPart = '';
      part.inputeClass = 'errorInput';
      isValid = true;
    }
    if (this.headercsrtype == 'W') {
      part.errorCompPart = '';
      part.errorCompetitorName = '';
      part.errorCompPrice = '';
      if (part.isbestNetGreateThen200 == false) {
        if (!part.errorMessages.includes(this.itemAmountThresholdError)) {
          part.errorMessages.push(this.itemAmountThresholdError);
        }
        part.className = 'part-List-Color';
        isValid = false;

      }
    }

    if (part.Part.length > 18) {
      if (!part.errorMessages.includes(this.partNumbershouldnotbemorethan18char)) {
        part.errorMessages.push(this.partNumbershouldnotbemorethan18char);
      }
      part.Channels = [{ "label": "DSP", "value": "DSP" }, { "label": "PDC", "value": "PDC" }];
      part.className = 'part-List-Color';
      isValid = false;
    }

    if (this.headercsrtype == 'B') {
      part.errorCompPart = '';
      part.errorCompetitorName = '';
      part.errorCompPrice = '';
    }

    return isValid;
  }
  //used to validate dealer and csr type combination
  isTypeCombinationValid() {
    let isValid = true;
    if (this.headerdealertype == 'G' && this.headercsrtype == 'W') {
      isValid = false;
      //  this.TitleMessage = this.groupwreckcombinationtitleerror;
      const evt = new ShowToastEvent({
        title: this.label.EDealer_Dealer_and_CSR_Type_Error_Title,    //TitleMessage,
        message: this.label.EDealer_Group_Wreck_Comb_Error_Message,
        variant: 'ERROR',
        mode: 'Sticky',
      });
      this.dispatchEvent(evt);
    }
    return isValid;
  }
  buildPayload() {
    let headerInfo = {
      DealerId: this.headerdealercode,
      CSRType: this.headercsrtype,
      CompetitiveType: this.headercompetitivetype,
      DealerType: this.headerdealertype,
      CustomerName: this.headercustomername,
      CsrUser: this.dealerUserName,
      Chassi: this.headerchassisnumber,
      InsComp: this.headerinsurancecompany,
      Writeoff: this.headerwriteoffvalue,
      DlrDisc: this.headerdealerdiscount,
      DurBid: this.headerduration,
      ExpMarkUp: this.headerexpectedmarkup,
      Status: ''
    }
    this.payload = {
      headerData: headerInfo,
      partDataList: this.partsData
    }
  }

  //save as draft
  async handleSaveAsDraftButtonClick(event) {
    this.rows = [];
    this.buildPayload();
    await this.validatePartsFromAPI(this.payload.partDataList, this.headerdealercode);

    this.showTooltip = false;
    if (this.removeValidation.length > 0) {
      this.removeValidations();

    }
    this.prepareErrorMessageForPartsRow();

    this.payload.headerData.Status = 'N';
    let evt = new CustomEvent('savetodraft', {
      detail: {
        payload: this.payload
      }
    });
    this.dispatchEvent(evt);

    let validatepartsinfo = true;
    let isTypeCombinationValid = true;
    if (this.headercsrtype == 'W') {
      // validatepartsinfo = this.validatePartsList(this.payload.partDataList);
      validatepartsinfo = this.validatePartsList();
      isTypeCombinationValid = this.isTypeCombinationValid();
    }

    let isCSRPartDataValid;
    this.findDuplicatePartsByChannel();

    isCSRPartDataValid = this.isCSRPartDataValid();


    if (validatepartsinfo && this.isParentValidated && isCSRPartDataValid && isTypeCombinationValid) {
      this.isShowSpinner = true;
      this.handleLoadingEvent(this.isShowSpinner);
      this.fileDetails.forEach((item) => {
        const files = {
          s3_bucket: "gatewayrealese2-testbucket",
          DealerCode: this.dealerCode,
          Phase: this.csrPhase,
          CSRNumber: this.csrNumber,
          file_Base64: item.blobData,
          filename_extension: item.fileName,
        };

        this.base64result.push(files);
      });

      saveCSRChanges({ payload: JSON.stringify(this.payload), csrNumber: this.csrNumber, phase: this.csrPhase, jsonFileDetails: JSON.stringify(this.fileDetails) })
        .then((result) => {

          let apiError = result['apiError'];
          this.draftbtnDisabled = false;
          this.submitBtnDisabled = false;
          this.buttonName = "slds-button slds-button_small btn-group black-btn";
          let csrNumber = result['csr_num'];
          let errMessage = result['error_message'];
          this.csrPhase = result['phase'];
          this.csrNumber = csrNumber;
          this.isShowSpinner = false;
          this.handleLoadingEvent(this.isShowSpinner);
          if (errMessage) {
            const evt = new ShowToastEvent({
              message: this.label.Edealer_Save_As_Draft_Msg + '\n' + errMessage,
              variant: 'warning',
            });
            this.dispatchEvent(evt);

          } else if (apiError && !errMessage) {
            this.buttonName = this.grayBtn;
            const evt = new ShowToastEvent({
              message: this.label.Edealer_Ops_Failed + '\n' + apiError,
              variant: 'ERROR',
            });
            this.dispatchEvent(evt);
          }
          else {
            const evt = new ShowToastEvent({
              message: this.label.Edealer_Save_As_Draft_Msg,
              variant: 'SUCCESS',
            });
            this.dispatchEvent(evt);
          }
          if (csrNumber) {
            let evt = new CustomEvent('sendcsrnumber', {
              detail: {
                csrNumber: csrNumber,
                phase: this.csrPhase
              }
            });
            this.dispatchEvent(evt);
          }
        })
        .catch((error) => {
          this.buttonName = this.grayBtn;
          this.isShowSpinner = false;
          this.handleLoadingEvent(this.isShowSpinner);
          this.error = error;
          const evt = new ShowToastEvent({
            message: this.label.Edealer_Ops_Failed,
            variant: 'ERROR',
          });
          this.dispatchEvent(evt);
        });
    }
    var startindex = this.paginationPageSize * (this.pageNumber - 1);
    var endindex = this.paginationPageSize * (this.pageNumber);
    if (!this.isEdit && !this.isView) {
      if (startindex > 0) {
        this.partsViewData = this.partsData.slice(startindex, endindex);
      } else if (this.partsViewData.length > 1) {
        this.partsViewData = this.partsData.slice(0, this.paginationPageSize);
      }
    }
  }

  isInputValidTest() {
    let errors = [];
    let inputFields = this.template.querySelectorAll(".validate");
    inputFields.forEach((inputField, index) => {
      if (!inputField.checkValidity()) {
        inputField.reportValidity();
        errors.push({ index: index, error: inputField.validationMessage });
      }
    });
    return errors;
  }

  resetScreenAfterSaveChanges() {
    this.partsData = [
      { Id: '1', Part: ' ', PartDescription: ' ', Quantity: ' ', Channel: '', Channels: [], Competitor: { Id: '', CompetitorName: '', Affiliation: [], City: '', State: '', PostalCode: '', Type: '' }, CompPart: '', CompPrice: '', Brand: '', isSelected: false, srNum: 1, isbestNetGreateThen200: false }
    ];
    const payload = {
      detail: 'Refresh Screen'
    };
    publish(this.messageContext, CSR_CHANNEL, payload);
    this.partsViewData = this.partsData;
  }

  async resetPartListLines(event) {
    if (event.target.name === 'openConfirmation') {
      this.isDialogVisible = true;
    } else if (event.target.name === 'confirmModal') {
      // when user clicks outside of the dialog area, the event is dispatched with detail value  as 1
      if (event.detail !== 1) {
        // you can do some custom logic here based on your scenario
        if (event.detail.status === 'confirm') {
          if (this.isNonDealer) {
            this.handleCancelCSR();
          }
          // For Dealer user 
          else if (!this.isNonDealer) {
            this.handleCancelCSR();
          }
        } else if (event.detail.status === 'cancel') {
          this.isDialogVisible = false;
        }
      }
      //hides the component
      this.isDialogVisible = false;
    }
  }

  // This method called when we click on Submit button to submit CSR.
  async handleSubmitCSR() {
    this.rows = [];
    this.buildPayload();
    await this.validatePartsFromAPI(this.payload.partDataList, this.headerdealercode);

    this.showTooltip = false;
    if (this.removeValidation.length > 0) {
      this.removeValidations();
    }
    this.prepareErrorMessageForPartsRow();
    this.payload.headerData.Status = 'N';
    let evt = new CustomEvent('savetodraft', {
      detail: {
        payload: this.payload
      }
    });
    this.dispatchEvent(evt);
    let validatepartsinfo = true;
    let isTypeCombinationValid = true;
    if (this.headercsrtype == 'W') {
      // validatepartsinfo = this.validatePartsList(this.payload.partDataList);
      validatepartsinfo = this.validatePartsList();
      isTypeCombinationValid = this.isTypeCombinationValid();
    }

    let isCSRPartDataValid;
    this.findDuplicatePartsByChannel();
    isCSRPartDataValid = this.isCSRPartDataValid();


    if (validatepartsinfo && this.isParentValidated && isCSRPartDataValid && isTypeCombinationValid) {
      this.isShowSpinner = true;
      this.handleLoadingEvent(this.isShowSpinner);
      this.fileDetails.forEach((item) => {
        const files = {
          s3_bucket: "gatewayrealese2-testbucket",
          DealerCode: this.dealerCode,
          Phase: this.csrPhase,
          CSRNumber: this.csrNumber,
          file_Base64: item.blobData,
          filename_extension: item.fileName,
        };

        this.base64result.push(files);
      });

      submitCSR({ payload: JSON.stringify(this.payload), csrNumber: this.csrNumber, phase: this.csrPhase, jsonFileDetails: JSON.stringify(this.fileDetails) })
        .then((result) => {
          this.stringPartsData = JSON.stringify(this.partsData);
          let csrNumber = result['csr_num'];
          let apiError = result['apiError'];
          this.csrPhase = result['phase'];
          let errMessage = result['error_message'];
          this.csrNumber = csrNumber;
          this.isCsrDataSubmitted = true;
          this.draftbtnDisabled = true;
          this.submitBtnDisabled = true;
          this.buttonName = this.grayBtn;
          this.isShowSpinner = false;
          this.handleLoadingEvent(this.isShowSpinner);
          if (errMessage) {
            const evt = new ShowToastEvent({
              message: this.label.Edealer_CSR_Submitted + '\n' + errMessage,
              variant: 'warning',
            });
            this.dispatchEvent(evt);
          } else if (apiError && !errMessage) {
            this.isCsrDataSubmitted = false;
            this.draftbtnDisabled = false;
            this.submitBtnDisabled = false;

            const evt = new ShowToastEvent({
              message: this.label.Edealer_Ops_Failed + '\n' + apiError,
              variant: 'ERROR',
            });
            this.dispatchEvent(evt);
          }
          else {

            const evt = new ShowToastEvent({
              message: this.label.Edealer_CSR_Submitted + '- ' + csrNumber,
              variant: 'SUCCESS',
              mode: 'Sticky',
            });
            this.dispatchEvent(evt);
            this.handleOpenCsrListing();
          }

          let disableEvt = new CustomEvent('disablecsrheader', {
            detail: {
              isCsrDataSubmitted: this.isCsrDataSubmitted
            }
          });
          this.dispatchEvent(disableEvt);

          if (this.csrNumber) {
            let evt = new CustomEvent('sendcsrnumber', {
              detail: {
                csrNumber: csrNumber,
                phase: this.csrPhase
              }
            });
            this.dispatchEvent(evt);
          }

          let statusEvt = new CustomEvent('changecsrstatus', {
            detail: {
              csrStatus: 'S'
            }
          });
          this.dispatchEvent(statusEvt);


        })
        .catch((error) => {
          this.error = error;

          this.isShowSpinner = false;
          this.handleLoadingEvent(this.isShowSpinner);
          const evt = new ShowToastEvent({
            message: this.label.Edealer_Ops_Failed + error,
            variant: 'ERROR',
          });
          this.dispatchEvent(evt);
        });
    }

  }

  handleTotalRecordChange(event) {
    let indexes = event.detail;
    this.partsViewData = this.partsData.slice(indexes.startIndex, indexes.endIndex);
  }


  handleNextButton(event) {
    const scrollElement = this.template.querySelector('.scrollbarCls');
    scrollElement?.scrollIntoView({ behavior: 'smooth' });
    let indexes = event.detail;
    this.partsViewData = this.partsData.slice(indexes.startIndex, indexes.endIndex);
  }

  handlePrevButton(event) {
    const scrollElement = this.template.querySelector('.scrollbarCls');
    scrollElement?.scrollIntoView({ behavior: 'smooth' });
    let indexes = event.detail;
    this.partsViewData = this.partsData.slice(indexes.startIndex, indexes.endIndex);
  }

  handlePageNumberChange(event) {
    this.paginationPageSize = event.detail.pagesize;
    this.pageNumber = event.detail.pagenumber;
    var startindex = this.paginationPageSize * (this.pageNumber - 1);
    var endindex = this.paginationPageSize * (this.pageNumber);
    if (!this.isEdit && !this.isView) {
      if (startindex > 0) {
        this.partsViewData = this.partsData.slice(startindex, endindex);
      } else if (this.partsViewData.length > 1) {
        this.partsViewData = this.partsData.slice(0, this.paginationPageSize);
      }
    }
  }

  handleLoadingEvent(isLoading) {
    let evt = new CustomEvent('sendspinner', {
      detail: {
        isShowSpinner: isLoading
      }
    });
    this.dispatchEvent(evt);
  }

  validateCompetitors(parts) {
    let validateCompetitor = true;
    if (this.headercsrtype != 'W' && this.headercsrtype != 'B') {
      for (const part of parts) {
        let errors = [];
        if (part.errorMessages) {
          errors = part.errorMessages;
        }
        if (part.Competitor === " ") {
          validateCompetitor = false;
          if (part.errorMessages && !part.errorMessages.includes(this.label.Edealer_Missing_Competitor))
            errors.push(this.label.Edealer_Missing_Competitor);
        } else if (part.Competitor !== " "
          && part.Competitor.hasOwnProperty('CompetitorCode')
          && part.Competitor.CompetitorCode === "") {
          validateCompetitor = false;
          if (part.errorMessages && !part.errorMessages.includes(this.label.Edealer_Missing_Competitor))
            errors.push(this.label.Edealer_Missing_Competitor);
        } else if (!part.Competitor.hasOwnProperty('CompetitorCode')) {
          validateCompetitor = false;
          if (part.errorMessages && !part.errorMessages.includes(this.label.Edealer_Missing_Competitor))
            errors.push(this.label.Edealer_Missing_Competitor);
        }
        part.errorMessages = errors;
      }
    }

    return validateCompetitor;
  }

  showCompetitorValidationError() {
    const evt = new ShowToastEvent({
      message: this.label.Edealer_Missing_Competitor,
      variant: 'ERROR',
    });
    this.dispatchEvent(evt);
  }

  //This method use to validate parts list info on Save As Draft/Submit.
  validatePartsList() {
    let validatepartsinfo = true;
    let selectedpart = [...this.payload.partDataList];
    selectedpart.forEach(item => {
      if (!item.errorMessages) {
        item.errorMessages = [];
      }
      if (item.isbestNetGreateThen200 == false) {
        if (!item.errorMessages.includes(this.itemAmountThresholdError)) {
          item.errorMessages.push(this.itemAmountThresholdError);
        }
        item.className = 'part-List-Color';
        validatepartsinfo = false;
      } else {
        if (item.errorMessages.includes(this.itemAmountThresholdError)) {
          const index = item.errorMessages.findIndex(
            msg => msg === this.itemAmountThresholdError
          );
          if (index !== -1) {
            item.errorMessages.splice(index, 1);
          }

        }
        item.errorMessages.filter(item => !item.includes(this.itemAmountThresholdError));
        //  alert(item.errorMessages);
      }
    });
    this.payload.partDataList = selectedpart;
    return validatepartsinfo;
  }

  handleCancelCSR() {
    this.resetScreenAfterSaveChanges();
    this.isShowSpinner = true;
    this.handleLoadingEvent(this.isShowSpinner);

    cancelCSR({ userName: this.dealerUserName, csrNumber: this.csrNumber, csrPhase: this.csrPhase })
      .then((result) => {

        this.csrNumber = '';
        this.isShowSpinner = false;
        this.handleLoadingEvent(this.isShowSpinner);
        this.stringPartsData = JSON.stringify(this.partsData);
        this.submitBtnDisabled = true;
        this.buttonName = this.grayBtn;
        const evt = new ShowToastEvent({
          message: this.label.Edealer_CSR_Cancelled,
          variant: 'SUCCESS',
        });
        this.dispatchEvent(evt);

        let evt1 = new CustomEvent('sendcsrnumber', {
          detail: {
            csrNumber: this.csrNumber
          }
        });
        this.dispatchEvent(evt1);
      }).catch((error) => {
        this.error = error;
        this.isShowSpinner = false;
        this.handleLoadingEvent(this.isShowSpinner);
        this.showErrorMessage(this.label.EDealer_Cancel_Operation_Failed, this.label.EDealer_Cancel_Operation_Failed);
      });
  }

  showErrorMessage(title, message) {
    const evt = new ShowToastEvent({
      message: message,
      variant: 'ERROR',
    });
    this.dispatchEvent(evt);
  }

  @api handleCSRTypeChange(csrType) {
    this.headercsrtype = csrType;
    if ( csrType == 'C') {
      this.csrParts()
    }
  
  }
 
  showError() {
    this.showTooltip = !this.showTooltip;
  }

  handleOpenCsrListing() {
    const dealercodes = this.selectedlocation;
    const csrlistingoption = 'pendingcsrlisting';
    const frequency = 'All';
    const csrtype = 'All';

    const openpendingcsrsEvent = new CustomEvent('opencsrlisting', {
      detail: { csrlistingoption, dealercodes, frequency, csrtype },
      bubbles: true,
      composed: true
    }
    );
    this.dispatchEvent(openpendingcsrsEvent);

  }
  get invalidPartRowDataValidation() {
    return this.showTooltip;
  }
  removeValidations() {
    for (var i = 1; i < this.removeValidation.length; i++) {
      var row = this.removeValidation[i];
      var remove = this.template.querySelector('[data-id="' + row + '"]');
      if (remove) {
        const errorIcon = remove.querySelector('[data-id=hide-and-show-error-icon]')
        if (errorIcon) {
          errorIcon.classList.add('slds-hide');
        }
        remove.className = '';

      }

    }
  }

  openModal() {
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
  }

  handleFileChange(event) {

    const uploadedFile = event.detail.files[0];

    if (uploadedFile) {
      this.disableUploadButton = false;
    } else {
      this.disableUploadButton = true;
    }

    const reader = new FileReader();
    reader.onload = (e) => {
      const arrayBuffer = e.target.result;
      const workbook = XLSX.read(arrayBuffer, { type: 'array' });
      const sheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[sheetName];
      const jsonData = XLSX.utils.sheet_to_row_object_array(worksheet);
    }
  }


  prepareErrorMessageForPartsRow() {
    const tableRows = this.template.querySelectorAll('tbody tr');
    const missingColumns = [];
    tableRows.forEach(row => {
      const cells = Array.from(row.querySelectorAll('td'));
      const missingValues = {};
      cells.forEach(cell => {
        const input = cell.querySelector('.validate input');
        if (input && input.hasAttribute('required') && !input.value.trim()) {
          const columnName = cell.getAttribute('name');
          const value = input.value.trim();
          missingValues[columnName] = value;
        }
      });
      if (Object.keys(missingValues).length > 0) {
        missingColumns.push(missingValues);
      }
    });

    if (missingColumns.length === 0) {
    } else {
    }
  }
  validateMassUpload(partData, dealerCode) {
    this.isShowSpinner = true;
    let requestPayload = [];
    let hasErrors = false;  // Variable to track if there are any errors

    partData.forEach(item => {
      if (item.isMassUploadRow) {
        let requestObject = {
          "PartNumber": item.Part,
          "PartQty": 1,
          "CompCd": item.Competitor.CompetitorCode,
        };
        if (item.Part.length <= 18) {
          requestPayload.push(requestObject);
        }
      }
    });

    let requestPayloadObj = {
      "DealerCd": dealerCode,
      "CSRType": this.headercsrtype,
      "CallingSystem": "I",
      "PartNo": requestPayload
    }

    validatePartNumber({ payload: JSON.stringify(requestPayloadObj) })
      .then((result) => {
        let partsUpload = [...partData];
        let resultData = JSON.parse(result).Data.PartNos;
        const minBestNetThreshold = this.getMinThreshold();
        resultData.forEach(item => {
          if (item.ErrMsg.length == 0) {
            partsUpload.forEach(partItem => {
              if (partItem.Part == item.PartNo) {
                partItem.PartDescription = item.PartDesc;
                if (item.PdcFlg == 'Y' && item.DspFlg == 'N') {
                  partItem.Channels = [{ "label": "PDC", "value": "PDC" }];
                  partItem.Channel = "PDC";
                } else if (item.DspFlg == 'Y' && item.PdcFlg == 'N') {
                  partItem.Channels = [{ "label": "DSP", "value": "DSP" }];
                  partItem.Channel = "DSP";
                }
                else if (item.DspFlg == 'Y' && item.PdcFlg == 'Y') {
                  partItem.Channels = [{ "label": "DSP", "value": "DSP" }, { "label": "PDC", "value": "PDC" }];
                  partItem.Channel = "PDC";
                }

                if (partItem.Channel === 'PDC') {
                  if (item.Uspdcfnlnt > 0 && item.Uspdcfnlnt >= minBestNetThreshold) {
                    this.isBestNetGreaterThanThreshold = true;
                  }
                } else if (partItem.Channel === 'DSP') {
                  if (item.Usdspfnlnt > 0 && item.Usdspfnlnt >= minBestNetThreshold) {
                    this.isBestNetGreaterThanThreshold = true;
                  }
                } else {
                  this.isBestNetGreaterThanThreshold = false;
                }
                partItem.isbestNetGreateThen200 = this.isBestNetGreaterThanThreshold;
                partItem.uspdcfnlnt = item.Uspdcfnlnt;
                partItem.usdspfnlnt = item.Usdspfnlnt;
              }
            });
          } else if (item.ErrMsg.length > 0) {
            hasErrors = true;  // Set hasErrors to true if there are any error messages
            var errors = [];
            item.ErrMsg.forEach(errorMsg => {
              partsUpload.forEach(partItem => {
                if (partItem.Part == item.PartNo) {
                  if (errorMsg.ErrDesc !== "") {
                    if (errorMsg.ErrDesc === 'Invalid Part Number') {
                      errorMsg.ErrDesc = this.invalidPartNumber;
                    }
                    errors.push(errorMsg.ErrDesc);
                    partItem.errorMessages = errors;
                    partItem.className = 'part-List-Color';
                  } else {
                    partItem.PartDescription = item.PartDesc;
                    if (item.PdcFlg == 'Y' && item.DspFlg == 'N') {
                      partItem.Channels = [{ "label": "PDC", "value": "PDC" }];
                      partItem.Channel = "PDC";
                    } else if (item.DspFlg == 'Y' && item.PdcFlg == 'N') {
                      partItem.Channels = [{ "label": "DSP", "value": "DSP" }];
                      partItem.Channel = "DSP";
                    }
                    else if (item.DspFlg == 'Y' && item.PdcFlg == 'Y') {
                      if (item.Uspdcfnlnt == 0) {
                        partItem.Channels = [{ "label": "DSP", "value": "DSP" }];
                        partItem.Channel = "DSP";
                      } else if (item.Usdspfnlnt == 0) {
                        partItem.Channels = [{ "label": "PDC", "value": "PDC" }];
                        partItem.Channel = "PDC";
                      } else if (item.Uspdcfnlnt > 0 && item.Usdspfnlnt > 0) {
                        partItem.Channels = [{ "label": "DSP", "value": "DSP" }, { "label": "PDC", "value": "PDC" }];
                        partItem.Channel = "PDC";
                      }
                    }
                    if (partItem.Channel === 'PDC') {
                      if (item.Uspdcfnlnt > 0 && item.Uspdcfnlnt >= minBestNetThreshold) {
                        this.isBestNetGreaterThanThreshold = true;
                      }
                    } else if (partItem.Channel === 'DSP') {
                      if (item.Usdspfnlnt > 0 && item.Usdspfnlnt >= minBestNetThreshold) {
                        this.isBestNetGreaterThanThreshold = true;
                      }
                    } else {
                      this.isBestNetGreaterThanThreshold = false;
                    }
                    partItem.isbestNetGreateThen200 = this.isBestNetGreaterThanThreshold;
                    partItem.uspdcfnlnt = item.Uspdcfnlnt;
                    partItem.usdspfnlnt = item.Usdspfnlnt;
                  }
                }
              });
            });
          }
        });

        this.partsViewData = partsUpload;
        this.isShowSpinner = false;
        this.isMassValid = true;


        if (hasErrors) {
          return false;  // Return false if there are any errors
        }

      })
      .catch((error) => {
        this.error = error;
        const evt = new ShowToastEvent({
          message: this.label.Edealer_Ops_Failed,
          variant: 'ERROR',
        });
        this.dispatchEvent(evt);
        this.isShowSpinner = false;
        return false;  // Return false if there is an error in the API call
      });
  }

  handleMassUpload(event) {
    const data = event.detail;
    let parts = [];
    if (this.partsViewData && this.partsViewData.length > 0) {
      if (this.partsViewData.length == 1 && !this.partsViewData[0].Part.trim()) {
        this.partsViewData = data;
        this.partsData = data;
      } else {
        parts = this.partsViewData;
        data.forEach(item => {
          parts.push(item);
        });
        this.partsViewData = parts;
        this.partsData = parts;
      }
    }
    //this.partsData = data;
    this.prepareErrorMessageForPartsRow();
    let isValida = this.validateMassUpload(this.partsViewData, this.headerdealercode);
    this.isEdit = false;
    this.isView = false;
  }
  // refactored findDuplicatePartsbyChannel to fix reported issue about Item_Channel combination. IR# INC0128468 Chito B. 11-18-2025
  findDuplicatePartsByChannel() {
      let isValid = true;
      let selectedpart = [...this.payload.partDataList];

      // Reset duplicate flags and error messages
      selectedpart.forEach(item => {
          item.className = '';
          item.errorMessages = [];
          item.isDuplicate = false;
      });

      // Map to track unique Part-Channel combinations
      const duplicateParts = {};

      selectedpart.forEach(item => {
          const part = item.Part ? item.Part.trim() : '';
          const channel = item.Channel ? item.Channel.trim() : '';

          // Skip validation if either Part or Channel is missing
          if (!part || !channel) {
              return;
          }

          const key = `${part}-${channel}`;

          if (duplicateParts[key]) {
              // Duplicate found for same Part + Channel
              item.isDuplicate = true;
              item.className = 'part-List-Color';
              if (!item.errorMessages) {
                  item.errorMessages = [];
              }
              item.errorMessages.push(`${this.duplicateWithSR} ${duplicateParts[key].join(', ')}`);
              isValid = false;
          } else {
              duplicateParts[key] = [item.srNum];
          }
      });

      this.payload.partDataList = selectedpart;
      return isValid;
  }

  checkAndTrimWhitespace(str) {
    var partNo = str.toString();
    return partNo.trim().length === 0;
  }
  validateForNumberOrDecimal(number) {
    let stringNumber = number.toString();
    let stringNumberwithTrim = stringNumber.trim();
    return stringNumberwithTrim.length === stringNumber.length;
  }

  getMinThreshold() {
    return this.userCountry &&
      this.headercsrtype &&
      this.headercsrtype?.toLowerCase() == 'w' &&
      ['mx', 'mex', 'mexico'].includes(this.userCountry) ? 20 : this.wreckCSRMinPrice;
  }
  async validatePartsFromAPI(partData, dealerCode) {
    try {
      this.isShowSpinner = true;
      let requestPayload = [];

      // Build request payload
      partData.forEach(item => {
        if (item.Part && item.Part.length <= 18) {
          requestPayload.push({
            PartNumber: item.Part,
            PartQty: 1,
            CompCd: item.Competitor?.CompetitorCode || ''
          });
        }
      });

      const requestPayloadObj = {
        DealerCd: dealerCode,
        CSRType: this.headercsrtype,
        CallingSystem: "I",
        PartNo: requestPayload
      };

      // Call Apex
      const result = await validatePartNumber({ payload: JSON.stringify(requestPayloadObj) });
      const resultData = JSON.parse(result).Data.PartNos || [];
      const minBestNetThreshold = this.getMinThreshold();

      let partsUpload = [...partData];
      let hasErrors = false;

      // Process returned parts
      resultData.forEach(item => {
        const matchingPart = partsUpload.find(p => p.Part === item.PartNo);
        if (!matchingPart) return;

        if (item.ErrMsg.length > 0) {
          hasErrors = true;
          let errors = [];

          item.ErrMsg.forEach(err => {
            if (err.ErrDesc) {
              if (err.ErrDesc === 'Invalid Part Number') {
                err.ErrDesc = this.invalidPartNumber;
              }
              errors.push(err.ErrDesc);
            }
          });

          matchingPart.errorMessages = errors;
          matchingPart.className = 'part-List-Color';
        } else {
          let isBestNetAboveThreshold = false;

          if (matchingPart.Channel === 'PDC') {
            isBestNetAboveThreshold = item.Uspdcfnlnt > 0 && item.Uspdcfnlnt >= minBestNetThreshold;
          } else if (matchingPart.Channel === 'DSP') {
            isBestNetAboveThreshold = item.Usdspfnlnt > 0 && item.Usdspfnlnt >= minBestNetThreshold;
          }

          matchingPart.isbestNetGreateThen200 = isBestNetAboveThreshold;
          matchingPart.uspdcfnlnt = item.Uspdcfnlnt;
          matchingPart.usdspfnlnt = item.Usdspfnlnt;

          // clear previous errors
          matchingPart.errorMessages = [];
          matchingPart.className = '';
        }
      });

      this.partsViewData = [...partsUpload];
      this.isShowSpinner = false;

      return !hasErrors;

    } catch (error) {
      this.isShowSpinner = false;
      this.error = error;

      const evt = new ShowToastEvent({
        message: this.label.Edealer_Ops_Failed,
        variant: 'error',
      });
      this.dispatchEvent(evt);

      return false;
    }
  }



}