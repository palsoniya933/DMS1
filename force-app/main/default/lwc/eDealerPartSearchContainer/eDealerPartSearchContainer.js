import { LightningElement, api, wire } from 'lwc';
import getPartListFromAws from '@salesforce/apex/eDealerCsrPartSearchController.getPartListFromAws';
import getPartAltPartDetails from '@salesforce/apex/eDealerCsrPartSearchController.getPartAltPartDetails';
import getPartSearchColumnHeaders from '@salesforce/apex/eDealerCsrPartSearchController.getPartSearchColumnHeaders';
import getAltPartDetailsColumnHeaders from '@salesforce/apex/eDealerCsrPartSearchController.getAltPartDetailsColumnHeaders';
import getUsersCountry from '@salesforce/apex/eDealerCsrPartSearchController.getUsersCountry';
import getWreckCSRMinPrice from '@salesforce/apex/eDealerCsrPartListController.getWreckCSRMinPrice';

import EDealer_Cancel from '@salesforce/label/c.EDealer_Cancel';
import EDealer_Part_Search from '@salesforce/label/c.EDealer_Part_Search';
import EDealer_Part_No from '@salesforce/label/c.EDealer_Part_No';
import EDealer_QTY from '@salesforce/label/c.EDealer_QTY';
import EDealer_Search from '@salesforce/label/c.EDealer_Search';
import EDealer_Select_Part from '@salesforce/label/c.EDealer_Select_Part';
import No_Parts_Found from '@salesforce/label/c.No_Parts_Found';
import EDealer_Back from '@salesforce/label/c.EDealer_Back';
import EDealer_Add_To_Csr from '@salesforce/label/c.EDealer_Add_To_Csr';
import EDealer_No_alternate_part_available from '@salesforce/label/c.EDealer_No_alternate_part_available';
import EDealer_Alternate_Parts from '@salesforce/label/c.EDealer_Alternate_Parts';

export default class EDealerPartSearchContainer extends LightningElement {

  // custom label used for translation and to store messages shown on UI
  label = {
    EDealer_Part_Search,
    EDealer_Part_No,
    EDealer_QTY,
    EDealer_Cancel,
    EDealer_Search,
    EDealer_Select_Part,
    No_Parts_Found,
    EDealer_Back,
    EDealer_Add_To_Csr,
    EDealer_Alternate_Parts,
    EDealer_No_alternate_part_available
  };

  //part search param
  @api dealerCode;
  @api dealerUserName;
  @api division;
  @api csrtype;
  @api headerdealertype;
  //pagination attributes
  @api totalCompetitors;
  @api pageNumber;
  paginationPageSize = 25;
  paginationStartIndex = 0;
  paginationEndIndex = 25;
  disableSearchButton = true;
  showSearchBox = true;

  //PartSearch Attributes/////////////////////////////
  openPartSearchModal = false;
  disbleAddtoCSR = false;
  partNumberValue = "";
  selectedDealer;
  selectedRadioValue = "";
  selectedPartNum;
  showSearchQTYErrorMessage = false;
  showSearchErrorMessage = false;
  showSearchResults = false;
  hasPartDetails = false;
  qty = 1;
  selectedPartRow;
  partSearchData = [];
  partSearchViewData = [];
  dataFound = false;
  noDataFoundMessage = 'No Parts Found';
  selectedAlternatePartData;

  //change the following attribute to mock behavior
  channelOptions = [];
  isLoading = true;
  isAlternatePartLoading = false;
  @api blockquantityfield;
  @api dealerid
  alternatePartsFound = false;
  disableSelectPrimaryPart = true;
  isBestNet = true;
  openAlternativePartSearchModal = false
  disableSelectAlternativePart = true;

  //AlternativePartSearch Attributes/////////////////////////////
  primaryPartData;
  alternatePartData;
  selectedRows = [];
  channelValue = '';
  selectedRowsMap = new Map();
  selectedChannelMap = new Map();
  selectedPartsName = new Set();
  selectedChannelName = [];
  //end of AlternativePartSearch attributes // 
  //used to store channel
  channels = [];
  channelMap = new Map();
  //used to store column header for translation
  columnNameByAPIName = [];
  columnNameByAPINameForAltPart = [];
  // minBestNetThreshold = 200;
  minBestNetThreshold;
  isLoopRunning = false;
  wreckCSRMinPrice;

