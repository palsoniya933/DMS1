({
    convertListToCSVForManterInventory : function(sObjectList ,headerList){
        
        var count=1;
        var csv='';     
        for (var i = 0; i < sObjectList.length; i++) {
            for (var j = 0; j < headerList.length; j++) {
                var columnName = headerList[j];
                var cellValue='';
                if(columnName == '#'){
                    cellValue =count;
                    count+=1; 
                }
                else if(columnName =='SPECIAL'){
                    cellValue ='';
                }
                    else if(columnName=='decription' && sObjectList[i][columnName].includes(',')){
                        cellValue =  sObjectList[i][columnName].replaceAll(",", ";")
                    }
                
                        else if (columnName.includes('PriceDetail')) {
                            if (sObjectList[i][columnName]['DspFinalNet'] !== undefined && sObjectList[i][columnName]['WhsFinalNet'] !== undefined) {
                                cellValue = 'PDC' + sObjectList[i][columnName]['WhsFinalNet'] + '-' + 'DSP' + sObjectList[i][columnName]['DspFinalNet'];
                            } else if (sObjectList[i][columnName] !== undefined) {
                                if (sObjectList[i][columnName]['WhsFinalNet'] === undefined && sObjectList[i][columnName]['DspFinalNet'] !== undefined) {
                                    cellValue = 'DSP ' + sObjectList[i][columnName]['DspFinalNet'];
                                } else if (sObjectList[i][columnName]['WhsFinalNet'] !== undefined) {
                                    cellValue = 'PDC ' + sObjectList[i][columnName]['WhsFinalNet'];
                                } else {
                                    cellValue = 'DSP';
                                }
                            }
                        }
                            else{
                                cellValue = sObjectList[i][columnName];   
                            }
                csv += cellValue;
                
                if (j <=headerList.length-1) {
                    csv += ',';
                }
            }
            csv += '\n';
        }
        
        console.log('csv'+csv);
        return csv;
    },
    convertListToCSV : function(sObjectList ,headerList){
        var count = 1;
        var csv = '';   
        console.log('sObjectList'+JSON.stringify(sObjectList));
        console.log('headerList'+headerList);
        for (var i = 0; i < sObjectList.length; i++) {
            for (var j = 0; j < headerList.length; j++) {
                var columnName = headerList[j];
                
                var cellValue='';
                cellValue = sObjectList[i][columnName];
                console.log('cellValue'+cellValue);
                console.log('sObjectList[i]'+JSON.stringify(sObjectList[i]));
                if(columnName in sObjectList[i]){
                    console.log('columnName in sObjectList[i]'+sObjectList[i][columnName]);
                    if(typeof sObjectList[i][columnName] !== 'number'){
                        if( sObjectList[i][columnName].includes(',')){
                            cellValue =  sObjectList[i][columnName].replaceAll(",", "");
                        }
                    }
                    console.log('after cellValue'+cellValue);
                }
                else{
                    cellValue ='';
                }
                csv += cellValue;
                if (j <=headerList.length-1) {
                    csv += ',';
                }
            }
            csv += '\n';
        }
        return csv;
    }
})