/****
* Created on 22-03-2021
* To call Days on Hand
*/
public class EDealerDaysOnhandController {
    
    
    @AuraEnabled
    public static DaysonHandResponseWrapper fetchAWSDaysOnHandData(String dealerCode, String division){
        try{
            map<string,object> calloutDetails = new map<string,object>();
            DaysonHandResponseWrapper awsRCResultData = new DaysonHandResponseWrapper();          
            calloutDetails.put('endpoint','/days/kpi/'+dealerCode+'/dealer?dealer_division='+division);
            calloutDetails.put('method','GET'); 
            calloutDetails.put('classname','EDealerDaysOnhandController');
            String jsonRes = EDealerHttpHandler.callout(calloutDetails);
            
            // Call EDealerLogUtils class based on response status code.
            // parsing the actual results
            if(jsonRes != null)
                awsRCResultData = (DaysonHandResponseWrapper)
                	System.JSON.deserialize(jsonRes, DaysonHandResponseWrapper.class);
            
            system.debug('\n--awsRCResultData--'+awsRCResultData);
            return awsRCResultData;
        }
        
        
        catch(exception ex){
            EDealerLogUtils.createExceptionLog(ex, 'EDealerDaysOnhandController');            
        }
        return new DaysonHandResponseWrapper();  
    }
    
    public class DaysonHandResponseWrapper{
        @AuraEnabled public List<DaysonHandWrapper> response;
        @AuraEnabled public String error;
    }
    
    
    /*** Days on Hand Result Parameters/attributes ***/
    public class DaysonHandWrapper {
        @AuraEnabled public String loc;
        @AuraEnabled public String parts_type;
        @AuraEnabled public decimal doh;
        
    }
    
}