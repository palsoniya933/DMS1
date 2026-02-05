import { LightningElement, api,wire } from 'lwc';
import getCompetitorsFromAws from '@salesforce/apex/eDealerChooseCompetitorController.getCompetitorsFromAws';
import getCompetitorsColumnHeader from '@salesforce/apex/eDealerChooseCompetitorController.getCompetitorsColumnHeader';
import EDealer_Select_Competitor from '@salesforce/label/c.EDealer_Select_Competitor';
import fetchLoggedInUserdetails from '@salesforce/apex/eDealerChooseCompetitorController.fetchLoggedInUserdetails';
import EDealer_PART from '@salesforce/label/c.Edealer_Part';
import EDealer_Part_Description from '@salesforce/label/c.Edealer_PART_DESCRIPTION';
import EDealer_Cancel from '@salesforce/label/c.EDealer_Cancel';
export default class EdealerChooseCompetitor extends LightningElement {

    label = {
        EDealer_Select_Competitor,
        EDealer_Cancel,
        EDealer_PART,
        EDealer_Part_Description
    };

    // Competitor data to show in the competitor list table
    @api competitors = [];
    @api totalCompetitors;
    @api pageNumber;
  showField = true;
    // Filter attributes to show in competitor table filter
    @api typeOptions; // Options for the 'Type' filter
    @api affiliationOptions; // Options for the 'Affiliation' filter
    @api stateOptions; // Options for the 'State' filter
    @api confirmationOptions; // Options for the 'Confirmation' filter
    @api competitorsViewData;
    @api totalRecordCount;
   @api selectedCompetitorData={};
    // Attribute for part detail to show on top of the competitor table
    @api selectedPart;
    message = 'No Data Found!';
    columnNameByAPIName = [];
    // Search filters
    searchedCompetitor;
    searchedAffiliation;
    searchedCity;
    searchedPostalCode;
    searchedType;
    searchedState;
     
   
    searchedConfirmed;
     isAddCompititorDisable = true;
    // Pagination attributes
    paginationPageSize = 25;
    paginationStartIndex = 0;
    paginationEndIndex = 25;
    selectedRowData;
    selectedViewRowData = {
        Affiliation: []
    };
    @api selectedCompId;
    @api dealerCode;
    isLoading = true;
     loggedInUser;
    connectedCallback() {
        // Fetch competitors from AWS when the component is connected to the DOM
        this.fetchCompetitors();
         
        //getting column header
        getCompetitorsColumnHeader()
            .then((result) => {
                var columns = []
                columns = result;
                this.columnNameByAPIName = [...columns];
                console.log('this.columnNameByAPIName---'+JSON.stringify(this.columnNameByAPIName));
            })
            .catch((error) => {

            });
            
    }
    /**
    * Fetches competitors from AWS using the provided Apex method.
    * Maps the results and sets up filter options.
    */
    fetchCompetitors() {
        try {
            getCompetitorsFromAws({ dealerCode: this.dealerCode })
                .then((results) => {
                    
                    if (results != 'No Data Found!!') {
                        let response = JSON.parse(results);
                        console.log('----response---'+JSON.stringify(response));
                        if (response.length > 0 && !response[0].ErrorDescription) {
                            this.competitors = this.mapCompetitors(response);
                            this.competitorsViewData = this.competitors.slice(this.paginationStartIndex, this.paginationEndIndex);
                            this.setupFilterOptions();
                        }
                        else {
                            this.dataFound = true;
                        }
                    }
                    else {
                        this.dataFound = true;
                    }
                })
                .catch((error) => {
                    console.error(error.message)
                })
                .finally(() => {
                    this.isLoading = !this.isLoading;
                });
        } catch (error) {
            console.error(error.message);
        }
    }

    getCompetitorsFromAws() {

    }

    /**
     * Maps the competitors with an additional 'isSelected' property.
     * @param {Array} results - Competitors data from AWS
     * @returns {Array} - Mapped competitors data
     */
    mapCompetitors(results) {
        return results.map(result => ({
            ...result,
            isSelected: result.CompetitorName == this.selectedCompId
        }));
    }

    /**
     * Sets up filter options like 'Type', 'Affiliation', 'State', 'Confirmation'.
     */
    setupFilterOptions() {
        this.typeOptions = this.extractUniqueValuesForFilter('CompType');
        this.sortFilterOptions(this.typeOptions);
        this.typeOptions.unshift({ label: 'None', value: '' });
        this.affiliationOptions = this.extractUniqueValuesForFilter('Affiliation');
        this.affiliationOptions.unshift({ label: 'None', value: '' });
        this.stateOptions = this.extractUniqueValuesForFilter('CompState');
        this.sortFilterOptions(this.stateOptions);
        this.stateOptions.unshift({ label: 'None', value: '' });
        this.confirmationOptions = this.extractUniqueValuesForFilter('Confirmation');
        this.sortFilterOptions(this.confirmationOptions);
        this.confirmationOptions.unshift({ label: 'None', value: '' });
    }

