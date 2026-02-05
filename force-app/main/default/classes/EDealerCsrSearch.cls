public class EDealerCsrSearch {
   @AuraEnabled
    public static string getCSRbySearchKey(List<String> dealerCode, List<String> status,String searchText){
        
        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('dealerCodes', dealerCode);
        payloadMap.put('CSRNumber', searchText);
        payloadMap.put('statuses', status);
        
        // Serialize the map to a JSON string
        String requestGetRecordPayload = JSON.serialize(payloadMap);
        System.debug('Request Payload-->: ' + requestGetRecordPayload);
        Map<string,object> calloutDetails = new Map<string,object>();
        calloutDetails.put('endpoint','/csr/search/kpi');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',requestGetRecordPayload);
        calloutDetails.put('classname','eDealerCsrRecordDataController');   
        system.debug('Callout Details: '+calloutDetails);
        String resultData = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('resultData----'+resultData);
        if(resultData!= null) {
            system.debug('Result Data is edit mode '+resultData); 
            return resultData;
        } else if(resultData == null) {   
            return null;
            
        } else{
            System.debug('resultData error'+resultData);
            MasterEditDataWrapper res = (MasterEditDataWrapper)System.JSON.deserialize(resultData, MasterEditDataWrapper.class);
            String eMsg = res.ErrorResponse.ErrorMessages[0].Comments;
            return eMsg; 
        } 
    }
    
    public class MasterEditDataWrapper {
        public Data EditCsrData;
        public ErrorResponse ErrorResponse;
    }  
    
    public class CsrLines {
        public Integer LineNbr;
        public String Itmid;
        public String ItemDesc;
        public Double Quantity;
        public String ItemClass;
        public String Channel;
        public String LineStat;
        public String CompCode;
        public String CompName;
        public String CompPart;
        public Double Price;
        public List<HeaderCmts> LineCmts;
    }
    
    public class Data {
        public String DealerId;
        public String DealerSfx;
        public String CustomerName;
        public String CompType;
        public String CsrStat;
        public String CsrType;
        public String CsrUser;
        public String DlrType;
        public String Chassi;
        public String InsComp;
        public Double WriteOff;
        public Integer DlrDisc;
        public Integer DurBid;
        public String ExpMarkUp;
        public List<HeaderCmts> HeaderCmts;
        public List<CsrLines> CsrLines;
    }
    
    public class HeaderCmts {
        public string Comments;
    }
    
    public class ErrorResponse {
        public String IsSuccess;
        public Integer ErrorMessagesCount;
        public List<HeaderCmts> ErrorMessages;
    }
    
}