/*** 
Name        : eDealerPricingFilesDaily
Description : This is an apex class that extracts list of URL links from AWS S3 bucket for the current year and month.
			- called by eDealerPricingFilesDaily aura component which displays results on the Gateway UI (Daily)
			- expected file URL links for : Price, Part Attribute, Demand
Version History:
1.0	vivian.mirador@paccar.com 12/13/2023 - Initial Version
***/

public class eDealerPricingFilesDaily {
    
    @AuraEnabled
    public static List<PricingFileDetails> fetchDailyPriceFilesURLs(String dealerCode, String year, String month){
        
        List<PricingFileDetails> pricingFileDetails = new List<PricingFileDetails>();
        string jsonResponse ='';
        
        try{
            String JsonData = '';
            string bucket=System.Label.eDealer_Price_File_s3Bucket; //ppd.dev.paricefile.bucket'
            String Frequency=System.Label.eDealer_Price_File_Frequency_Daily; //'Daily'
            String PrefixStmt = ('Custom/Dealer/'+Frequency+'/'+dealerCode+'/'+year+'/'+month+'/');
            String filetype = System.Label.eDealer_Price_File_filetype_daily; //'daily'
            System.debug('PrefixStmt - '+PrefixStmt);
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('s3Bucket',bucket);
            gen.writeStringField('Prefix',PrefixStmt);
            gen.writeStringField('filetype',filetype);
            gen.writeEndObject();
            JsonData = gen.getAsString();
            System.debug('Json data '+JsonData);
            
            Http http = new Http();
            HttpResponse response = new HttpResponse();
            HttpRequest request = new HttpRequest();
            //request.setEndpoint('callout:AWSPriceFileModernization'+'/Stage/GetPriceFileDetails/');  CERT endpoint
            request.setEndpoint('callout:AWSPriceFileModernization');
            request.setMethod('POST');
            request.setBody(JSONData);
            response = http.send(request);
            
            // parsing the actual results
            if(response.getStatus().equalsIgnoreCase('OK')) {
                jsonResponse = response.getbody();    
                System.debug('jsonResponse - '+jsonResponse);
                
                UrlLinkWrapper resp = UrlLinkWrapper.parse(jsonResponse);
                for(UrlLinkWrapper.Urls res : resp.Urls){
                    PricingFileDetails priceFileDetails = new PricingFileDetails(res.Fileurl);
                    system.debug('\n--priceFileDetails--'+priceFileDetails);
                    pricingFileDetails.add(priceFileDetails);
                }
            }
        }
        catch(Exception Ex){
            system.debug('\n--error--'+Ex.getMessage()+ex.getStackTraceString());
        }
        
        System.debug('RETURN - pricingFileDetails '+ pricingFileDetails);
        pricingFileDetails.sort();
        return pricingFileDetails;
    }
    
    public class PricingFileDetails implements Comparable{
        @AuraEnabled public String fileName;
        @AuraEnabled public String fileURL;
        @AuraEnabled public String fileMonth;
        @AuraEnabled public String fileYear;
        public Date fileDate;
        
        public PricingFileDetails(){
            // default Constructor
        }
        public PricingFileDetails(String fileURL){
            this.fileURL = fileURL;
            if(fileURL != null && String.isNotBlank(fileURL)){
                List<String> fileURLParts = fileURL.split('\\?');
                system.debug('\n--fileURLParts--'+fileURLParts);
                
                if(fileURLParts != null 
                   && !fileURLParts.isEmpty()
                   && fileURLParts.size() > 1){
                       String urlWhichHaveFileDetails = fileURLParts[0];
                       List<String> fileDetails = urlWhichHaveFileDetails.split('/');
                       system.debug('\n--fileDetails--'+fileDetails);
                       
                       // getting file name / month from the the above list
                       if(fileDetails != null 
                          && !fileDetails.isEmpty()
                          && fileDetails.size() > 1){
                              this.fileName = fileDetails[fileDetails.size()-1];
                              this.fileMonth = fileDetails[fileDetails.size()-2];
                              this.fileYear = fileDetails[fileDetails.size()-3];
                              
                              system.debug('\n--fileName--'+fileName);
                              system.debug('\n--fileMonth--'+fileMonth);
                              system.debug('\n--fileYear--'+fileYear);
                          }
                   }
            }
            if(this.fileYear != null
               && this.fileMonth != null
               && String.isNotBlank(this.fileMonth)
               && String.isNotBlank(this.fileYear)){
                   this.fileDate = 
                       Date.newInstance(integer.valueOf(this.fileYear), integer.valueOf(this.fileMonth), 1);
               }            
        }
        
        public Integer compareTo(Object compareTo) {
            PricingFileDetails compareToRec = (PricingFileDetails)compareTo;
            if (this.fileDate > compareToRec.fileDate) {
                return -1;
            } else if (this.fileDate < compareToRec.fileDate) {
                return 1;
            } else {
                // First value the same, consider second value
                if (this.fileName > compareToRec.fileName) {
                    return -1;
                } else if (this.fileName < compareToRec.fileName) {
                    return 1;
                } else {
                    return 0;
                }          
            }     
        }    
    }
}