    /**
     * Gets the part number from the selected part.
     * @returns {String} - Part number
     */
    get getPartNumber() {
        return this.selectedPart.Part;
    }

    /**
     * Gets the part description from the selected part.
     * @returns {String} - Part description
     */
    get getpartDescription() {
        return this.selectedPart.PartDescription;
    }

    /**
     * Handles the change event when a radio is selected in the competitor table.
     * Updates the 'selectedRowData' property.
     * @param {Event} event - The change event
     */
    handleSelectedRowChange(event) {
      
        try {
            
            
            let clickedIndex = event.target.value;
            console.log('clickedIndex---'+clickedIndex);
            this.selectedRowData = this.competitorsViewData[clickedIndex];
            console.log(' this.selectedRowData----'+this.selectedRowData);
            this.selectedRowData.tab = 'chooseCompetitor';
            
            this.selectedViewRowData.Affiliation[0] = this.selectedRowData.Affiliation;
            this.selectedViewRowData.Confirmation = this.selectedRowData.Confirmation;
            this.selectedViewRowData.CompType = this.selectedRowData.CompType;
            this.selectedViewRowData.CompState = this.selectedRowData.CompState;
            this.selectedViewRowData.CompPostal = this.selectedRowData.CompPostal;
            this.selectedViewRowData.CompetitorName = this.selectedRowData.CompetitorName;
            this.selectedViewRowData.CompCity = this.selectedRowData.CompCity;
            this.selectedViewRowData.CompetitorCode = this.selectedRowData.CompetitorCode;
            this.selectedViewRowData.CompetitorCode = this.selectedRowData.CompetitorCode;
            this.selectedViewRowData.CompetitorCode = this.selectedRowData.CompetitorCode;
            this.selectedCompId = this.selectedRowData.CompetitorName;
            
            
        } catch (error) {
            console.log('error=>', error.message);
        }
    }

    

    /**
     * Dispatches an event with the selected competitor data when the "Add Competitor" button is clicked.
     */
    handleSelectCompetitor() {
        this.dispatchEvent(new CustomEvent('selectedcompetitor', {
            detail: {
                selectedCompetitorData: this.selectedViewRowData
            }
        }));
        console.log('--selectedCompetitorData---'+this.selectedViewRowData);
    }

    /**
     * Dispatches an event to close the competitor modal.
     * @param {Event} evt - The event object
     */
    handleCloseCompetitorModal(evt) {
        this.dispatchEvent(new CustomEvent('cancelmodal', {
            detail: {
                openCompetitorModal: false
            }
        }));
    }

    /**
     * Handles the change event when the 'Affiliation' filter value is changed.
     * Updates the 'searchedAffiliation' property and triggers filtering.
     * @param {Event} event - The change event
     */
    handleAffiliationValueChange(event) {
        this.searchedAffiliation = event.detail.value;
        this.prepareViewDataOnFiltersChange();
    }

    /**
     * Handles the change event when the 'Type' filter value is changed.
     * Updates the 'searchedType' property and triggers filtering.
     * @param {Event} event - The change event
     */
    handleTypeValueChange(event) {
        this.searchedType = event.detail.value;
        this.prepareViewDataOnFiltersChange();
    }

    /**
     * Handles the change event when the 'State' filter value is changed.
     * Updates the 'searchedState' property and triggers filtering.
     * @param {Event} event - The change event
     */
    handleStateChange(event) {
        this.searchedState = event.detail.value;
        this.prepareViewDataOnFiltersChange();
    }

    /**
     * Handles the change event when the 'Confirmation' filter value is changed.
     * Updates the 'searchedConfirmed' property and triggers filtering.
     * @param {Event} event - The change event
     */
    handleConfirmationChange(event) {
        this.searchedConfirmed = event.detail.value;
        this.prepareViewDataOnFiltersChange();
    }

    /**
     * Handles the change event when the competitor input is changed.
     * Updates the 'searchedCompetitor' property and triggers filtering.
     * @param {Event} event - The change event
     */
    handleCompetitorChange(event) {
        this.searchedCompetitor = event.target.value.toUpperCase();
        this.prepareViewDataOnFiltersChange();
    }

    /**
     * Handles the change event when the city input is changed.
     * Updates the 'searchedCity' property and triggers filtering.
     * @param {Event} event - The change event
     */
    handleCityChange(event) {
        this.searchedCity = event.target.value.toUpperCase();
        this.prepareViewDataOnFiltersChange();
    }

    /**
     * Handles the change event when the postal code input is changed.
     * Updates the 'searchedPostalCode' property and triggers filtering.
     * @param {Event} event - The change event
     */
    handlePostalCodeChange(event) {
        this.searchedPostalCode = event.target.value;
        this.prepareViewDataOnFiltersChange();
    }