  @wire(getWreckCSRMinPrice)
  wiredMinPrice({ error, data }) {
    if (data) {
      this.wreckCSRMinPrice = data;
    } else if (error) {
      console.error('Error fetching Wreck CSR Min Price:', error);
    }
  }
  get getDisableSearchButton() {
    return this.disableSearchButton;
  }
  get getdisableSelectAlternativePart() {
    return this.disableSelectAlternativePart;
  }
  get getdisableSelectPrimaryPart() {
    return this.disableSelectPrimaryPart;
  }
  get getLoading() {
    return this.isLoading;
  }
  get getAlternatePartLoading() {
    return this.isAlternatePartLoading;
  }
  get getChannelOption() {
    return this.channelOptions;
  }
  get getDataFound() {
    return this.dataFound;
  }
  connectedCallback() {
    this.setMinThreholdForMXDealer();
    //getting column header
    getPartSearchColumnHeaders({})
      .then((result) => {
        var columns = []
        columns = result;
        this.columnNameByAPIName = [...columns];
      })
      .catch((error) => {

      });
    //getting column header
    getAltPartDetailsColumnHeaders({})
      .then((result) => {
        var columns = []
        columns = result;
        this.columnNameByAPINameForAltPart = [...columns];
      })
      .catch((error) => {

      });
  }

  setMinThreholdForMXDealer() {
    getUsersCountry({})
      .then((result) => {
        if (result && ['mx', 'mex', 'mexico'].includes(result.toLowerCase()) && this.csrtype == 'W') {
          this.minBestNetThreshold = 20;
        }
        else {
          this.minBestNetThreshold = this.wreckCSRMinPrice;
        }
      })
      .catch((error) => {
        console.log('--error--', error?.message | error?.body?.message);
      })
  }
  /////////////////////////////// Part Search ////////////////////////////////////

  /**
   * Handles the close event of the part search modal.
   * Resets the modal and dispatches a custom event to notify the parent component.
   */
  handleClosePartSearchModal() {
    // Reset modal state
    this.openPartSearchModal = false;
    this.showSearchResults = false;
    this.openAlternativePartSearchModal = false;
    this.partNumberValue = "";
    this.qty = 1;

    // Dispatch custom event to notify parent component
    this.dispatchEvent(new CustomEvent('closepartsearchmodal', {
      detail: {
        openPartSearchModal: false
      }
    }));
  }

  /**
 * Handles the search operation.
 * Validates quantity and part number criteria, performs a callout, and updates the search results.
 */
  handleSearch() {
    this.showSearchQTYErrorMessage = !this.qty > 0;
    this.showSearchErrorMessage = this.partNumberValue.length < 3;

    if (this.showSearchQTYErrorMessage || this.showSearchErrorMessage) {
      this.showSearchResults = false;
    } else {
      this.showSearchResults = true;
      this.isLoading = true;

      // Make callout to get part list
      getPartListFromAws({ partNum: this.partNumberValue })
        .then((result) => {
          console.log('resultPartSearch---------' + result);
          let partData = JSON.parse(result);
          let partItems = partData.response.map(item => {
            return {
              part_number: item.itmid,
              decription: item.itmdesc
            };
          });
          this.partSearchData = partItems;
          this.partSearchViewData = this.partSearchData;
          if (this.partSearchViewData.length > 0) {
            this.dataFound = true;
          }
          else {
            this.dataFound = false;
          }
        })
        .catch((error) => {
          this.dataFound = false;
          console.log('error::' + JSON.stringify(error));
        })
        .finally(() => {
          this.isLoading = false;
        });
    }
  }

  /**
 * Handles the change event when the quantity input value is modified.
 * Updates the quantity value and checks conditions to enable/disable the search button.
 * @param {Event} event - The change event from the quantity input.
 */
  handleqtyChange(event) {
    this.qty = event.target.value;

    // Enable the search button only when conditions are met
    this.disableSearchButton = !(this.qty >= 1 && this.qty <= 999 && this.partNumberValue.length >= 3);
  }

  /**
 * Handles the change event when the part number input value is modified.
 * Updates the part number value and checks conditions to enable/disable the search button.
 * @param {Event} event - The change event from the part number input.
 */
  handlePartNumberChange(event) {
    this.partNumberValue = event.target.value;
    // Enable the search button only when conditions are met
    this.disableSearchButton = !(this.partNumberValue.length >= 3 && this.qty > 0 && this.qty < 1000);
  }

