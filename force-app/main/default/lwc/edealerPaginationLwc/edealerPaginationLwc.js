import { LightningElement, api, track } from 'lwc';  
import Page_Size from '@salesforce/label/c.Page_Size';
import Pagination_Records from '@salesforce/label/c.Pagination_Records';
import Pagination_Prev from '@salesforce/label/c.Pagination_Prev';
import pagination_Next from '@salesforce/label/c.pagination_Next';
import Pagination_Of from '@salesforce/label/c.Pagination_Of';
export default class EdealerPaginationLwc extends LightningElement {

    label = {
        Pagination_Records,
        Page_Size,
        pagination_Next,
        Pagination_Prev,
        Pagination_Of
    }
    @api pagesizes = [];
    @api disabledprevious = false;
    @api disablednext = false;
    @api totalRecords = [];
    @api recordStart = 1;
    @api recordEnd;
    @api pageNumber = 1;
    @api totalPages;
    @api pageSize;
    @api displayPageButtons = false;
    @api viewRecord = 25;
    @api totalCompetitors;
    @api totalRecordCount;
    recordEnd;

    connectedCallback() {
        // Initialize page number to 1 when component is connected to the DOM
        this.pageNumber = 1;
    }

    //getter for number of records to be shown on per page
    get viewRecordOptions() {
        return [
            { label: 1, value: 1 },
            { label: 25, value: 25 },
            { label: 50, value: 50 },
            { label: 100, value: 100 }]
    }

    //getter for current page selection picklist
    get pageNumbers() {
        // Calculate total pages and set record end based on total competitors or total records
        // Dispatch 'handlepagenumberchange' event with the current page size
        // Return an array of page options for the picklist
        let totalRecords = 0
        if (this.totalCompetitors) {
            this.totalPages = Math.ceil(this.totalCompetitors / this.pageSize);
            this.recordEnd = this.totalCompetitors;
            totalRecords = this.totalCompetitors;
        }
        else {
            this.totalPages = Math.ceil(this.totalRecords.length / this.pageSize);
            this.recordEnd = this.totalRecords.length;
        }
        let pagesArray = Array.from({ length: this.totalPages }, (value, index) => index + 1);
        let pagesOption = pagesArray.map(item => ({
            label: item,
            value: item
        }));
        if(!(this.recordEnd == 2)){
            this.dispatchEvent(new CustomEvent('handlepagenumberchange', {
                detail: {
                    pagesize: this.pageSize,
                    pagenumber : this.pageNumber
                }
            }));
        }
        return pagesOption;
    }

    // Getter for the starting record index on the current page
    get getRecordStart() {
        // Calculate and return the starting record based on page number, page size, and total records
        var pageSize = this.pageSize;
        if (this.totalRecords.length === 1) {
            pageSize = 1;
        }
        else if (pageSize > this.totalRecords.length) {
            pageSize = this.totalRecords.length;
        }
        var totalPages = Math.trunc(this.totalRecords.length / pageSize);
        var remainder = this.totalRecords.length % pageSize;
        if (remainder > 0) {
            totalPages += 1;
        }

        // if there is only 1 page
        if (totalPages == 0 || totalPages == 1) {
            totalPages = 1;
        }
        this.totalPages = totalPages;
        if (this.pageNumber == 1) {
            this.recordEnd = this.pageSize;
            return 1;
        }
        else {
            return (parseInt(this.pageNumber) - 1) * parseInt(this.pageSize) + 1;
        }
    }

    // Getter for the ending record index on the current page
    get getRecordEnd() {
        // Calculate and return the ending record based on page number, page size, and total competitors or total records
        let endRecord = Math.max(1, (this.pageNumber) * this.pageSize);
        let competitors;
        if (!this.totalCompetitors) {
            competitors = this.totalRecords.length;
        }
        else {
            competitors = this.totalCompetitors;
        }
        if (endRecord > competitors) {
            endRecord = competitors;
        }
        return endRecord;
    }

