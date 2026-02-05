public class eDealerCreateCsrController {
 
    @AuraEnabled(cacheable=true)
    public static CSRHeaders getCSRHeaderTranslations(){          
        List<Map<String,String>> dealerType = getPickListValuesByPicklistName('DealerType');
        List<Map<String,String>> csrType = getPickListValuesByPicklistName('CSRType');
        List<Map<String,String>> competitveType = getPickListValuesByPicklistName('CompetitiveType');
        List<Map<String,String>> duration = getPickListValuesByPicklistName('DurationLabel');
        List<Map<String,String>> expectedMarkup = getPickListValuesByPicklistName('ExpectedMarkupLabel');
        List<Map<String,String>> durationValidationError = getPickListValuesByPicklistName('DurationValidationError');
        List<Map<String,String>> markupValidationError = getPickListValuesByPicklistName('MarkupValidationError');
        List<Map<String,String>> csrStatus = getPickListValuesByPicklistName('StatusField');
        List<Map<String,String>> csrNumber = getPickListValuesByPicklistName('CSRNumber');
        List<Map<String,String>> csrPhase = getPickListValuesByPicklistName('CSRPhase');
        List<Map<String,String>> upload = getPickListValuesByPicklistName('Upload');
        List<Map<String,String>> fileUpload = getPickListValuesByPicklistName('FileUpload');
        List<Map<String,String>> excelFileAllowed = getPickListValuesByPicklistName('ExcelFileAllowed');//DuplicateWithSR
        List<Map<String,String>> excelFileAccepted = getPickListValuesByPicklistName('ExcelFileAccepted');
        List<Map<String,String>> duplicateWithSR = getPickListValuesByPicklistName('DuplicateWithSR');
        List<Map<String,String>> invalidPartNumber = getPickListValuesByPicklistName('InvalidPartNumber');
        List<Map<String,String>> authorizationComments = getPickListValuesByPicklistName('AuthorizationComments');
        List<Map<String,String>> dealerComments = getPickListValuesByPicklistName('DealerComments');
        List<Map<String,String>> miscComments = getPickListValuesByPicklistName('MiscComments');
        List<Map<String,String>> quotecomments = getPickListValuesByPicklistName('Quotecomments');
        List<Map<String,String>> letterTopParagraphComments = getPickListValuesByPicklistName('LetterTopParagraphComments');
        List<Map<String,String>> letterBottomParagraphComments = getPickListValuesByPicklistName('LetterBottomParagraphComments');
        List<Map<String,String>> unknownCommentType = getPickListValuesByPicklistName('UnknownCommentType');
        List<Map<String,String>> Filesizecannotexceed3MBTotalfilesize = getPickListValuesByPicklistName('File(s)sizecannotexceed3MB.Totalfilesize');
        List<Map<String,String>> Filesizecannotexceed3MBSelectedfilesize = getPickListValuesByPicklistName('Filesizecannotexceed3MB.Selectedfilesize');
        List<Map<String,String>> OnlyPDFandimagefilesareallowed = getPickListValuesByPicklistName('OnlyPDFandimagefilesareallowed.');
        List<Map<String,String>> FilehasexceededtheuploadlimitUploadedfile3 = getPickListValuesByPicklistName('Filehasexceededtheuploadlimit.Uploadedfile:3.');
        List<Map<String,String>> Alluploadedfilesizecannotexceed3MB = getPickListValuesByPicklistName('Alluploadedfilesizecannotexceed3MB.');
        List<Map<String,String>> YourCSRisCancelled = getPickListValuesByPicklistName('YourCSRisCancelled!');
        List<Map<String,String>> CSRisNotAvailable = getPickListValuesByPicklistName('CSRisNotAvailable');
        List<Map<String,String>> CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated = getPickListValuesByPicklistName('CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated');
        AddCompetitorAddress addCompetitorAddress= new AddCompetitorAddress();
        addCompetitorAddress.Citycanotexceed20characters = getPickListValuesByPicklistName('Citycanotexceed20characters');        
        addCompetitorAddress.Postalcodecanotexceed10characters = getPickListValuesByPicklistName('Postalcodecanotexceed10characters');        
        addCompetitorAddress.StateProvincecanotexceed20characters = getPickListValuesByPicklistName('StateProvincecanotexceed20characters');        
        addCompetitorAddress.Countrycanotexceed30characters = getPickListValuesByPicklistName('Countrycanotexceed30characters');        
        addCompetitorAddress.EDealerExpectedMarkupErrorMessage = getPickListValuesByPicklistName('EDealerExpectedMarkupErrorMessage');        
        addCompetitorAddress.PartNumbershouldnotbe18characters = getPickListValuesByPicklistName('PartNumbershouldnotbe18characters'); 
        return new CSRHeaders(dealerType,csrType,competitveType,duration,expectedMarkup,durationValidationError,markupValidationError,csrStatus,csrNumber,csrPhase,upload,fileUpload,excelFileAllowed,excelFileAccepted,duplicateWithSR,invalidPartNumber,authorizationComments,dealerComments,
        miscComments,quotecomments,letterTopParagraphComments,letterBottomParagraphComments,unknownCommentType,CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated,
        Filesizecannotexceed3MBTotalfilesize,Filesizecannotexceed3MBSelectedfilesize,OnlyPDFandimagefilesareallowed,
        FilehasexceededtheuploadlimitUploadedfile3,Alluploadedfilesizecannotexceed3MB,YourCSRisCancelled,CSRisNotAvailable,
        addCompetitorAddress);
    }

  static List<Map<String,String>> getCreateCsrValuesByName(String name){
        List <Map<String,String>> options = new List<Map<String,String>>();
        
        Map<String,Object> csrHeaderTranslations = EDealerMetadataUtility.csrHeaderTranslations;
        
        Object allLanguageTranslations = csrHeaderTranslations.get(name);   
        
        for(object picklistValuesWithAttributes : (List<Object>) allLanguageTranslations){
            Map<String,object> picklistAttributes = (Map<String,object>) picklistValuesWithAttributes;
            
            String picklistLabel = (String) picklistAttributes.get(UserInfo.getLanguage());
            String picklistPickListValue = (String) picklistAttributes.get('value');
            
            Map <String, String> values = new Map < String, String > {
                'label' => picklistLabel,
                'value' => picklistPickListValue
            };
            options.add(values);            
        }		
        return options;   
    }    
    static List<Map<String,String>> getPickListValuesByPicklistName(String picklistName){
        List <Map<String,String>> options = new List<Map<String,String>>();
        
        Map<String,Object> csrHeaderTranslations = EDealerMetadataUtility.csrHeaderTranslations;
        
        Object allLanguageTranslations = csrHeaderTranslations.get(picklistName);   
        
        for(object picklistValuesWithAttributes : (List<Object>) allLanguageTranslations){
            Map<String,object> picklistAttributes = (Map<String,object>) picklistValuesWithAttributes;
            
            String picklistLabel = (String) picklistAttributes.get(UserInfo.getLanguage());
            String picklistPickListValue = (String) picklistAttributes.get('value');
            
            Map <String, String> values = new Map < String, String > {
                'label' => picklistLabel,
                'value' => picklistPickListValue
            };
            options.add(values);            
        }		
        return options;   
    }
    
    public class CSRHeaders{
        @AuraEnabled public List<Map<String,String>> dealerTypePicklist;
        @AuraEnabled public List<Map<String,String>> csrTypePicklist;
        @AuraEnabled public List<Map<String,String>> competitveTypePicklist;
        @AuraEnabled public List<Map<String,String>> duration;
        @AuraEnabled public List<Map<String,String>> expectedMarkup;
        @AuraEnabled public List<Map<String,String>> durationValidationError;
        @AuraEnabled public List<Map<String,String>> markupValidationError;
        @AuraEnabled public List<Map<String,String>> csrStatus;
        @AuraEnabled public List<Map<String,String>> csrNumber;
        @AuraEnabled public List<Map<String,String>> csrPhase;
        @AuraEnabled public List<Map<String,String>> upload;
        @AuraEnabled public List<Map<String,String>> fileUpload;
        @AuraEnabled public List<Map<String,String>> excelFileAllowed;
        @AuraEnabled public List<Map<String,String>> excelFileAccepted;
        @AuraEnabled public List<Map<String,String>> duplicateWithSR;
        @AuraEnabled public List<Map<String,String>> invalidPartNumber;
        @AuraEnabled public List<Map<String,String>> authorizationComments;
        @AuraEnabled public List<Map<String,String>> dealerComments;
        @AuraEnabled public List<Map<String,String>> miscComments;
        @AuraEnabled public List<Map<String,String>> quotecomments;
        @AuraEnabled public List<Map<String,String>> letterTopParagraphComments;
        @AuraEnabled public List<Map<String,String>> letterBottomParagraphComments;
        @AuraEnabled public List<Map<String,String>> unknownCommentType;
        @AuraEnabled public List<Map<String,String>> Filesizecannotexceed3MBTotalfilesize;
        @AuraEnabled public List<Map<String,String>> Filesizecannotexceed3MBSelectedfilesize;
        @AuraEnabled public List<Map<String,String>> OnlyPDFandimagefilesareallowed;
        @AuraEnabled public List<Map<String,String>> FilehasexceededtheuploadlimitUploadedfile3;
        @AuraEnabled public List<Map<String,String>> Alluploadedfilesizecannotexceed3MB;
        @AuraEnabled public List<Map<String,String>> YourCSRisCancelled;
        @AuraEnabled public List<Map<String,String>> CSRisNotAvailable;
        @AuraEnabled public List<Map<String,String>> CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated;
        @AuraEnabled public AddCompetitorAddress addCompetitorAddress;
        public CSRHeaders(List<Map<String,String>> dealerTypePicklist,List<Map<String,String>> csrTypePicklist,List<Map<String,String>> competitveTypePicklist,List<Map<String,String>> durationList ,List<Map<String,String>> expectedMarkupList,List<Map<String,String>> durationValidationErrorList,List<Map<String,String>> markupValidationErrorList,List<Map<String,String>> csrStatusList,List<Map<String,String>> csrNumberList,List<Map<String,String>> csrPhaseList,
        List<Map<String,String>> upload,List<Map<String,String>> fileUpload,List<Map<String,String>> excelFileAllowed,List<Map<String,String>> excelFileAccepted,List<Map<String,String>> duplicateWithSR,List<Map<String,String>> invalidPartNumber,
        List<Map<String,String>> authorizationComments,List<Map<String,String>> dealerComments,List<Map<String,String>> miscComments,
        List<Map<String,String>> quotecomments,List<Map<String,String>> letterTopParagraphComments,List<Map<String,String>> letterBottomParagraphComments,List<Map<String,String>> unknownCommentType,
        List<Map<String,String>> CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated, List<Map<String,String>> Filesizecannotexceed3MBTotalfilesize,List<Map<String,String>> Filesizecannotexceed3MBSelectedfilesize,List<Map<String,String>> OnlyPDFandimagefilesareallowed,
        List<Map<String,String>> FilehasexceededtheuploadlimitUploadedfile3,List<Map<String,String>> Alluploadedfilesizecannotexceed3MB,List<Map<String,String>> YourCSRisCancelled,
        List<Map<String,String>> CSRisNotAvailable,AddCompetitorAddress addCompetitorAddress){
            this.dealerTypePicklist = dealerTypePicklist;
            this.csrTypePicklist = csrTypePicklist;
            this.competitveTypePicklist = competitveTypePicklist;
            this.duration = durationList;
            this.expectedMarkup = expectedMarkupList;
            this.durationValidationError = durationValidationErrorList;
            this.markupValidationError = markupValidationErrorList;
            this.csrStatus = csrStatusList;
            this.csrNumber = csrNumberList;
            this.csrPhase = csrPhaseList;
            this.upload = upload;
            this.fileUpload = fileUpload;
            this.excelFileAllowed = excelFileAllowed;
            this.excelFileAccepted = excelFileAccepted;
            this.duplicateWithSR = duplicateWithSR;
            this.invalidPartNumber=invalidPartNumber;
            this.authorizationComments=authorizationComments;
            this.dealerComments=dealerComments;
            this.miscComments=miscComments;
            this.quotecomments=quotecomments;
            this.letterTopParagraphComments=letterTopParagraphComments;
            this.letterBottomParagraphComments=letterBottomParagraphComments;
            this.unknownCommentType=unknownCommentType;
            this.Filesizecannotexceed3MBTotalfilesize=Filesizecannotexceed3MBTotalfilesize;
            this.Filesizecannotexceed3MBSelectedfilesize=Filesizecannotexceed3MBSelectedfilesize;
            this.OnlyPDFandimagefilesareallowed=OnlyPDFandimagefilesareallowed;
            this.FilehasexceededtheuploadlimitUploadedfile3=FilehasexceededtheuploadlimitUploadedfile3;
            this.Alluploadedfilesizecannotexceed3MB=Alluploadedfilesizecannotexceed3MB;
            this.YourCSRisCancelled=YourCSRisCancelled;
            this.CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated=CommentscannotbeaddedtotheCSRuntilaCSRnumberhasbeengenerated;
            this.CSRisNotAvailable = CSRisNotAvailable;
            this.addCompetitorAddress= addCompetitorAddress;
        }
    }
 public class AddCompetitorAddress{
   @AuraEnabled public List<Map<String,String>> Citycanotexceed20characters;
        @AuraEnabled public List<Map<String,String>> Countrycanotexceed30characters;
        @AuraEnabled public List<Map<String,String>> StateProvincecanotexceed20characters;
        @AuraEnabled public List<Map<String,String>> Postalcodecanotexceed10characters;
        @AuraEnabled public List<Map<String,String>> EDealerExpectedMarkupErrorMessage;
        @AuraEnabled public List<Map<String,String>> PartNumbershouldnotbe18characters;

 }
    
}