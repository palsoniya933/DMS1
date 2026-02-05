({
    
    makeCSVData : function(component, objectRecords, columns){
        // declare variables
        var csvStringResult, counter, keys, keysLabel, columnDivider, lineDivider;
        
        keys = [];
        keysLabel = [];
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        csvStringResult = '';
        
        if(columns != undefined && columns.length > 0){
            // getting headers
            //This loop will extract the label from 1st index of on array
            for (var index in columns) {
                //Now convert each value to string and comma-seprated
                keys.push(columns[index].fieldName);
                keysLabel.push((columns[index].label).replace("#",""));
            }
        }else{
            return null;
        }
        
        
        csvStringResult += keysLabel.join(columnDivider);
        csvStringResult += lineDivider;        
        //console.log("csvStringResult ==>> "+JSON.stringify(csvStringResult));
        for(var i= 0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }  
                
                // objectRecords[i][skey] = " "+objectRecords[i][skey]+" ";
                
                var cellValue = '';
                
                // if not empty
                if(objectRecords[i][skey]){
                    cellValue =  objectRecords[i][skey].toString();
                    //csvStringResult += '"'+ objectRecords[i][skey].toString()+'"'; 
                }      
                
                // if that is 0 ( as 0 is considered as false)
                else if(objectRecords[i][skey] == 0){
                    cellValue =  objectRecords[i][skey].toString();
                }
                    else{
                        cellValue += ''; 
                    }
                if(cellValue.indexOf('undefined') != -1){
                    cellValue = '';
                }
                
                //replace the special '’' charater
                cellValue = cellValue.replaceAll("’", "'");
                cellValue = cellValue.replaceAll("#", "'");
                
                
                if(cellValue == ''){
                    csvStringResult += '"'+ cellValue+'"';
                }else{
                    csvStringResult += '"'+ cellValue+'"' + String.fromCharCode(8203); 
                }
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
    
    getDateTime : function(component, event, helper) {
        var now     = new Date(); 
        var year    = now.getFullYear();
        var month   = now.getMonth()+1; 
        var day     = now.getDate();
        var hour    = now.getHours();
        var minute  = now.getMinutes();
        var second  = now.getSeconds(); 
        if(month.toString().length == 1) {
            month = '0'+month;
        }
        if(day.toString().length == 1) {
            day = '0'+day;
        }   
        if(hour.toString().length == 1) {
            hour = '0'+hour;
        }
        if(minute.toString().length == 1) {
            minute = '0'+minute;
        }
        if(second.toString().length == 1) {
            second = '0'+second;
        }   
        var dateTime = month+'-'+day+'-'+year+' '+hour+'.'+minute+'.'+second;   
        return dateTime;
    },
    
    msieversion : function() {
        var ua = window.navigator.userAgent; 
        var msie = ua.indexOf("MSIE "); 
        if (msie != -1 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) // If Internet Explorer, return version number 
        {
            return true;
        } else { // If another browser, 
            return false;
        }
        return false; 
    },
    downloadCsv : function(component, event, helper,JSONData){
        var invData = JSONData;
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
            var csv = headerData + helper.convertListToCSV(invData ,headerList);
            var hiddenElement = document.createElement("a");
            hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURIComponent(csv);
            hiddenElement.target = "_blank";
            hiddenElement.download = "Master Inventory.csv";
            hiddenElement.click();
        } 
    },
    convertListToCSV : function(sObjectList ,headerList){
        var count=1;
        var csv='';      
        for (var i = 0; i < sObjectList.length; i++) {
            for (var j = 0; j < headerList.length; j++) {
                var columnName = headerList[j];
                var cellValue='';
                if(columnName =='#'){
                    cellValue =count;
                    count+=1;
                }
                else if (columnName == 'PriceDetail') {
                    if ( sObjectList[i][columnName]['DspFinalNet'] != undefined &&  sObjectList[i][columnName]['WhsFinalNet'] != undefined) {
                        cellValue = 'PDC' + sObjectList[i][columnName]['WhsFinalNet'] + '-' + 'DSP' + sObjectList[i][columnName]['DspFinalNet'];
                    } else if ( sObjectList[i][columnName] != undefined) {
                        if ( sObjectList[i][columnName]['WhsFinalNet'] == undefined && sObjectList[i][columnName]['DspFinalNet'] != undefined) {
                            cellValue = 'DSP ' + sObjectList[i][columnName]['DspFinalNet'];
                        } else if( sObjectList[i][columnName]['WhsFinalNet'] != undefined){
                            cellValue = 'PDC ' + sObjectList[i][columnName]['WhsFinalNet'];
                        }
                    }   
                    
                }
                    else{
                        cellValue = sObjectList[i][columnName];   
                    }
                csv += cellValue;
                if (j < headerList.length - 1) {
                    csv += ',';
                }
            }
            csv += '\n';
        }
        return csv;
    },
    
    
})