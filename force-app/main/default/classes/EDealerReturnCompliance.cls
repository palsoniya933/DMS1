/*** 
* Name        :   EDealerReturnCompliance
*  Description :   This is the apex class which is used for eDealerReturnComplianceReport component
*/ 
public class EDealerReturnCompliance {
    
    @AuraEnabled
    public static ReturnsComplianceResponseWrapper fetchAWSReturnsComplianceData(string reportParamsJson){
        try{
        // saving the object to be returned
        ReturnsComplianceResponseWrapper awsRCResultData = new ReturnsComplianceResponseWrapper();
        
        // converting json to Apex
        ReturnWrapper reportParams = (ReturnWrapper) 
            JSON.deserialize(reportParamsJson, ReturnWrapper.class);
        
        // saving the http params
        map<string,object> calloutDetails = new map<string,object>();
        
        // checking if the filter values are selected 
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){
               calloutDetails.put('endpoint','/return-compliance-report-filter/dealer');			
           }
        else{
            calloutDetails.put('endpoint','/return-compliance-report/dealer');      
        }
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body',getEndPointParameters(reportParams));	        
        calloutDetails.put('classname','EDealerReturnCompliance');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
        // parsing the actual results
        if(jsonRes != null)
            awsRCResultData = (ReturnsComplianceResponseWrapper)System.JSON.deserialize(jsonRes, ReturnsComplianceResponseWrapper.class);
        
        
        //RETURN
        awsRCResultData.dataJSON = JSON.serialize(awsRCResultData.response);
        awsRCResultData.languageTranslation = new map<string,string>();
       
        awsRCResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Return Compliance');
        //End value transalation language data
        
        return awsRCResultData;
            }
        catch(Exception ex){
            system.debug('ex::'+ex.getLineNumber());
            EDealerLogUtils.createExceptionLog('EDealerReturnCompliance'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(ReturnWrapper reportParams){
        
        // divison should not be blank
        if(reportParams.dealer_codes == null){
            throw new AuraHandledException('No Dealer code selected.');
        }
        if(reportParams.dealer_codes.isEmpty()){
            throw new AuraHandledException('No Dealer code selected.');
        }
        
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', reportParams.dealer_codes);
        gen.writeStringField('startDate', string.valueOf(getStartEndDates(reportParams.month, reportParams.quarter, reportParams.year)[0]));
        gen.writeStringField('endDate', string.valueOf(getStartEndDates(reportParams.month, reportParams.quarter, reportParams.year)[1]));
        gen.writeNumberField('offset', reportParams.offset);
        gen.writeNumberField('limit', reportParams.recLimit);
        
        /** setting the filter params ***/
        if(!String.isBlank(reportParams.field)
           && !String.isBlank(reportParams.operator)
           && !String.isBlank(reportParams.value)){
               
               gen.writeStringField('field',reportParams.field.toUpperCase());
               gen.writeStringField('operator',reportParams.operator);
               gen.writeStringField('value',reportParams.value);
           }
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    //03-02-2022
   	@AuraEnabled
    public static map<string,string> getMonthsTranslation(){
       map<string,string> languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Return Compliance Month Dropdown');
        return languageTranslation;
    }
    
    
    public static List<Date> getStartEndDates( String month, String quarter, String year){
        List<Date> startAndEndDates = new List<Date>();
        Integer dayInt = 1;
        Integer monthInt;
       // Integer yearInt;
        
        if(String.isNotBlank(month)){
            List<String> monthSplit = month.split(' ');
            
            if(monthSplit[0].toLowerCase() == 'jan')
                monthInt = 1;
            else if(monthSplit[0].toLowerCase() == 'feb')
                monthInt = 2;
            else if(monthSplit[0].toLowerCase() == 'mar')
                monthInt = 3;
            else if(monthSplit[0].toLowerCase() == 'apr')
                monthInt = 4;
            else if(monthSplit[0].toLowerCase() == 'may')
                monthInt = 5;
            else if(monthSplit[0].toLowerCase() == 'jun')
                monthInt = 6;
            else if(monthSplit[0].toLowerCase() == 'jul')
                monthInt = 7;
            else if(monthSplit[0].toLowerCase() == 'aug')
                monthInt = 8;
            else if(monthSplit[0].toLowerCase() == 'sep')
                monthInt = 9;
            else if(monthSplit[0].toLowerCase() == 'oct')
                monthInt = 10;
            else if(monthSplit[0].toLowerCase() == 'nov')
                monthInt = 11;
            else if(monthSplit[0].toLowerCase() == 'dec')
                monthInt = 12;
            
            Date stDate = date.newinstance(Integer.valueOf(monthSplit[1]), monthInt, dayInt);
            Date enDate = (((stDate.addMonths(1)).addDays(-1)) < date.today()) ? ((stDate.addMonths(1)).addDays(-1)) : date.today();
            startAndEndDates.add(stDate);
            startAndEndDates.add(enDate);
        }
        else if(String.isNotBlank(quarter)){
            List<String> quarterSplit = quarter.split(' ');
            
            if(quarterSplit[0].toLowerCase() == 'q1')
                monthInt = 1;
            else if(quarterSplit[0].toLowerCase() == 'q2')
                monthInt = 4;
            else if(quarterSplit[0].toLowerCase() == 'q3')
                monthInt = 7;
            else if(quarterSplit[0].toLowerCase() == 'q4')
                monthInt = 10;
            
            Date stDate = date.newinstance(Integer.valueOf(quarterSplit[1]), monthInt, dayInt);
            Date enDate = (((stDate.addMonths(3)).addDays(-1)) < date.today()) ? ((stDate.addMonths(3)).addDays(-1)) : date.today();
            startAndEndDates.add(stDate);
            startAndEndDates.add(enDate);
        }
        else if(String.isNotBlank(year)){
            Date stDate = date.newinstance(Integer.valueOf(year), 1, 1);
            Date enDate = (((stDate.addMonths(12)).addDays(-1)) < date.today()) ? ((stDate.addMonths(12)).addDays(-1)) : date.today();
            startAndEndDates.add(stDate);
            startAndEndDates.add(enDate);
        }        
        return startAndEndDates;
    }
    
    public class ReturnsComplianceResponseWrapper{
        @AuraEnabled public List<ReturnsReportWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public Integer RowCount;
        @AuraEnabled public String error;
    }
    
    /*** Returns Compliance  Result Parameters/attributes ***/
    public class ReturnsReportWrapper {
        @AuraEnabled public String dlrcode;
        @AuraEnabled public String grp_num;
        @AuraEnabled public String rmatype;
        @AuraEnabled public String item;
        @AuraEnabled public String suggested_date;
        @AuraEnabled public String po_number;
        @AuraEnabled public Double suggested_amt;
        @AuraEnabled public String returned_date;
        @AuraEnabled public decimal returned_qty;
        @AuraEnabled public Double returned_amt;
        @AuraEnabled public Double avg_return_compliance;
        @AuraEnabled public String return_status;
        @AuraEnabled public Double suggested_extnet;
        @AuraEnabled public Double suggested_qty;
        @AuraEnabled public Double returned_extnet;
        @AuraEnabled public String order_status;
    }
    
    // this is the wrapper class which is used to take the input to generate the report
    public class ReturnWrapper{
        @AuraEnabled public Integer recLimit;
        @AuraEnabled public Integer offset;
        @AuraEnabled public List<String> dealer_codes;        
        @AuraEnabled public String field;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;      
        @AuraEnabled public String month;
        @AuraEnabled public String quarter;
        @AuraEnabled public String year;
    }
}