    // Getter for the total record count
    get getTotalRecordCount() {
        // Return the total number of competitors or total records based on availability
        if (!this.totalCompetitors) {
            return this.totalRecords.length;
        } else {
            return this.totalCompetitors;
        }
    }

    // Getter for determining if the "Previous" button should be disabled
    get getDisabledPrevious() {
        // Return true if on the first page, otherwise return false
        if (this.pageNumber == 1) {
            return true;
        }
        else {
            return false;
        }
    }

    // Getter for determining if the "Next" button should be disabled
    get getDisabledNext() {
        // Return true if on the last page or if page size exceeds total records or total competitors, otherwise return false
        if (this.pageNumber == this.totalPages
            || this.pageSize > this.totalRecords.length
            || this.pageSize > this.totalCompetitors) {
            return true;
        }
        else {
            return false;
        }
    }

    // Handle the "Next" button click event
    handleNext() {
        // Increment the page number and calculate the new record start index
        // Dispatch 'handlenext' event with start and end index details       
        this.pageNumber = parseInt(this.pageNumber) + 1;
        var pageSize = this.pageSize;
        //start index calc
        this.recordStart = (this.pageNumber - 1) * pageSize + 1;
        let endIndex = (parseInt(this.recordStart) - 1) + parseInt(pageSize);
        let startIndex = parseInt(this.recordStart) - 1;
        if (endIndex > this.totalRecords.length) {
            endIndex = this.totalRecords.length;
        }
        this.dispatchEvent(new CustomEvent('handlenext', {
            detail: {
                startIndex: startIndex,
                endIndex: endIndex
            }
        }));

    }

    // Handle the "Previous" button click event
    handlePrev() {
        // Decrement the page number and calculate the new start and end index
        // Dispatch 'handleprev' event with start and end index details
        this.pageNumber = parseInt(this.pageNumber) - 1;
        var pageNumber = this.pageNumber + 1;
        var pageSize = this.pageSize;
        let startIndex = (pageNumber - 2) * pageSize;
        let endIndex = (pageNumber - 1) * pageSize;
        if (this.pageNumber == this.totalPages) {
            this.disablednext = true;
        }
        this.dispatchEvent(new CustomEvent('handleprev', {
            detail: {
                startIndex: startIndex,
                endIndex: endIndex
            }
        }));
    }

    // Handle the change in selected page number from the picklist
    handlePageNumChange(event) {
        // Update the page number and calculate the new start and end index
        // Dispatch 'totalrecordchange' event with start and end index details
        var pageNumber = event.detail.value;
        this.pageNumber = pageNumber;
        var pageSize = this.pageSize;

        // start index calc
        var startindex = (pageNumber - 1) * pageSize;
        if (startindex < 0) {
            startindex = 0;
        }
        var endIndex = startindex + parseInt(pageSize);

        // getting total data
        var allRecs = this.totalRecords;
        if (endIndex > allRecs.length) {
            endIndex = allRecs.length;
        }
        this.recordStart = (pageSize * (pageNumber - 1)) + 1;
        this.dispatchEvent(new CustomEvent('pagenumberchange', {
            detail: {
                'startIndex': startindex,
                'endIndex': endIndex
            }
        }));
    }

    // Handle the change in total records per page from the picklist
    handleTotalRecordsChange(event) {
        // Reset page number, update page size, and calculate new start and end index
        // Dispatch 'totalrecordchange' event with start and end index details
        this.pageNumber = 1;
        this.pageSize = event.detail.value;
        this.recordStart = 1;
        let endIndex = 0 + parseInt(this.pageSize);
        if (endIndex > this.totalRecords.length) {
            endIndex = this.totalRecords.length;
        }
        this.dispatchEvent(new CustomEvent('totalrecordchange', {
            detail: {
                'startIndex': 0,
                'endIndex': endIndex
            }
        }));
    }

}