import { LightningElement, api } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import workbook from "@salesforce/resourceUrl/xlsx";
export default class XlsxMain extends LightningElement {
  @api headerList;
  @api filename;
  @api worksheetNameList;
  @api sheetData;
  librariesLoaded = false;
  renderedCallback() {
    debugger;
    console.log("renderedCallback xlsx");
    if (this.librariesLoaded) return;
    this.librariesLoaded = true;
    Promise.all([loadScript(this, workbook + "/xlsx/xlsx.full.min.js")])
      .then(() => {
        console.log("success");
      })
      .catch(error => {
        console.log("failure");
      });
  }

  @api downloadV1(reportColumns, rowData, reportName) {
      console.log('downloadV1 called.');
      debugger;
      const XLSX = window.XLSX;
      let xlsData;
      this.filename = reportName;
      this.workSheetNameList = [];
      this.workSheetNameList.push(reportName);
      this.headerList = [];

      reportColumns.forEach(item1=>{
        this.headerList.push(item1.label);     
      })
      let xlsHeader = this.headerList;

    
      let xlsDataArray = [];
      xlsDataArray.push(rowData);
      xlsData = xlsDataArray;

      //console.log("xlsData ==>> "+JSON.stringify(xlsData));
      let createXLSLFormatObj = Array(xlsData.length).fill([]);

      //console.log('rowData ---->>>>>> '+JSON.stringify(rowData));

      var newparentLst = [];
      var newchildLst = [];
      for(var i=0;i<reportColumns.length;i++){
          newchildLst.push(reportColumns[i].label);
      }
      newparentLst.push(newchildLst);
      //console.log('newparentLst ---->>>>>> '+JSON.stringify(newparentLst));
      newparentLst.forEach((item, index) =>{
        //  console.log('');
         // console.log('index --->>> '+index);
         // console.log('item --->>> '+item);
          
          createXLSLFormatObj[index] = [item];
          //  console.log('createXLSLFormatObj --->>> '+JSON.stringify(createXLSLFormatObj));
          //  console.log('');
       });

      /* form data key list */
      xlsData.forEach((item, selectedRowIndex)=> {
          debugger;
          //console.log('item[0] ==>> '+JSON.stringify(item[0]));
          let xlsRowKey = Object.keys(item[0]);
          //console.log('xlsRowKey =======>> '+JSON.stringify(xlsRowKey));
          //console.log('item =======>> '+JSON.stringify(item));
          item.forEach((value, index) => {
              var innerRowData = [];
              //console.log('-----------------------------------');

              reportColumns.forEach(item1=>{
                //console.log('value ==>>>>> '+JSON.stringify(value));
                //console.log('item1 ==>>>>> '+JSON.stringify(item1));
               // console.log('item1.fieldName item ==>>>>>'+item1.fieldName);
                
                var temp1 = value[item1.fieldName];
                //console.log('temp1 ==>> '+JSON.stringify(temp1));
                
                if(temp1 == null || temp1 == undefined){
                  innerRowData.push('');
                }else {
                  innerRowData.push(temp1.toString());
                }

                
              })
              //console.log('*********-----------------------------------');
              createXLSLFormatObj[selectedRowIndex].push(innerRowData);
              //console.log('createXLSLFormatObj ==>>>>> '+JSON.stringify(createXLSLFormatObj));
              //console.log(' ');
          })

      });
    /* creating new Excel */
    var wb = XLSX.utils.book_new();

    /* creating new worksheet */
    var ws = Array(createXLSLFormatObj.length).fill([]);
    for (let i = 0; i < ws.length; i++) {
      /* converting data to excel format and puhing to worksheet */
      let data = XLSX.utils.aoa_to_sheet(createXLSLFormatObj[i]);
      ws[i] = [...ws[i], data];

      /* Add worksheet to Excel */
     // console.log('ws[i] ==>> '+JSON.stringify(ws[i]));
     // console.log('ws[i][0] ==>> '+JSON.stringify(ws[i][0]));
    //  console.log('wb == >> '+JSON.stringify(wb));
    //  console.log('reportName---->>> '+JSON.stringify(reportName));
      XLSX.utils.book_append_sheet(wb, ws[i][0], 'sheet1');
    //  console.log('wb2 == >> '+JSON.stringify(wb));
    }

    /* Write Excel and Download */
    XLSX.writeFile(wb, (reportName+".xlsx"));

  }

