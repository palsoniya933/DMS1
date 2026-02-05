/* Project    : MDI Tier Level Changes
* Modified by: Chito Bulahan
* Date       : 07/27/2023 
* Description: Added Auto_Accept and Auto_Accept_Util fields in QuarterToDateReportWrapper Method
* Search Tag : MDI Tier Level Changes 
* 
* Project    : US1412243 - Quarter to date (QTD Metrics) Report
* Modified by: Vivian D. Mirador
* Date       : 11/25/2024 
* Description: Added grp_nbr and auto_accept_utilization (percentage) to the QTD metrics report
*/

public with sharing class EDealerQuarterToDateController {
    
    /**** this method Quater to get date Dashboard tile note details ***/    
    @AuraEnabled
    public static List<object> getQuarterToDateTileTableData() {
        List<object> qtdTableRows = new List<object>();
        String userLang = UserInfo.getLanguage();
        
        if(UserInfo.getLanguage() == 'es_MX'){
            qtdTableRows = [SELECT Id,
                            DeveloperName,
                            MasterLabel,
                            Availablility__c,
                            Breadth__c,
                            Display_Order_Number__c,
                            EM_Fright_Discount__c,
                            Restocking_Fee__c,
                            Tier_Level__c,
                            Scrap__c
                            FROM EDealer_Quarter_To_Date_FR__mdt
                            ORDER BY Display_Order_Number__c ASC
                            LIMIT 10000
                           ];
        }else {
            qtdTableRows = [SELECT Id,
                            DeveloperName,
                            MasterLabel,
                            Availablility__c,
                            Breadth__c,
                            Display_Order_Number__c,
                            EM_Fright_Discount__c,
                            Restocking_Fee__c,
                            Tier_Level__c,
                            Scrap__c
                            FROM EDealer_Quarter_To_Date__mdt
                            ORDER BY Display_Order_Number__c ASC
                            LIMIT 10000
                           ];  
        }
        return qtdTableRows;
    }
    
    @AuraEnabled
    public static QuarterToDateReportResponseWrapper fetchAWSQuarterToDateReportData(List<String> dealerCodes, String division, string year, string quarter, Integer offSet, Integer recLimit){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        QuarterToDateReportResponseWrapper awsReportResultData = new QuarterToDateReportResponseWrapper();
        calloutDetails.put('endpoint','/quarter-to-date-report/dealer');
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body',getEndPointParameters(dealerCodes, division, year, quarter, offset, recLimit));
        calloutDetails.put('classname','EDealerQuarterToDateController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        // system.debug('jsonRes :' + jsonRes);
        
        // parsing the actual results
        if(jsonRes != null){
            awsReportResultData = (QuarterToDateReportResponseWrapper)System.JSON.deserialize(jsonRes, QuarterToDateReportResponseWrapper.class);
              for (QuarterToDateReportWrapper record : awsReportResultData.response) {
                if (record.availability != null) {
                    record.availability = record.availability + '%';
                }
                if (record.auto_accept_utilization != null) {
                    record.auto_accept_utilization = record.auto_accept_utilization + '%';
                }
                    if (record.auto_accept_util != null) {
                    record.auto_accept_util = record.auto_accept_util + '%';
                }
                    if (record.breadth != null) {
                    record.breadth = record.breadth + '%';
                }
            }
            // system.debug('awsReportResultData :' + awsReportResultData);
        }
        //RETURN
        awsReportResultData.dataJSON = JSON.serialize(awsReportResultData.response);
        awsReportResultData.languageTranslation = new map<string,string>();
        //End value transalation language data
        awsReportResultData.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Quarter-to-Date');
        return awsReportResultData;
    }
    
    /*** To save Quarter To Date Report Api result ***/
    public class QuarterToDateReportResponseWrapper{
        @AuraEnabled public List<QuarterToDateReportWrapper> response;
        @AuraEnabled public map<string,string>languageTranslation;
        @AuraEnabled public string dataJSON;
        @AuraEnabled public Integer RowCount;
        @AuraEnabled public String error;
    }
    
    public class QuarterToDateReportWrapper{
        @AuraEnabled public String report_dt;
        @AuraEnabled public Integer report_qtr;
        @AuraEnabled public String division;
        @AuraEnabled public String grp_nbr;					// grp_nbr
        @AuraEnabled public String dealer;
        @AuraEnabled public String availability;
        @AuraEnabled public String breadth;
        // MDI Tier Level Changes - Start
        // @AuraEnabled public String auto_accept;
        @AuraEnabled public String auto_accept_util;
        @AuraEnabled public String auto_accept_utilization;	// percentage
        // MDI Tier Level Changes - End        
        @AuraEnabled public String current_tier;
        @AuraEnabled public String qtd_trending_tier;
    }
    
    // this is the method which will be used to make sure that we have params to be send to API
    private static String getEndPointParameters(List<String> dealerCodes, String division, string year, string quarter, Integer offSet, Integer recLimit){
        //divison should not be blank
        if(dealerCodes == null){
            throw new AuraHandledException('No Dealer code selected.');
        }
        if(dealerCodes.isEmpty()){
            throw new AuraHandledException('No Dealer code selected.');
        }
        
        //from location should not be blank
        if(String.isBlank(division)){
            throw new AuraHandledException('Division not available');
        }
        
        //JSON Generator
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        
        gen.writeObjectField('dealer_codes', dealerCodes);
        gen.writeStringField('dealer_division', division);
        if(!string.isBlank(year))
            //gen.writeNumberField('year', integer.valueOf(year));
            gen.writeStringField('year', year);				// from Integer to String conversion
        if(!string.isBlank(quarter))
            //gen.writeNumberField('quarter', integer.valueOf(quarter));
            gen.writeStringField('quarter', quarter);		// from Integer to String conversion
        if(offSet != null)
            gen.writeNumberField('offset', offSet);
        if(recLimit != null)
            gen.writeNumberField('limit', recLimit);
        gen.writeEndObject();
        
        //Get the JSON string.
        String pretty = gen.getAsString();
        System.debug('getEndPointParameters'+pretty);
        return pretty;
    }
}