({    
    doInit : function(component,event,helper){        
    },
    //## function call on Click on the "Download As CSV" Button.
    downloadCsvData  : function(component,event,helper){
        var params = event.getParam('arguments');
        var JSONData = params.reportData;  
        console.log('JSONData::'+JSONData);
        // getting report name
        var reportName = component.get("v.reportName");  
        var isReportTimeStamp = component.get("v.isReportTimeStamp");
        if(isReportTimeStamp){
            var timeStamp = helper.getDateTime(component, event, helper); 
            reportName += ' ' +timeStamp;
        }        
        //getting columns from lightning table
        var columns = component.get("v.columns"); 
        helper.downloadCsv(component,event,helper,JSONData);
    },
    //## function call on Click on the "Download As CSV" Button. 
    downloadCsv : function(component,event,helper){
        var stockData = component.get("v.report");
        var downloadFromInventory = component.get("v.isDownloadFromInventory");
        if(downloadFromInventory == true){
            for (var i = 0; i < stockData.length; i++) {
                if(JSON.stringify(stockData[i].PriceDetail.WhsFinalNet) != undefined 
                   && JSON.stringify(stockData[i].PriceDetail.DspFinalNet)  != undefined){
                    stockData[i].PriceDetail = 'PDC '+stockData[i].PriceDetail.WhsFinalNet +'and '+'DSP '+stockData[i].PriceDetail.DspFinalNet;
                }
                else if(JSON.stringify(stockData[i].PriceDetail.WhsFinalNet) != undefined){
                    stockData[i].PriceDetail = 'PDC '+stockData[i].PriceDetail.WhsFinalNet;
                    
                }
                else if(JSON.stringify(stockData[i].PriceDetail.DspFinalNet) != undefined){
                    stockData[i].PriceDetail = 'DSP '+stockData[i].PriceDetail.DspFinalNet;
                }
                else{
                    stockData[i].PriceDetail = 'DSP';
                }
            }
        }
        console.log('downloadCsv stockData::'+JSON.stringify(stockData));
        //getting report name
        var reportName = component.get("v.reportName");  
        var isReportTimeStamp = component.get("v.isReportTimeStamp");
        if(isReportTimeStamp){
            var timeStamp = helper.getDateTime(component, event, helper); 
            reportName += ' ' +timeStamp;
        }
        
        //getting columns from lightning table
        var columns = component.get("v.columns");  
        //console.log('columns==>'+json.stringify(columns));
        var findChildComp = component.find('childLwcCompId');
        console.log('columns::'+JSON.stringify(columns));
        console.log('reportName::'+reportName);
        try{
            findChildComp.downloadV1(columns, stockData, reportName);            
        }
        catch(e){
            console.log('error ----- >>>>> '+e.message);
        } 
    },
    
    downloadCsvPartion : function(component,event,helper){
        var params = event.getParam('arguments');
        var JSONData = params.reportData;        
        var stockData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;
        console.log('stockData::'+stockData);
        // getting report name
        var reportName = component.get("v.reportName");  
        var isReportTimeStamp = component.get("v.isReportTimeStamp");
        if(isReportTimeStamp){
            var timeStamp = helper.getDateTime(component, event, helper); 
            reportName += ' ' +timeStamp;
        }
        //getting columns from lightning table
        var columns = component.get("v.columns");  
        
        var findChildComp = component.find('childLwcCompId');
        
        try{
            findChildComp.downloadV1(columns, stockData, reportName);            
        }
        catch(e){
            console.log('error ----- >>>>> '+e.message);
        }
    },
})