  @api download() {
    var t1List = [];
    var a2 = {};
    a2.fieldName = 'Name';
    a2.label = 'FULL NAME';
    t1List.push(a2);
                var a1 = {};
                a1.fieldName = 'Id';
                a1.label = 'ID';
                t1List.push(a1);
                
                var a3 = {};
                a3.fieldName = 'Phone';
                a3.label = 'PHONE';
                t1List.push(a3);

    const XLSX = window.XLSX;
    let xlsData = this.sheetData;
    let xlsHeader = this.headerList;
    let ws_name = this.worksheetNameList;
    //console.log("xlsData ==>> "+JSON.stringify(xlsData));
    let createXLSLFormatObj = Array(xlsData.length).fill([]);
    //let xlsRowsKeys = [];
    /* form header list */

    //console.log('xlsHeader ---->>>>>> '+JSON.stringify(xlsHeader));
    //console.log('t1List ---->>>>>> '+JSON.stringify(t1List));

    var newparentLst = [];
    var newchildLst = [];
    for(var i=0;i<t1List.length;i++){
        newchildLst.push(t1List[i].label);
    }
    newparentLst.push(newchildLst);
    //console.log('newparentLst ---->>>>>> '+JSON.stringify(newparentLst));
    newparentLst.forEach((item, index) =>{
          //console.log('');
          //console.log('index --->>> '+index);
          //console.log('item --->>> '+item);
          
          createXLSLFormatObj[index] = [item];
          //console.log('createXLSLFormatObj --->>> '+JSON.stringify(createXLSLFormatObj));
          //console.log('');
       });

    /* form data key list */
      xlsData.forEach((item, selectedRowIndex)=> {
          debugger;
          //console.log('item[0] ==>> '+JSON.stringify(item[0]));
          let xlsRowKey = Object.keys(item[0]);
          //console.log('xlsRowKey =======>> '+JSON.stringify(xlsRowKey));
          //console.log('item =======>> '+JSON.stringify(item));
          item.forEach((value, index) => {
              var innerRowData = [];
              //console.log('-----------------------------------');


                t1List.forEach(item=>{
                //console.log('value ==>>>>> '+JSON.stringify(value));
                //console.log('item ==>>>>> '+JSON.stringify(item));
                //console.log('value[item] ==>> '+JSON.stringify(value[item.fieldName]));
                  innerRowData.push(value[item.fieldName]);
              })
              //console.log('*********-----------------------------------');
              createXLSLFormatObj[selectedRowIndex].push(innerRowData);
              //console.log('createXLSLFormatObj ==>>>>> '+JSON.stringify(createXLSLFormatObj));
              //console.log(' ');
          })

      });
      debugger;
    /* creating new Excel */
    var wb = XLSX.utils.book_new();

    /* creating new worksheet */
    var ws = Array(createXLSLFormatObj.length).fill([]);
    for (let i = 0; i < ws.length; i++) {
      /* converting data to excel format and puhing to worksheet */
      let data = XLSX.utils.aoa_to_sheet(createXLSLFormatObj[i]);
      ws[i] = [...ws[i], data];

      //console.log('ws[i] ==>> '+JSON.stringify(ws[i]));
      //console.log('ws[i][0] ==>> '+JSON.stringify(ws[i][0]));
      //console.log('wb == >> '+JSON.stringify(wb));
      //console.log('ws_name---->>> '+JSON.stringify(ws_name));
      /* Add worksheet to Excel */
      XLSX.utils.book_append_sheet(wb, ws[i][0], ws_name[i]);
      //console.log('wb2 == >> '+JSON.stringify(wb));
    }
    
    /* Write Excel and Download */
    XLSX.writeFile(wb, this.filename);
  }
}