  /**
 * Handles the selection event when clicking on a radio button for a part.
 * Updates the selected part number, highlights the selected row, and prepares the data.
 * @param {Event} event - The click event from the radio button.
 */
  handleRadioSelection(event) {
    // Get the clicked index from the radio button's value
    let clickedIndex = event.target.value;

    // Update the selected part number and mark the row as selected
    this.selectedPartNum = this.partSearchViewData[clickedIndex].part_number;
    this.partSearchViewData[clickedIndex].isSelected = true;

    // Get the data from the selected row cells
    const partnumber = this.selectedPartNum;
    const description = this.partSearchViewData[clickedIndex].decription;
    const qty = this.qty;

    // Prepare the selected data object
    const selectedData = {
      "partnumber": partnumber,
      "description": description,
      "qty": qty
    };

    // Update the selected part row and enable selecting the primary part
    this.selectedPartRow = selectedData;
    this.disableSelectPrimaryPart = false;
  }

  /**
 * Handles the change event when selecting a channel option for the primary part.
 * Updates the selected channel and checks for all necessary elements.
 * @param {Event} event - The change event from the channel option checkbox.
 */
  handleChannelOptionChangePrimaryPart(event) {
    // Initialize variables
    let channel = event.target.value;
    this.channelValue = channel;
    // Get the closest 'tr' element, which represents the row
    const row = event.target.closest('tr');
    const channelTd = event.target.closest('td');
    const partnumber = row.cells[1].textContent;
    const checkboxes = channelTd.querySelectorAll('input[type="checkbox"]');
    const mainCheckbox = row.cells[0].querySelector('input[type="checkbox"]');
    let atLeastOneChecked = false;
    let allUnchecked = false;
    if (checkboxes) {
      atLeastOneChecked = Array.from(checkboxes).some(checkbox => checkbox.checked);
      allUnchecked = Array.from(checkboxes).every(checkbox => checkbox.checked == false);
    }

    // Update selected channel names based on the checkbox state
    if (event.target.checked) {
      if (this.selectedChannelMap.has(partnumber)) {
        this.selectedChannelMap.get(partnumber).add(channel);
      }
      else {
        this.selectedChannelMap.set(partnumber, new Set([channel]));
      }
      this.selectedChannelName.push(event.target.name.toString());
    } else {
      if (this.selectedChannelMap.get(partnumber).has(channel)) {
        this.selectedChannelMap.get(partnumber).delete(channel)
      }
      // Remove the channel name if the checkbox is unchecked
      let index = this.selectedChannelName.indexOf(event.target.name.toString());
      if (index !== -1) {
        this.selectedChannelName.splice(index, 1);
      }
    }
    if (atLeastOneChecked && mainCheckbox) {
      mainCheckbox.checked = true;

      mainCheckbox.dispatchEvent(new Event('change', { bubbles: true }));
    }
    if (allUnchecked && mainCheckbox) {
      mainCheckbox.checked = false;

      mainCheckbox.dispatchEvent(new Event('change', { bubbles: true }));
    }

    // Check if all necessary elements exist
    this.checkIfAllElementsExist();
  }
  handleChangeInPageNumber(event) {
    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.partSearchViewData = this.partSearchData.slice(indexes.startIndex, indexes.endIndex);
  }

