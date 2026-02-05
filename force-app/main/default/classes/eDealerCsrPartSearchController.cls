public with sharing class eDealerCsrPartSearchController {
    
    @AuraEnabled
    public static String getPartListFromAws(String partNum){
        Map<string,object> calloutDetails = new Map<string,object>();
        calloutDetails.put('endpoint','/CSRPartSearch/KPI?limit=2000&offset_value=0&search_pattern='+partNum);
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','eDealerCsrPartSearchController');       
        String resultData = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('resultData-->--'+resultData);
        if(resultData!= null) {
            return resultData;
        }else if(resultData == null){
            return null;
        }
        else{
            MasterResponseWrapper res = (MasterResponseWrapper)System.JSON.deserialize(resultData, MasterResponseWrapper.class);
            String eMsg = res.ErrorResponse.ErrorMessages[0].ErrorDescription;
            return eMsg;
        }
    }
    @AuraEnabled
    public static String getPartAltPartDetails(String dealerId, String dealerSfx, String partNumber, Integer qty){       
        Map<string,object> calloutDetails = new Map<string,object>();
        String JSONBody = getEndPointParameters(dealerId,dealerSfx,partNumber,qty); 
        System.debug('partAltPartDetails---------->'+JSONBody);
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWGetPartAltPartDetails');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',JSONBody);
        calloutDetails.put('classname','eDealerCsrPartSearchController');       
        String resultData = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('resultData-->--'+resultData);
        if(resultData!= null) {
            return resultData;
        }else if(resultData == null){
            return null;
        }
        else{
            MasterResponseWrapper res = (MasterResponseWrapper)System.JSON.deserialize(resultData, MasterResponseWrapper.class);
            String eMsg = res.ErrorResponse.ErrorMessages[0].ErrorDescription;
            return eMsg;
        }
    }
    
    private static String getEndPointParameters(String dealerId, String dealerSfx, String partNumber, Integer qty){
        //JSON Generator
        string username = UserInfo.getName();
        //string JSONData = '{"UserName": "'+username+'","DealerId": "'+dealerId+'","DealerSfx": "'+dealerSfx+'","PartNumber": "'+partNumber+'","Quantity": '+qty+'}';
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('UserName', username);
        gen.writeObjectField('DealerId', dealerId);
        gen.writeObjectField('DealerSfx', dealerSfx);
        gen.writeObjectField('PartNumber', partNumber);
        gen.writeObjectField('Quantity', qty);
        gen.writeEndObject();
        // Get the JSON string.
        String pretty = gen.getAsString();
        return pretty;
    }
    
    @AuraEnabled
    public static List <Map<String,String>> getPartSearchColumnHeaders(){
        return EDealerMetadataUtility.tableColumnHeaderTranslations('partSearchTable');
    }
    
    @AuraEnabled
    public static List <Map<String,String>> getAltPartDetailsColumnHeaders(){
        return EDealerMetadataUtility.tableColumnHeaderTranslations('alternatePartTable');
    }
    
    @AuraEnabled
    public static String getUsersCountry(){
        try{
            User user = EDealerUserUtils.fetchLoggedInUserdetails();
            if(user.contactId == null){
                AuraHandledException exc = new AuraHandledException('');
                exc.setMessage('Logged in user is an Internal User');
                throw exc;
            }
            return user.Contact.Account.ShippingCountry;
        }
        catch(AuraHandledException err){
            System.debug('AuraHandledException Occurred =>'+err.getMessage());
            throw err;
        }
        catch(Exception err){
            System.debug('Exception Occurred =>'+err.getMessage());
            throw new AuraHandledException(err.getMessage());
        }
    }

    
    public class ErrorMessages {
        public String ErrorDescription;
    }
    
    public class MasterResponseWrapper{
        public CsrDataDList Data;
        public ErrorResponse ErrorResponse;
    }
    
    public class CsrDataD {
        public String PChannel;
        public Double LC;
        public Integer SPQ;
        public String PartNumber;
        public String PartDescription;
        public Double Quantity;
        public Double Pstdnt;
        public Double Pfnlnt;
        public Double Pdscpct;
        public String Dchannel;
        public Double Dstdnt;
        public Double Dfnlnt;
        public Double Ddscpct;
        public String UnitOfMeasure;
        public Integer PrimePartsAvailableQty;
        public Integer NonprimePartsAvailableQty;
    }
    
    public class CsrDataDList {
        public List<CsrDataD> CsrDataD;
    }
    
    public class ErrorResponse {
        public String IsSuccess;
        public List<ErrorMessages> ErrorMessages;
    }
}