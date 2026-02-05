public class EDealerCsrFileUpload {
    @AuraEnabled
    public static void uploadFile(String jsonFileDetail,String csrNumber,Integer phase){
        FileWrapper fileWrap = new FileWrapper ();
        System.debug('---jjsonFileDetail--'+jsonFileDetail);
        List<FileDetailsWrapper> convertedFiles = new List<FileDetailsWrapper>();
        List<FileToDeleteWrapper> fileToDeleteWrapper = new List<FileToDeleteWrapper>();
        List<FileData> filesData = (List<FileData>)JSON.deserialize(jsonFileDetail, List<FileData>.class);
        for (FileData fileData : filesData) {
            if(fileData.isEditMode==false && fileData.isDeleted==false){
                FileDetailsWrapper fileDetail = new FileDetailsWrapper();
                fileDetail.s3_bucket = System.Label.eDealer_CSR_AWS_Bucket;
                fileDetail.DealerCode = fileData.dealerCode;
                fileDetail.Phase = phase;
                fileDetail.CSRNumber = csrNumber;
                fileDetail.file_Base64 = fileData.blobData;
                fileDetail.filename_extension = fileData.fileName;
                convertedFiles.add(fileDetail);  
            }else if(fileData.isEditMode==true && fileData.isDeleted==true){
                FileToDeleteWrapper fdelete=new FileToDeleteWrapper();
                fdelete.key=fileData.key;
                fdelete.s3_bucket=System.Label.eDealer_CSR_AWS_Bucket;
                fileToDeleteWrapper.add(fdelete);  
            }
        }
        fileWrap.files=convertedFiles;
        fileWrap.file_to_delete=fileToDeleteWrapper;
        System.debug('----fileWrap----'+fileWrap);
        System.debug('json--serialize-:::'+JSON.serialize(fileWrap));
        System.debug('convertedFiles:::'+JSON.serialize(convertedFiles));
        Map<String,object> calloutDetails = new Map<string,object>();             
        calloutDetails.put('endpoint','/dealerships/csr/add-attachements/kpi');
        calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',JSON.serialize(fileWrap));
        calloutDetails.put('classname','EDealerCsrFileUpload');        
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        System.debug('json--resultData-:::'+resultData); 
    }
    public class FileWrapper{
        public List<FileDetailsWrapper> files;
        public List<FileToDeleteWrapper> file_to_delete;       
    }
    public class FileData {
        public Integer fileId;
        public String fileName;
        public String dealerCode;
        public String filetype;
        public Integer fileSizeInBytes;
        public String formatedfileSize;
        public String blobData;
        public Boolean isEditMode;
        public Boolean isDeleted;
        public String key;
    }
    public class FileDetailsWrapper {
        public String s3_bucket;
        public String DealerCode;
        public Integer Phase;
        public String CSRNumber;
        public String file_Base64;
        public String filename_extension;
        
    }
    public class FileToDeleteWrapper {
        public String key;
        public String s3_bucket;
    } 
}