  /**
 * Handles the selection of a primary part. Initiates the retrieval of alternative parts
 * based on the selected primary part.
 *
 * @param {Event} event - The event object triggered by the primary part selection.
 * @returns {void}
 */
  handlePrimaryPartSelection(event) {
    // Hide search results
    this.showSearchResults = false;

    // Proceed if a primary part is selected
    if (this.selectedPartRow) {
      // Begin loading process
      this.isLoading = true;
      this.showSearchBox = false;
      this.showSearchResults = false;
      this.openPartSearchModal = false;
      this.openAlternativePartSearchModal = true;
      this.partNumberValueAternative = this.selectedPartRow.partnumber.toString();

      // Reset selectedRow Array
      this.selectedRows = [];
      // Retrieve alternative parts for the selected primary part
      getPartAltPartDetails({ dealerId: this.dealerid, dealerSfx: '', partNumber: this.partNumberValueAternative, qty: this.qty })
        .then((result) => {
          // Extract primary part and alternative parts array from the result
          const partsArray = JSON.parse(result).Data.CsrDataD;
          const dataLength = partsArray?.length == 1;
          const primaryPart = partsArray.shift();

          // Configure primary part details
          primaryPart.isTRP = primaryPart.TRPPart === 'Y';

          /** ---------------- PRIMARY PART ---------------- **/
          const pdcThreshold = primaryPart?.USPDCfnlnt >= this.minBestNetThreshold;
          const dspThreshold = primaryPart?.USDSPfnlnt >= this.minBestNetThreshold;
          const pdcNotZero = primaryPart.Pfnlnt !== 0;
          const dspNotZero = primaryPart.Dfnlnt !== 0;

          this.primaryPartData = {
            ...primaryPart,
            channel: this.selectedPartRow.channel,
            quantity: this.qty,
            enableSelection: true,
            isTRP: primaryPart.TRPPart === 'Y',
            isBestNetPdcGreaterThanThreshold: pdcThreshold,
            isBestNetDspGreaterThanThreshold: dspThreshold,
            is_best_net_pdc_not_zero: pdcNotZero,
            is_best_net_dsp_not_zero: dspNotZero,
            is_best_net_greater_200: pdcThreshold || dspThreshold,
            showPdcChannel: this.csrtype === 'W' ? pdcThreshold : pdcNotZero,
            showDspChannel: this.csrtype === 'W' ? dspThreshold : dspNotZero
          };
          const isPrimaryPartDefaultSelected = dataLength == 1 && !(primaryPart.Pfnlnt !== 0 && primaryPart.Dfnlnt !== 0)
          // Configure alternative parts details
          this.alternatePartData = partsArray.map(part => {
            const effectiveChannel = part.PChannel === 'WHS' ? 'PDC' : part.PChannel;

            let isBestNetGreaterThan200 = false;

            if (effectiveChannel === 'PDC') {
              isBestNetGreaterThan200 = part.USPDCfnlnt >= this.minBestNetThreshold;
            } else if (effectiveChannel === 'DSP') {
              isBestNetGreaterThan200 = part.USDSPfnlnt >= this.minBestNetThreshold;
            }
            const isBestNetPdcGreaterThanThreshold =
              part?.USPDCfnlnt >= this.minBestNetThreshold;
            const isBestNetDspGreaterThanThreshold =
              part?.USDSPfnlnt >= this.minBestNetThreshold;

            const is_best_net_pdc_not_zero = part.Pfnlnt !== 0;
            const is_best_net_dsp_not_zero = part.Dfnlnt !== 0;
            const showPdcChannel =this.csrtype === 'W'? isBestNetPdcGreaterThanThreshold: is_best_net_pdc_not_zero;
            const showDspChannel =this.csrtype === 'W'  ? isBestNetDspGreaterThanThreshold  : is_best_net_dsp_not_zero;
            return {
              ...part,
              quantity: this.qty,
              isTRP: part.TRPPart === 'Y',
              PChannel: effectiveChannel,
              showPdcChannel,
              showDspChannel,
              is_best_net_greater_200: isBestNetGreaterThan200,
              isBestNetPdcGreaterThanThreshold: isBestNetPdcGreaterThanThreshold,
              isBestNetDspGreaterThanThreshold: isBestNetDspGreaterThanThreshold
            };
          });
          // Update flags based on alternative parts availability
          this.alternatePartsFound = this.alternatePartData.length > 0;
          if (this.csrtype == 'W') {
            this.alternatePartData = this.filterProductForWrek(this.alternatePartData);
            /*  if (this.primaryPartData.USPDCfnlnt < this.minBestNetThreshold) {
                this.primaryPartData.enableSelection = false;
              }*/
            /* if (this.primaryPartData.is_best_net_pdc_not_zero && this.primaryPartData.USPDCfnlnt <= this.minBestNetThreshold) {
               this.primaryPartData.enableSelection = false;
             }
             else if (this.primaryPartData.is_best_net_dsp_not_zero && this.primaryPartData.USDSPfnlnt <= this.minBestNetThreshold) {
               this.primaryPartData.enableSelection = false;
             }*/
            if ((this.primaryPartData.is_best_net_pdc_not_zero || this.primaryPartData.is_best_net_dsp_not_zero) && !this.primaryPartData.is_best_net_greater_200) {
              this.primaryPartData.enableSelection = false;
            }
            let altParts = this.alternatePartData;
            altParts.forEach(part => {
              if (part.Pfnlnt !== 0)
                part.is_best_net_pdc_not_zero = true;
              if (part.Dfnlnt !== 0)
                part.is_best_net_dsp_not_zero = true;
            });
            this.alternatePartData = altParts;
          }
          else {
            this.alternatePartData = this.mapAlternatePartData(this.alternatePartData);
          }
          if (isPrimaryPartDefaultSelected) {

            setTimeout(() => {
              const checkbox = this.template.querySelector('[name="primary"]');
              if (checkbox) {
                checkbox.checked = true;
                checkbox.dispatchEvent(new Event('change', { bubbles: true }));
              }
            }, 0)
          }
        })
        .catch((error) => {
          console.error('Error:', error);
        })
        .finally(() => {
          // End loading process
          this.isLoading = false;
        });
    } else {
      // Log if no parts were selected
      console.log('No parts were selected');
    }
  }

