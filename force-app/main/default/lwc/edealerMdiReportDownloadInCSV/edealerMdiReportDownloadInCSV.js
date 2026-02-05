import { LightningElement, api } from 'lwc';
import EDealer_Download_Template from '@salesforce/label/c.Download_Button';

export default class EdealerMdiReportDownloadInCSV extends LightningElement {
    @api jsondata;
    @api isDisabled = false;
    @api columns;
    @api reportLabel;

    label = { EDealer_Download_Template };

    get isButtonDisable() {
        return !this.isDisabled;
    }

    handleDownloadCSV() {
        console.log("jsonData:", this.jsondata);

        if (!this.jsondata) {
            console.error("No data available for download.");
            return;
        }

        let crmaData;
        try {
            crmaData = JSON.parse(this.jsondata);
        } catch (error) {
            console.error("Error parsing JSON:", error);
            return;
        }

        if (!Array.isArray(crmaData) || crmaData.length === 0) {
            console.error("Invalid or empty data.");
            return;
        }

        if (!this.columns || !Array.isArray(this.columns) || this.columns.length === 0) {
            console.error("Column mappings are missing or invalid.");
            return;
        }

        console.log("this.columns------->", JSON.stringify(this.columns));

        let fieldNameToLabel = {};
        this.columns.forEach(col => {
            fieldNameToLabel[col.fieldName.toUpperCase()] = col.label;
        });

        console.log("fieldNameToLabel------->", JSON.stringify(fieldNameToLabel));

        let csvHeaders = this.columns.map(col => col.label).join(",");
        let csvContent = "\uFEFF" + csvHeaders + "\n";

        console.log("CSV Headers:", csvHeaders);

        crmaData.forEach(row => {
            let csvRow = this.columns.map(col => {
                let value = row[col.fieldName] !== undefined ? row[col.fieldName] : "";
                return `"${value}"`;
            }).join(",");

            csvContent += csvRow + "\n";
        });

        console.log("Final CSV Content:\n", csvContent);

        try {
          
            let downloadElement = document.createElement("a");
            downloadElement.href = "data:text/csv;charset=utf-8,%EF%BB%BF" + encodeURIComponent(csvContent);
            downloadElement.download = (this.reportLabel || "report") + ".csv";
            downloadElement.click();
        } catch (error) {
            console.error("Error during CSV generation:", error);
        }
    }
}