    prepareViewDataOnFiltersChange() {
        this.setPaginationValues();
        this.filterCompetitorsData();
        this.competitorsViewData = this.mapCompetitors(this.competitorsViewData);
    }

    setPaginationValues() {
        this.pageNumber = 1;
        this.paginationStartIndex = 0;
        this.paginationEndIndex = 0 + this.paginationPageSize;
    }
    

    /**
     * Filters the competitor data based on various criteria like affiliation, type, etc.
     * Updates the 'competitorsViewData' and handles current pagination data.
     */
    filterCompetitorsData() {

        let currentData = this.competitors;
        this.competitorsViewData = currentData.filter(item => {
            // Apply filters based on combobox values
            const affiliationFilter = !this.searchedAffiliation || item.Affiliation == this.searchedAffiliation;
            const typeFilter = !this.searchedType || item.CompType === this.searchedType;
            const stateFilter = !this.searchedState || item.CompState === this.searchedState;
            const confirmationFilter = !this.searchedConfirmed || item.Confirmation === this.searchedConfirmed;

            // Apply filters based on input box values
            const competitorFilter = !this.searchedCompetitor || item.CompetitorName.toUpperCase().includes(this.searchedCompetitor.toUpperCase());
            const cityFilter = !this.searchedCity || item.CompCity.toUpperCase().includes(this.searchedCity.toUpperCase());
            const postalCodeFilter = !this.searchedPostalCode || item.CompPostal.includes(this.searchedPostalCode);

            return affiliationFilter && typeFilter && stateFilter && confirmationFilter && competitorFilter && cityFilter && postalCodeFilter;
        });

        this.totalCompetitors = this.competitorsViewData.length;
        this.dataFound = this.totalCompetitors === 0;

        this.competitorsViewData = this.competitorsViewData.slice(this.paginationStartIndex, this.paginationEndIndex);
    }

    /**
     * Extracts unique values for filter options like 'Type', 'Affiliation', etc.
     * @param {String} property - Property for which unique values need to be extracted
     * @returns {Array} - Unique values with label and value
     */
    extractUniqueValuesForFilter(property) {
        const uniqueValues = [...new Set(
            this.competitors
                .filter(item => item[property] !== '')
                .map(item => {
                    const value = typeof item[property] === 'number' ? item[property].toString() : item[property];
                    return value;
                })
        )];
        return uniqueValues.map(value => ({ label: value, value }));
    }

    /**
     * Handles the event when number shown records change occurs in pagination.
     * Updates 'competitorsViewData' based on the provided indexes.
     * @param {CustomEvent} event - The custom event with index details
     */
    handleTotalRecordChange(event) {
        this.prepareViewDataForSelectedEvent(event);
    }

    /**
     * Handles the event when the next button is clicked in pagination.
     * Updates 'competitorsViewData' based on the provided indexes.
     * @param {CustomEvent} event - The custom event with index details
     */
    handleNextButton(event) {
        this.prepareViewDataForSelectedEvent(event);
    }
 handleChangeInPageNumber(event) {
    let indexes = event.detail;
    this.setPaginationIndexes(indexes);
    this.competitorsViewData = this.competitors.slice(indexes.startIndex, indexes.endIndex);
  }
    /**
     * Handles the event when the previous button is clicked in pagination.
     * Updates 'competitorsViewData' based on the provided indexes.
     * @param {CustomEvent} event - The custom event with index details
     */
    handlePrevButton(event) {
        this.prepareViewDataForSelectedEvent(event);
    }

    prepareViewDataForSelectedEvent(event) {
        let indexes = event.detail;
        this.setPaginationIndexes(indexes);
        this.competitorsViewData = this.competitors.slice(indexes.startIndex, indexes.endIndex);
        this.filterCompetitorsData();
        this.competitorsViewData = this.mapCompetitors(this.competitorsViewData);
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
    }

    @wire(fetchLoggedInUserdetails)
    wiredUser({ error, data }) {
        if (data) {
            this.loggedInUser = data;
            
            this.handleFieldVisibility();
        } else if (error) {
            // Handle error
        }
    }
    handleFieldVisibility() {
        // Check if the user is enabled for the portal
        if (this.loggedInUser.IsPortalEnabled==true) {
            this.showField = false;
        }
    }

    sortFilterOptions(filterOptions) {
        filterOptions.sort((a, b) => {
            let labelA = a.label.toUpperCase(); // ignore upper and lowercase
            let labelB = b.label.toUpperCase(); // ignore upper and lowercase
            if (labelA < labelB) {
                return -1;
            }
            if (labelA > labelB) {
                return 1;
            }
            // labels must be equal
            return 0;
        });
    }
}