  /////////////////////////////// Alternative Part Search ////////////////////////////////////

  handleCloseAlternativePartSearchModal() {

    this.selectedRowsMap = new Map();
    this.selectedChannelMap = new Map();
    this.selectedPartsName = new Set();
    this.selectedChannelName = [];
    this.selectedRows = [];
    this.showSearchBox = true;
    this.openPartSearchModal = true;
    this.openAlternativePartSearchModal = false;
    this.showSearchResults = true;
    this.isLoading = false;
    this.partSearchViewData = this.mapPartSearchViewData(this.partSearchViewData);
    this.alternatePartData = "";
  }

  /**
 * Handles the checkbox selection for parts.
 * Updates the selected parts and modifies the selected rows accordingly.
 *
 * @param {Event} event - The event triggered by the checkbox selection.
 */
  handleCheckboxSelection(event) {
    // Check if the clicked element is a checkbox
    if (event.target.type !== 'checkbox') {
      return;
    }

    // Get the closest 'tr' element, which represents the row
    const row = event.target.closest('tr');
    const index = event.target.dataset.index;
    const name = event.target.name;
    const channelString = row.cells[3].textContent.trim();

    const channelList = channelString.split(' ');
    const channelCheckbox = row.cells[3].querySelectorAll('[type="checkbox"]');

    // Get the data from the row cells
    const partnumber = row.cells[1].textContent;
    const description = row.cells[2].textContent;
    const qty = this.qty;
    let isbestNetGreateThen200 = false;
    let uspdcfnlnt = null;
    let usdspfnlnt = null;
    if (name === 'primary') {

      //  reason setting to true as if it is less then 0 then check box will not be displayed.
      isbestNetGreateThen200 = this.primaryPartData.is_best_net_greater_200;
      uspdcfnlnt = this.primaryPartData?.USPDCfnlnt;
      usdspfnlnt = this.primaryPartData?.USDSPfnlnt;
    }
    else {
      isbestNetGreateThen200 = this.alternatePartData[index].is_best_net_greater_200;
      uspdcfnlnt = this.alternatePartData[index]?.USPDCfnlnt;
      usdspfnlnt = this.alternatePartData[index]?.USDSPfnlnt;
    }

    const selectedData = {
      partnumber,
      description,
      qty,
      uspdcfnlnt,
      usdspfnlnt
    };
    const channels = channelList.map((channel) => {
      return { "label": channel, "value": channel }
    });
    selectedData.channels = channels;
    selectedData.isbestNetGreateThen200 = isbestNetGreateThen200;
    // Change to Map so when dist is changed, it doesn't create another line
    if (event.target.checked) {
      this.selectedRowsMap.set(selectedData.partnumber, selectedData);
      this.selectedPartsName.add(event.target.name.toString());

      if (channelCheckbox && channelCheckbox.length == 1) {
        if (!channelCheckbox[0].checked) {
          channelCheckbox[0].checked = true;
          channelCheckbox[0].dispatchEvent(new Event('change', { bubbles: true }));
        }
      }
    } else {
      this.selectedPartsName.delete(event.target.name.toString());
      this.selectedRowsMap.delete(selectedData.partnumber);

      if (channelCheckbox) {
        if (!this.isLoopRunning) {
          this.isLoopRunning = true;
          for (const checkbox of channelCheckbox) {
            if (checkbox.checked) {
              checkbox.checked = false;
              checkbox.dispatchEvent(new Event('change', { bubbles: true }));
            }
          }
          this.isLoopRunning = false;
        }
      }
    }
    this.checkIfAllElementsExist();
    this.disbleAddtoCSR = this.selectedRows.length === 0;

  }

