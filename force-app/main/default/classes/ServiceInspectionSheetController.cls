public class ServiceInspectionSheetController {
    public static final String s3BucketName = System.Label.Loyalty_S3_Bucket_Name;
    
    @AuraEnabled
    public static List<Map<String, String>> fetchInspectionSheetList(String Language) {
        try {
            String response = retrieveFilesFromS3(Language);
            System.debug((response));
            return parseResponse(response);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String, Object> getCurrentLoggedInUserDetails() {
        User currentUser = [SELECT Id, Profile.Name, ASI_Username__c, Name,Dealer_Code__c,contactId
                            FROM User 
                            WHERE Id = :UserInfo.getUserId()
                            LIMIT 1];
        
        Map<String, Object> userDetails = new Map<String, Object>();
        
        if (currentUser != null) {
            userDetails.put('isDealerUser', currentUser.contactId != null);
            userDetails.put('dealerCode', currentUser.Dealer_Code__c);
        }
        
        return userDetails;
    }
    
    @AuraEnabled
    public static Boolean isLoyaltyInspectionSheetAdmin(){
        return FeatureManagement.checkPermission('Loyalty_Inspection_Sheet_Admin');
    }
    
    @AuraEnabled
    public static string storeFileToS3Bucket(String base64Data, String fileNameWithExtension, String fileId, String language){ 
        try{
            List<FileUploadRequestWrapper> fileUploadRequestWrapperList = new List<FileUploadRequestWrapper>
                                                                        {new FileUploadRequestWrapper(s3BucketName,
                                                                                                    base64Data,
                                                                                                    fileNameWithExtension,
                                                                                                    fileId,
                                                                                                    language)};
                Map<String,List<FileUploadRequestWrapper>> requestBody = new Map<String,List<FileUploadRequestWrapper>>{
                    'files' => fileUploadRequestWrapperList
                        };
                            Map<String, Object> calloutParams = new Map<String, Object>();
                            calloutParams.put('namedCredentials','callout:GatewayAWSConnection');
            calloutParams.put('endpoint', '/dealerships/loyalty/documents/add/kpi');
            calloutParams.put('method', 'POST');
            calloutParams.put('body', JSON.serialize(requestBody));
            calloutParams.put('classname', 'ServiceInspectionSheetController');
            return (EDealerHttpHandler.callout(calloutParams));
        }
        catch(Exception err){
            throw new AuraHandledException(err.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<String> fetchAllFileNamesFromS3Bucket(){
        String jsonResponse = retrieveFilesFromS3('All');
        System.debug('jsonResponse=>'+jsonResponse);
        List<String> filenames = new List<String>();
        Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        if (parsedResponse.containsKey('file_info') && parsedResponse.get('file_info') instanceof List<Object>) {
            List<Object> filesInfo = (List<Object>) parsedResponse.get('file_info');
            for (Object item : filesInfo) {
                if (item instanceof Map<String, Object>) {
                    Map<String, Object> fileInfo = (Map<String, Object>) item;
                    String filename = (String) fileInfo.get('filename');
                    if (filename != null) {
                        if(fileName.contains('.')){
                            filenames.add(fileName.substring(0, fileName.lastIndexOf('.')).toLowerCase());
                        }
                        else{
                            filenames.add(filename.toLowerCase()); 
                        }
                    }
                }
            }
        }
        return filenames;   
    }
    
    @AuraEnabled
    public static string deleteFileFromS3Bucket(String uniqueId){
        try {
            String returnMessage = '';
            Map<String,String> requestBody = new Map<String,String>{
                's3_bucket' => s3BucketName,
                    'unique_id' => uniqueId
                    };
                        Map<String, Object> calloutParams = new Map<String, Object>();
                        calloutParams.put('namedCredentials','callout:GatewayAWSConnection');
            calloutParams.put('endpoint', '/dealerships/loyalty/documents/delete/kpi');
            calloutParams.put('method', 'POST');
            calloutParams.put('body', JSON.serialize(requestBody));
            calloutParams.put('classname', 'ServiceInspectionSheetController');
            String response = EDealerHttpHandler.callout(calloutParams);
            System.debug('Response=>'+response);
            Map<String,Object> parseResponse = (Map<String,Object>) JSON.deserializeUntyped(response);
            if(parseResponse.containsKey('msg')){
                returnMessage = (String) parseResponse.get('msg');
            }
            return returnMessage;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static String retrieveFilesFromS3(String Language) {
        Map<String, Object> requestPayload = new Map<String, Object>();
        requestPayload.put('s3_bucket', s3BucketName);
        requestPayload.put('lang', Language);
        String payload = JSON.serialize(requestPayload);       
        Map<String, String> headers = new Map<String, String>();
        Map<String, Object> calloutParams = new Map<String, Object>();
        calloutParams.put('namedCredentials','callout:GatewayAWSConnection');
        calloutParams.put('endpoint', '/dealerships/loyalty/getLoyaltyDocs/kpi');
        calloutParams.put('method', 'POST');
        calloutParams.put('body', payload);
        calloutParams.put('classname', 'ServiceInspectionSheetController');
        return EDealerHttpHandler.callout(calloutParams);
    }
    
    public static List<Map<String, String>> parseResponse(String jsonResponse) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        System.debug('responseMap=>'+JSON.serializePretty(responseMap));
        if (responseMap.containsKey('file_info') && responseMap.get('file_info') instanceof List<Object>) {
            List<Object> rawFiles = (List<Object>) responseMap.get('file_info');
            List<Map<String, String>> parsedFiles = new List<Map<String, String>>();
            for (Object item : rawFiles) {
                if (item instanceof Map<String, Object>) {
                    Map<String, Object> fileDetails = (Map<String, Object>) item;
                    String fileName = (String) fileDetails.get('filename');
                    String fileUrl = (String) fileDetails.get('fileurl');
                    String id =(String) fileDetails.get('unique_id');
                    String baseFileName = '';
                    String fileExtension = '';
                    if (fileName.contains('.')) {
                        fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1);
                        baseFileName = fileName.substring(0, fileName.lastIndexOf('.'));
                    }
                    parsedFiles.add(new Map<String, String>{
                        'id' => id, 
                            'fileName' => baseFileName,
                            'extension' => fileExtension,
                            'downloadUrl' => fileUrl
                            });
                }
            }
            return parsedFiles;
        } else {
            throw createException('file_info is missing or not a list.');
        }
    }
    
    private static AuraHandledException createException(String message) {
        AuraHandledException exc = new AuraHandledException(message);
        exc.setMessage(message);
        return exc;
    }
    
    public class FileUploadRequestWrapper{
        public String s3_bucket;
        public String file_Base64;
        public String filename_extension;
        public String unique_id;
        public String lang;
        
        public FileUploadRequestWrapper(String s3_bucket, String file_Base64, String filename_extension, String unique_id, String lang){
            this.s3_bucket = s3_bucket;
            this.file_Base64 = file_Base64;
            this.filename_extension = filename_extension;
            this.unique_id = unique_id;
            this.lang = lang;
        }
    }
}