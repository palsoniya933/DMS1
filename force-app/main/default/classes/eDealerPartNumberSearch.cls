public class eDealerPartNumberSearch {

    @AuraEnabled
    public static String getPartNumberbySearchKey(List<String> dealerCode, List<String> status, String searchText, Integer download, String frequency, List<String> csrType) {
    
        try {
            Map<String, Object> payload = new Map<String, Object>();
            payload.put('dealerCodes', dealerCode);
            payload.put('status', new List<String>());
            payload.put('csrType', new List<String>());
            payload.put('frequency', 'all');
            payload.put('partNumber', searchText);
            payload.put('download', download);

            String jsonPayload = JSON.serialize(payload);
            System.debug('Serialized Request Payload: ' + jsonPayload);

            Map<String,Object> calloutDetails = new Map<String,Object>();
            calloutDetails.put('endpoint','/csr/Look_up_by_part/kpi');
            calloutDetails.put('method','POST');
            calloutDetails.put('body',jsonPayload);
            calloutDetails.put('classname','eDealerPartNumberSearch');   
            System.debug('Callout Details: '+calloutDetails);
            
            String resultData = EDealerHttpHandler.callout(calloutDetails); 
        	System.debug('resultData: '+resultData);
            
            
            if (resultData != null) {
                return resultData;
            } else {
                return '{"error": "No response received from the part number lookup service."}';
            }

        } catch (Exception e) {
            System.debug('Callout Exception: ' + e.getMessage());
            return '{"error": "' + e.getMessage() + '"}';
        }
    }

    @AuraEnabled
    public static List <Map<String,String>> getPartsColumnHeaders(){
        return EDealerMetadataUtility.tableColumnHeaderTranslations('eDealerPartNumberSearch');
    }

    public class PartNumberResponseWrapper {
        public List<PartNumberRecord> response;
    }

    public class PartNumberRecord {
        public String dealercode;
        public String dealertype;
        public Long csrnumber;
        public Integer phase;
        public String csrtype;
        public String csr_description;
        public String createdby;
        public String expiration_date; 
        public String last_updatedby;
        public String last_updated_at;
        public String status;
        public String cmttype;
        public String hascomments;
        public String hasfiles;
    }
}