  /**
  * Handles the change in channel option for alternate parts.
  * Updates the selected channel names and modifies the selected rows accordingly.
  *
  * @param {Event} event - The event triggered by the channel option change.
  */
  handleChannelOptionChangeAlternatePart(event) {
    const channel = event.target.value;
    const name = event.target.name.toString();
    const row = event.target.closest('tr');
    const channelTd = event.target.closest('td');
    const checkboxes = channelTd.querySelectorAll('input[type="checkbox"]');
    const mainCheckbox = row.cells[0].querySelector('input[type="checkbox"]');

    let allChecked = false;
    let allUnchecked = false;
    if (checkboxes) {
      allChecked = Array.from(checkboxes).every(checkbox => checkbox.checked);
      allUnchecked = Array.from(checkboxes).every(checkbox => checkbox.checked == false);
    }

    // Get the data from the row cells
    const partnumber = row.cells[1].textContent;
    if (event.target.checked) {
      if (this.selectedChannelMap.has(partnumber)) {
        this.selectedChannelMap.get(partnumber).add(channel);
      }
      else {
        this.selectedChannelMap.set(partnumber, new Set([channel]));
      }
      this.selectedChannelName.push(name);
    }
    else {
      if (this.selectedChannelMap.get(partnumber).has(channel)) {
        this.selectedChannelMap.get(partnumber).delete(channel)
      }
      const index = this.selectedChannelName.indexOf(name);
      if (index !== -1) {
        this.selectedChannelName.splice(index, 1);
      }
    }
    if (allChecked && mainCheckbox) {
      mainCheckbox.checked = true;
      mainCheckbox.dispatchEvent(new Event('click', { bubbles: true }));
    }
    if (allUnchecked && mainCheckbox) {
      mainCheckbox.checked = false;
      mainCheckbox.dispatchEvent(new Event('click', { bubbles: true }));
    }
    this.checkIfAllElementsExist();
  }

  /**
 * Handles the event when parts are added to the CSR.
 * Closes the alternative part search modal, hides search results, and resets input values.
 * Dispatches custom events to notify parent components about the added parts and to close the modal.
 *
 * @param {CustomEvent} event - The custom event triggering the method.
 */
  handleAddToCSR(event) {
    // Check if parts are selected
    this.selectedRows = [];
    for (const partNumber of this.selectedChannelMap.keys()) {
      let channels = [];
      let selectedRow = this.selectedRowsMap.get(partNumber);
      for (let channel of Array.from(this.selectedChannelMap.get(partNumber))) {
        this.selectedRows.push({ ...selectedRow, 'channel': channel });
      }
      channels = [];
    }

    if (this.selectedRows.length > 0) {
      // Dispatch custom events to notify parent components
      this.dispatchEvent(new CustomEvent('addparts', { detail: { selectedRows: this.selectedRows } }));
      this.dispatchEvent(new CustomEvent('closepartsearchmodal', { detail: { openPartSearchModal: false } }));
    } else {
      // Log a message if no parts were selected
      console.log('No parts were selected');
    }

    // Reset input values
    this.partNumberValue = "";
    //this.qty = 1;

    // Close the alternative part search modal and hide search results
    this.openAlternativePartSearchModal = this.showSearchResults = false;
  }

  setPaginationValues() {
    this.pageNumber = 1;
    this.paginationStartIndex = 0;
    this.paginationEndIndex = 0 + this.paginationPageSize;
  }
  /**
   * Handles the event when numberor shown records change occurs in pagination.
   * Updates 'partSearchViewData' based on the provided indexes.
   * @param {CustomEvent} event - The custom event with index details
   */
  handleTotalRecordChange(event) {
    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.partSearchViewData = this.partSearchData.slice(indexes.startIndex, indexes.endIndex);
    this.totalCompetitors = this.partSearchData.length;
    this.dataFound = this.totalCompetitors !== 0;

  }

