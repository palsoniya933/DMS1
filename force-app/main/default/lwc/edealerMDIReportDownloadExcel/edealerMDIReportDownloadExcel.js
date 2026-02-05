import { LightningElement, api } from 'lwc';
import XLSX_LIB from '@salesforce/resourceUrl/xlsx';
import { loadScript } from 'lightning/platformResourceLoader';
import EDealerResources from '@salesforce/resourceUrl/EDealerResources';
import EDealer_Download_Template from '@salesforce/label/c.Download_Button';

export default class EdealerMDIReportDownloadExcel extends LightningElement {

excelDownloadLogo = EDealerResources + '/icons/Excelliconwhite.svg' + '#Excelliconwhite';
@api reportLabel;
@api jsondata;
@api columns
@api isDisabled = false;
xlsxLibInitialized = false;
XLSX = null; // Store XLSX locally

label = {
    EDealer_Download_Template
};

get isButtonDisable() {
    return !this.isDisabled;
}

get isButtonCls() {

    if (this.isDisabled) {
        return "download-btn";
    } else {
        return "download-btngrey";
    }
}

renderedCallback() {
    if (this.librariesLoaded) return;

    console.log("Loading XLSX library...");
    this.librariesLoaded = true;
    debugger;
    loadScript(this, XLSX_LIB + "/xlsx/xlsx.full.min.js") // Directly pass the URL to loadScript
        .then(() => {
            if (window.XLSX) {
                this.XLSX = window.XLSX; // Assign XLSX after successful load
                console.log("XLSX library loaded successfully.");
            } else {
                throw new Error("XLSX is not available in window scope.");
            }
        })
        .catch(error => {
            console.error("Error loading XLSX library:", error);
        });
}

handleDownloadExcel() {
    if (!this.XLSX) {
        console.error("XLSX library is not loaded yet. Please try again.");
        return;
    }

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

    // Create a mapping of fieldName to label
    let fieldNameToLabel = {};
    this.columns.forEach(col => {
        fieldNameToLabel[col.fieldName.toUpperCase()] = col.label; // Case-insensitive match
    });

    console.log("fieldNameToLabel------->", JSON.stringify(fieldNameToLabel));

    // Transform crmaData: Replace keys with corresponding labels
    let transformedData = crmaData.map(row => {
        let newRow = {};
        Object.keys(row).forEach(key => {
            let upperKey = key.toUpperCase(); // Normalize key for case-insensitive matching
            let newKey = fieldNameToLabel[upperKey] || key; // Use label or keep original key
            newRow[newKey] = row[key];
        });
        return newRow;
    });

    try {
        console.log("transformedData------->", JSON.stringify(transformedData));

        // Convert JSON to worksheet
        let worksheet = this.XLSX.utils.json_to_sheet(transformedData);

        // Create a new workbook and append the worksheet
        let workbook = this.XLSX.utils.book_new();
        this.XLSX.utils.book_append_sheet(workbook, worksheet, this.reportLabel);

        // Generate Excel file
        this.XLSX.writeFile(workbook, this.reportLabel + ".xlsx");
    } catch (error) {
        console.error("Error during Excel generation:", error);
    }
}
}