public class eDealerChooseCompetitorController {
    
    //getCompetitors: get competitors from AWS
    @AuraEnabled(cacheable=true)
    public static String getCompetitorsFromAws(String dealerCode){
        Map<string,object> calloutDetails = new map<string,object>();
        String JSONBody = getEndPointParameters(dealerCode);        
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWGetCompetitorList');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',JSONBody);
        calloutDetails.put('classname','eDealerChooseCompetitorController');        
        String resultData = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('resultData:::'+resultData);
        if(resultData!= null) {
            eDealerPartListWrapper2 res = (eDealerPartListWrapper2)System.JSON.deserialize(resultData, eDealerPartListWrapper2.class);
            if(res.ErrorResponse.IsSuccess == 'true'){
                return JSON.serialize(res.Data.CsrDataD);
            }
            else{
                return JSON.serialize(res.ErrorResponse.ErrorMessages);
            }
        }
        else{
            return 'No Data Found!!';
        }
    }
    
    @AuraEnabled
    public static List <Map<String,String>> getCompetitorsColumnHeader(){
         user loggedInUser=EDealerUserUtils.fetchLoggedInUserdetails();
         system.debug('loggedInUser----'+loggedInUser.IsPortalEnabled);
         if(loggedInUser.IsPortalEnabled==true){
             return EDealerMetadataUtility.tableColumnHeaderTranslations('selectCompetitorHeaderWithoutAffiliation'); 
         }else{
   return EDealerMetadataUtility.tableColumnHeaderTranslations('selectCompetitorHeader');
         }
    }
    
    @AuraEnabled(cacheable=true)
    public static User fetchLoggedInUserdetails() {
        return EDealerUserUtils.fetchLoggedInUserdetails();
    }
    
    private static String getEndPointParameters(String dealerId){
        //JSON Generator
        string username = UserInfo.getName();
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('UserName', username);
        gen.writeObjectField('DealerId', dealerId);
        gen.writeEndObject();
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    public class ErrorMessages {
        public String ErrorDescription;
    }
    public class eDealerPartListWrapper2{
        public Data Data;
        public ErrorResponse ErrorResponse;
    }
    
    public class CsrDataD {
        public String CompetitorName;
        public String Affiliation;
        public String CompType;
        public String CompCity;
        public String CompState;
        public String CompPostal;
        public String Confirmation;
        public String CompetitorCode;
    }
    
    public class Data {
        public List<CsrDataD> CsrDataD;
    }
    
    public class ErrorResponse {
        public String IsSuccess;
        public List<ErrorMessages> ErrorMessages;
    }    
}