import { LightningElement, wire, api } from 'lwc';
import { executeQuery, getDataset } from 'lightning/analyticsWaveApi';

export default class GetCRMAReportData extends LightningElement {
    @api setName;
    datasetId;
    datasetVersionId;
    query;
    crmaData;
    datasetName;
    @api loc;
    @api filter;
    @api filterValue;
    @api operator;
    @api columns
    @api sortColumn;
    @api staticFilters;
    @api sortMap;


    generateReport() {
        this.query = this.buildQuery();
    }
    connectedCallback() {
        this.datasetName = this.setName;
    }
    get computedQuery() {
        if (this.datasetId && this.datasetVersionId) {
            this.query = this.buildQuery();
        }
        if (!this.query) {
            return undefined;
        }
        return {
            query: this.query,
        };
    }

    @wire(getDataset, {
        datasetIdOrApiName: '$datasetName',
    })
    onGetDataset({ data, error }) {
        if (error) {
            console.log('ERROR:', error);
        } else if (data) {
            this.datasetId = data.id;
            this.datasetVersionId = data.currentVersionId;
        }
    }

    @wire(executeQuery, {
        query: '$computedQuery',
    })
    onExecuteQuery({ data, error }) {
        if (error) {
            this.showSpinner = false;
        } else if (data) {
            const records = data?.results?.records || [];
            this.crmaData = records.map(record => {
                // Reorder the record fields to match the sequence in 'columns'
                let orderedRecord = {};
                this.columns.forEach(column => {
                    //orderedRecord[column.fieldName] = record[column.fieldName.toUpperCase()];
                    let fieldKey = column.fieldName.toUpperCase();
                    orderedRecord[column.fieldName] = fieldKey in record ? record[fieldKey] : ""; // Ensure missing fields exist
                });
                return orderedRecord;
            });



            // Dispatching event to parent with the ordered data
            const sendDataEvent = new CustomEvent('senddata', {
                detail: { dataToSend: JSON.stringify(this.crmaData), selectmenu: 'crmaDataListing' }
            });
            console.log("--- checking dealer in crma data ---" + JSON.stringify(this.crmaData));
            this.dispatchEvent(sendDataEvent);
        }
    }

    buildQuery() {
        let query = '';
        query += 'q = load "' + this.datasetId + '/' + this.datasetVersionId + '";\n';

        if (this.loc.length > 0) {
            query += `q = filter q by 'LOC' in [${this.loc.map(loc => `"${loc}"`).join(", ")}];\n`;
        }
        if (this.staticFilters) {
            const filters = this.staticFilters.split('AND');
            filters.forEach(filter => {
                query += `q = filter q by ${filter.trim()};\n`;
            });
        }
        // Apply dynamic filter passed from Aura if provided
        if (this.filter && this.filterValue && this.operator) {
            let filterCondition = this.getFilterCondition(this.filter, this.operator, this.filterValue);
            query += `q = filter q by ${filterCondition};\n`;

        }

        query += 'q = foreach q generate\n';

        this.columns.forEach((column, index) => {
            query += `q.'${column.fieldName.toUpperCase()}' as '${column.fieldName.toUpperCase()}'`;

            // Add a comma for all fields except the last one
            if (index < this.columns.length - 1) {
                query += ',\n';
            } else {
                query += ';\n';
            }
        });

        
        if (this.sortMap && Object.keys(this.sortMap).length > 0) {
            const orderClauses = Object.entries(this.sortMap).map(
                ([field, direction]) => `${field} ${direction}`
            );
            query += `q = order q by (${orderClauses.join(", ")});\n`;
        }
        
        // Add LIMIT clause
        query += "q = limit q 50000;\n";

        console.log('>>> Final Query:', query);
        return query;
    }

    // Function to get the filter condition string based on the operator
    getFilterCondition(field, operator, value) {
        let condition = '';

        switch (operator) {
            case 'Equals to':
                condition = `'${field}' == "${value}"`;
                break;
            case 'Not equal to':
                condition = `'${field}' != "${value}"`;
                break;
            case 'Less than':
                condition = `'${field}' > ${value}`;
                break;
            case 'Greater than':
                condition = `'${field}' < ${value}`;
                break;
            case 'Contains':
                // Handle contains as a 'like' operation
                condition = `'${field}' like "%${value}%"`;
                break;
            default:
                console.warn(`Operator ${operator} not supported.`);
                break;
        }

        return condition;
    }
}