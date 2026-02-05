public with sharing class eDealerCSRViewFilesController {

        @AuraEnabled
        public static String getCsrFilesFromAws( String Dealercode, String csrNumber, String csrPhase) {
            System.debug('\n----csrNumber--' + csrNumber);
            System.debug('\n----csrPhase--' + csrPhase);
            String JSONBody = getEndPointParameters(Dealercode,csrNumber, csrPhase);
            System.debug('\n----JSONBody--' + JSONBody);
    
            Map<String,Object> calloutDetails = new Map<String,Object>();
            calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
            calloutDetails.put(
                'endpoint',
                '/dealerships/csr/get-attachements/kpi'
            );
            calloutDetails.put('method', 'POST');
            calloutDetails.put('body', JSONBody);
            calloutDetails.put('classname','eDealerCSRViewFilesController');
            String responseData = EDealerHttpHandler.callout(calloutDetails);
            
           
            System.debug('\n----responseData--' + responseData);
            // string mockresponse = '{"file_info": [{"Key": "CsrFiles/F302/3245675/1/t2.pdf","Size": 34779},{"Key": "CsrFiles/F302/3245675/1/t3.pdf","Size": 34779},{"Key": "CsrFiles/F302/3245675/1/t4.pdf","Size": 34779}]}';
            // responseData = mockresponse;

            if(responseData != null) {
                 return responseData;
               
            }
            else {
                return 'No Data Found';
            }
        }
         @AuraEnabled
        public static String getCsrLettersFromAws( String Dealercode, String csrNumber, String csrPhase) {
            System.debug('\n----csrNumber--' + csrNumber);
            System.debug('\n----csrPhase--' + csrPhase);
            String JSONBody = getEndPointParameters(Dealercode,csrNumber, csrPhase);
            System.debug('\n----JSONBody--' + JSONBody);
    
            Map<String,Object> calloutDetails = new Map<String,Object>();
            calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
            calloutDetails.put(
                'endpoint',
                '/dealerships/csr/get-letter-from-s3/url'
            );
            calloutDetails.put('method', 'POST');
            calloutDetails.put('body', JSONBody);
            calloutDetails.put('classname','eDealerCSRViewFilesController');
            String responseData = EDealerHttpHandler.callout(calloutDetails);
            
           
            System.debug('\n----responseData--' + responseData);

            if(responseData != null) {
                 return responseData;
               
            }
            else {
                return 'No Data Found';
            }
        }
        private static String getEndPointParameters(String Dealercode,String csrNumber, String csrPhase) {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            string s3_bucket = eDealer_Config__mdt.getInstance('eDealer_Files_s3_Bucket').Long_Value__c;
            gen.writeObjectField('s3_bucket', s3_bucket);
            gen.writeObjectField('DealerCode', Dealercode);
            gen.writeObjectField('CSRNumber', csrNumber);
            gen.writeObjectField('Phase', Integer.valueOf(csrPhase));
            gen.writeEndObject();
            return gen.getAsString();
        }
       
        @AuraEnabled(cacheable=true)
        public static List <Map<String,String>> getFilesColumnHeaders(){
            return EDealerMetadataUtility.tableColumnHeaderTranslations('View_Files');
        }
    
}