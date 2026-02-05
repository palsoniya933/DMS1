public class EDealerReturnComplianceListingCtrl {
    /****
    * Created on 11-3-2021
    * To call Returns Compliance Listing
    */ 
    @AuraEnabled
    public static ReturnsComplianceResponseWrapper fetchAWSReturnsComplianceData(List<String> dealerCodes, 
                                                                                 	String division,
                                                                                 	String month, 
                                                                                 	String quarter, 
                                                                                 	String year, 
                                                                                 	Integer offSet, 
                                                                                 	Integer recLimit,
                                                                                	Date monthDate,
                                                                                	Date quarterDate){
        
        
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        ReturnsComplianceResponseWrapper awsRCResultData = new ReturnsComplianceResponseWrapper();
        
        //getting start - end dates
        List<Date> startAndEndDates = getStartEndDates(month, quarter, year);       
        calloutDetails.put('endpoint','/return-compliance-report/dealer');
        calloutDetails.put('method','POST');  
        calloutDetails.put('body',getEndPointParameters(dealerCodes, offSet, recLimit, startAndEndDates[0], startAndEndDates[1]));
         System.debug(getEndPointParameters(dealerCodes, offSet, recLimit, startAndEndDates[0], startAndEndDates[1]));
        calloutDetails.put('classname','EDealerReturnComplianceListingCtrl');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails); 
        // parsing the actual results
        if(jsonRes != null){
            awsRCResultData = (ReturnsComplianceResponseWrapper)System.JSON.deserialize(jsonRes, ReturnsComplianceResponseWrapper.class);
        }        
        //RETURN
        awsRCResultData.dataJSON = JSON.serialize(awsRCResultData.response);
        
          awsRCResultData.languageTranslation = new map<string,string>();
        awsRCResultData.languageTranslation =  EDealerMetadataUtility.translateColumnHeadersVersion2('Return Compliance Listing');
        System.debug('awsRCResultData.languageTranslation '+awsRCResultData.languageTranslation );
        system.debug('awsRCResultData.response::'+JSON.serializePretty(awsRCResultData.response));                                                                               
                                                                                        
        
        if(jsonRes != null){                                                                                
        	EDealerReturnComplianceController.ReturnsComplianceKPIResponseWrapper awsRCKPIResultData = EDealerReturnComplianceController.fetchAWSReturnsComplianceKPIData(dealerCodes, division);
        	if(awsRCKPIResultData != null && awsRCKPIResultData.response != null){                                                                               
            	if(month != null){
                    if(!awsRCKPIResultData.response.month_data.isEmpty()){ 
                        for(EDealerReturnComplianceController.ReturnsWrapper monthWrap :  awsRCKPIResultData.response.month_data){
                            if(monthWrap.suggested_month_create_date != null &&
                               monthWrap.suggested_month_create_date.year() == monthDate.year() && 
                               monthWrap.suggested_month_create_date.month() == monthDate.month() &&
                               monthWrap.suggested_month_create_date.day() == monthDate.day()){
                                   awsRCResultData.kpiData = monthWrap;
                               }
                        }
                    }
            	}
            	else if(quarter != null){
                    if(!awsRCKPIResultData.response.quarter_data.isEmpty()){
                        for(EDealerReturnComplianceController.ReturnsWrapper quarterWrap :  awsRCKPIResultData.response.quarter_data){
                            if(quarterWrap.suggested_quarter_create_date != null &&
                               quarterWrap.suggested_quarter_create_date.year() == quarterDate.year() && 
                               quarterWrap.suggested_quarter_create_date.month() == quarterDate.month() &&
                               quarterWrap.suggested_quarter_create_date.day() == quarterDate.day()){
                                   awsRCResultData.kpiData = quarterWrap;
                               }
                        }
                    }
            	}
            	else if(year != null){
                    if(awsRCKPIResultData.response.previous_year_data != null && !awsRCKPIResultData.response.previous_year_data.isEmpty()){
                        for(EDealerReturnComplianceController.ReturnsWrapper previousYearWrap :  awsRCKPIResultData.response.previous_year_data){
                            if(previousYearWrap.suggested_year == Integer.valueOf(year)){
                                awsRCResultData.kpiData = previousYearWrap;
                            }
                        }
                    }
                     if(awsRCKPIResultData.response.current_year_data != null && !awsRCKPIResultData.response.current_year_data.isEmpty()){
                        for(EDealerReturnComplianceController.ReturnsWrapper currentYearWrap :  awsRCKPIResultData.response.current_year_data){
                            if(currentYearWrap.suggested_year == Integer.valueOf(year)){
                                awsRCResultData.kpiData = currentYearWrap;
                            }
                        }
                    }
            	}
        	}
        }      
        System.debug('JSON--' + awsRCResultData);
        return awsRCResultData;
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(List<String> dealerCodes, Integer offSet, Integer recLimit, Date startDate, Date endDate){
        // divison should not be blank
        if(dealerCodes == null){
            throw new AuraHandledException('No Dealer code selected.');
        }
        if(dealerCodes.isEmpty()){
            throw new AuraHandledException('No Dealer code selected.');
        }
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeStringField('startDate', String.valueOf(startDate));
        gen.writeStringField('endDate', String.valueOf(endDate));
        gen.writeNumberField('offset', offSet);
        gen.writeNumberField('limit', recLimit);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    
    public static List<Date> getStartEndDates( String month, String quarter, String year){
        List<Date> startAndEndDates = new List<Date>();
        Integer dayInt = 1;
        Integer monthInt;
        Integer yearInt;
        
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
        @AuraEnabled public List<ReturnsComplianceWrapper> response;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public Integer RowCount;
        @AuraEnabled public EDealerReturnComplianceController.ReturnsWrapper kpiData;
        @AuraEnabled public String error;
        @AuraEnabled public map<string,object>languageTranslation;
    }
    
    /*** Returns Compliance  Result Parameters/attributes ***/
    public class ReturnsComplianceWrapper {
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
}