  /**
   * Handles the event when the next button is clicked in pagination.
   * Updates 'partSearchViewData' based on the provided indexes.
   * @param {CustomEvent} event - The custom event with index details
   */
  handleNextButton(event) {
    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.partSearchViewData = this.partSearchData.slice(indexes.startIndex, indexes.endIndex);
    this.totalCompetitors = this.partSearchData.length;
    this.dataFound = this.totalCompetitors !== 0;
    this.partSearchViewData = this.mapPartSearchViewData(this.partSearchViewData);
  }

  /**
   * Handles the event when the previous button is clicked in pagination.
   * Updates 'partSearchViewData' based on the provided indexes.
   * @param {CustomEvent} event - The custom event with index details
   */
  handlePrevButton(event) {
    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.partSearchViewData = this.partSearchData.slice(indexes.startIndex, indexes.endIndex);
    this.totalCompetitors = this.partSearchData.length;
    this.partSearchViewData = this.mapPartSearchViewData(this.partSearchViewData);
  }

  /**
   * Sets pagination start and end indexes based on the provided indexes.
   * @param {Object} indexes - The object containing start and end indexes
   */
  setPaginationIndexes(indexes) {
    this.paginationStartIndex = indexes.startIndex;
    this.paginationEndIndex = indexes.endIndex;
  }

  /**
   * Handles the event when the page number is changed in pagination.
   * Updates 'paginationPageSize'.
   * @param {CustomEvent} event - The custom event with page size details
   */
  handlePageNumberChange(event) {
    this.paginationPageSize = event.detail.pagesize;
    this.partSearchViewData = this.mapPartSearchViewData(this.partSearchViewData);
  }

  /**
 * Maps and enhances the view data for part search results.
 *
 * @param {Array} results - The array of part search results to be transformed.
 * @returns {Array} - An array of transformed results with added properties.
 */
  mapPartSearchViewData(results) {
    return results.map(result => ({
      ...result,
      isSelected: result.part_number === this.selectedPartNum,
      best_net_whs: this.generateRandomPrice(),
      best_net_dsp: this.generateRandomPrice()
    }));
  }

  /**
 * Maps and enhances the data for alternative parts.
 * Adds boolean properties to indicate if the 'best_net_pdc' and 'best_net_dsp' are zero.
 * @param {Object[]} results - The array of alternative part data to be mapped.
 * @returns {Object[]} - The mapped array with additional properties.
 */
  mapAlternatePartData(results) {
    return results.map(result => ({
      ...result,
      is_best_net_pdc_not_zero: result.Pfnlnt !== 0,
      is_best_net_dsp_not_zero: result.Dfnlnt !== 0,
      isPdcChecked: false,
      isDspChecked: false
    }));
  }

  generateRandomPrice() {
    // Generate a random price between 1 and 1000 (inclusive)
    var randomPrice = (Math.random() * 900).toFixed(2);
    return "$" + randomPrice;
  }

  /**
 * Checks if all necessary elements exist for selecting alternative parts.
 * If selected parts and channels are empty, disables the alternative part selection.
 * @private
 */
  checkIfAllElementsExist() {
    // Initialize sets for selected parts and channels
    const selectedPartsSet = new Set(this.selectedPartsName);
    const selectedChannelSet = new Set(this.selectedChannelName);

    // If both sets are empty, disable alternative part selection
    if (selectedPartsSet.size === 0 && selectedChannelSet.size === 0) {
      this.disableSelectAlternativePart = true;
      return;
    }

    // Check if all selected parts exist in the selected channels
    const isExistInSelectedParts = [...selectedPartsSet].every(element => selectedChannelSet.has(element));

    // Check if all selected channels exist in the selected parts
    const isExistInSelectedChannels = [...selectedChannelSet].every(element => selectedPartsSet.has(element));

    // Disable alternative part selection if any of the conditions are not met
    this.disableSelectAlternativePart = !(isExistInSelectedParts && isExistInSelectedChannels);
  }

  filterProductForWrek(results) {
    var filteredProduct = results.filter((el) => {
      return el.USPDCfnlnt >= this.minBestNetThreshold;
    });
    return filteredProduct
  }
}