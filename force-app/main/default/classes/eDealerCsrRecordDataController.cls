public class eDealerCsrRecordDataController {
    // This method use to Edit CSR
    @AuraEnabled
    public static string getCSRDetails(String csrNumber, integer csrPhase,String dealerCode){
        
            system.debug('CsrNumber '+csrNumber);
            system.debug('Phase '+csrPhase);
            Map<String, String> mapOfEditCSR = new Map<String, String>();
            mapOfEditCSR.put('CSRNumber',csrNumber);
            mapOfEditCSR.put('Phase',String.valueOf(csrPhase));
            mapOfEditCSR.put('Dealerid',dealerCode);
            String requestGetRecordPayload = JSON.serialize(mapOfEditCSR);
            System.debug('Request Payload-->: '+requestGetRecordPayload);
            Map<string,object> calloutDetails = new Map<string,object>();
            calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWGetCSRRecord');
            calloutDetails.put('namedCredentials','callout:GatewayApplication');
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
    
    @AuraEnabled
    public static string getFilesByCSRNumberAndPhase(String csrNumber, String csrPhase,String dealerCode){
        system.debug('CsrNumber '+csrNumber);
        system.debug('Phase '+csrPhase); 
        String getFilesRequestPayload = makeFilesRequestPayload(csrNumber, csrPhase,dealerCode);
        System.debug('Request Payload: '+getFilesRequestPayload);
        Map<string,object> calloutDetails = new Map<string,object>();
        calloutDetails.put('endpoint','/dealerships/csr/get-attachements/kpi');
        calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',getFilesRequestPayload);
        calloutDetails.put('classname','eDealerCsrRecordDataController');   
        system.debug('Callout Details: '+calloutDetails);
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        System.debug('file resultData::'+resultData); 
        System.debug('resultData::'+resultData);
        if(resultData!= null) {
            system.debug('Result Data is on edit'+resultData); 
            return resultData;
        } else {   
            // MasterEditDataWrapper res = (MasterEditDataWrapper)System.JSON.deserialize(resultData, MasterEditDataWrapper.class);
            //String eMsg = res.ErrorResponse.ErrorMessages[0].Comments;
            return null; 
        }    
    } 
    
    private static String makeFilesRequestPayload(String csrNumber, String csrPhase,String dealerCode){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeObjectField('CSRNumber', csrNumber);
        gen.writeObjectField('Phase', Integer.valueOf(csrPhase));
        gen.writeObjectField('DealerCode', dealerCode);
        gen.writeObjectField('s3_bucket', System.Label.eDealer_CSR_AWS_Bucket);
        gen.writeEndObject();
        return gen.getAsString();
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