({
    doInit : function(component, event, helper) {},
    
    //use this method to download file in csv format.
    downloadCsv : function(component, event, helper) {
        var invData = component.get("v.invData");
        console.log("invData"+JSON.stringify(component.get("v.invData")));
        if (invData && invData.length > 0) {
            var header = component.get("v.columns");
            var headerLength = header.length;
            var headerData = '';
            var headerList=[];
            for (var i = 0; i < headerLength; i++) {
                headerList.push(header[i].fieldName);
                headerData += header[i].label;
                if (i < headerLength - 1) {
                    headerData += ',';
                }
            }            
            headerData += '\n';            
            var csv;
            if(component.get('v.isMasterInventoryData') == true){
                csv = headerData + helper.convertListToCSVForManterInventory(invData ,headerList);   
            }
            else{
                csv = headerData + helper.convertListToCSV(invData ,headerList);   
            }
            var hiddenElement = document.createElement("a");
            hiddenElement.href = "data:text/csv;charset=utf-8,%EF%BB%BF" + encodeURIComponent(csv);
            hiddenElement.target = "_blank";
            hiddenElement.download = component.get('v.reportName')+''+'.csv';
            hiddenElement.click();
        } 
    }
})