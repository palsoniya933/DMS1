public with sharing class EDealerDraftCsrController {

        @AuraEnabled
        public static string getMyCSR(List<String> dealerCodeList) {
            Map<string, object> calloutDetails = new Map<string, object>();
            Map<String, String> header = new Map<String, String>();
            calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
            calloutDetails.put(
                'endpoint',
                '/dealerships/csr/quarter-to-date-report/kpi'
            );
            calloutDetails.put('headers', header);
            calloutDetails.put('method', 'POST');
            calloutDetails.put('isBase64Encoded', false);
    
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeObjectField('dealer_codes', dealerCodeList);
            gen.writeObjectField('status', new List<String>{'N'});
            gen.writeObjectField('frequency', new List<String>{'ALL'} );
            gen.writeObjectField('csrType', new List<String>{'B','C','W'} );
    
            gen.writeEndObject();
            // Get the JSON string.
            String JSONBody = gen.getAsString();
            system.debug('JSONBody: '+JSONBody);
            calloutDetails.put('body', JSONBody);
            calloutDetails.put('classname', 'EDealerActiveCsrController');
            String jsonString = EDealerHttpHandler.callout(calloutDetails);
            system.debug('Json String Value '+jsonString);
            if (jsonString != null) {
                return jsonString;
            } else {
                // MasterResponseWrapper res = (MasterResponseWrapper)System.JSON.deserialize(resultData, MasterResponseWrapper.class);
                //String eMsg = res.ErrorResponse.ErrorMessages[0].ErrorDescription;
                return 'error';
            }
        }
        
        //get translations for MyCSR(s) Tile
        @AuraEnabled(cacheable=true)
        public static CSRTile getMyCSRTileTranslations() {
            Map<String, String> csrTitle = getTranslationValuesByName(
                'CSRTitle',
                'eDealerMyCsrTile'
            );
            List<Map<String, String>> csrType = getListValuesByName(
                'CSRType',
                'eDealerMyCsrTile'
            );
            Map<String, String> helpText = getTranslationValuesByName(
                'HelpText',
                'eDealerMyCsrTile'
            );
            Map<String, String> errorMsg = getTranslationValuesByName(
                'ErrorMessage',
                'eDealerMyCsrTile'
            );
            return new CSRTile(csrType, csrTitle, null, helpText,errorMsg);
        }
     
        
        static List<Map<String, String>> getListValuesByName(
            String picklistName,
            String cmpName
        ) {
            List<Map<String, String>> options = new List<Map<String, String>>();
            Map<String, Object> csrTranslations = new Map<String, Object>();
            String userlang = UserInfo.getLanguage();
            if (cmpName == 'eDealerActiveCsrTile') {
                csrTranslations = EDealerMetadataUtility.csrTileTranslations;
            }
            else if (cmpName == 'eDealerMyCsrTile') {
                csrTranslations = EDealerMetadataUtility.myCSRTileTranslations;
            }
             else if (cmpName == 'eDealerCsrListing' || cmpName == 'eDealerDraftCsrListing') {
                csrTranslations = EDealerMetadataUtility.csrDrilldownTranslations;
            } else if (cmpName == 'eDealerPendingCsrTile') {
                csrTranslations = EDealerMetadataUtility.pendingCSRTileTranslations;
            }
            
            Object allLanguageTranslations = csrTranslations.get(picklistName);
            
            for (
                object picklistValuesWithAttributes : (List<Object>) allLanguageTranslations
            ) {
                Map<String, object> picklistAttributes = (Map<String, object>) picklistValuesWithAttributes;
                
                String picklistLabel = (String) picklistAttributes.get(
                    userlang
                );
                String picklistPickListfieldValue = (String) picklistAttributes.get('value');
                String picklistPickListfieldName = (String) picklistAttributes.get('fieldName');
                String picklistPickListType = (String) picklistAttributes.get('type');
                //String picklistPickListSortable = (String) picklistAttributes.get('sortable');
                
                Map<String, String> values = new Map<String, String>{
                    'label' => picklistLabel,
                        'fieldName' => picklistPickListfieldName,
                        'type' => picklistPickListType,
                        'value' => picklistPickListfieldValue
                        };
                            
                            options.add(values);
            }
            return options;
        }
        
        static Map<String, String> getTranslationValuesByName(
            String attributeName,
            String cmpName
        ) {
            Map<String, String> options = new Map<String, String>();
            Map<String, Object> csrTranslations = new Map<String, Object>();
            if (cmpName == 'eDealerActiveCsrTile') {
                csrTranslations = EDealerMetadataUtility.csrTileTranslations;
            } else if (cmpName == 'eDealerCsrListing' || cmpName == 'eDealerDraftCsrListing') {
                csrTranslations = EDealerMetadataUtility.csrDrilldownTranslations;
            } else if(cmpName == 'eDealerKPIContainer'){
                csrTranslations = EDealerMetadataUtility.csrDashboardTranslations;
            } else if (cmpName == 'eDealerMyCsrTile'){
                csrTranslations = EDealerMetadataUtility.myCSRTileTranslations; 
            } else if (cmpName == 'eDealerPendingCsrTile'){
                csrTranslations = EDealerMetadataUtility.pendingCSRTileTranslations;
            }
            Object allLanguageTranslations = csrTranslations.get(attributeName);
            Map<String, object> convertedAttributes = (Map<String, object>) allLanguageTranslations;
            String translationLabel = (String) convertedAttributes.get(
                UserInfo.getLanguage()
            );
            
            options.put('label', translationLabel);
            
            return options;
        }
        
        public class CSRTile {
            @AuraEnabled
            public List<Map<String, String>> csrType;
            @AuraEnabled
            public Map<String, String> csrTitle;
            @AuraEnabled
            public List<Map<String, String>> timeFilter;
            @AuraEnabled
            public Map<String, String> helpText;
            @AuraEnabled
            public Map<String, String> errorMsg;
            public CSRTile(
                List<Map<String, String>> csrType,
                Map<String, String> csrTitle,
                List<Map<String, String>> timeFilter,
                Map<String, String> helpText,
                Map<String,String> errorMsg
            ) {
                this.csrType = csrType;
                this.csrTitle = csrTitle;
                this.timeFilter = timeFilter;
                this.helpText = helpText;
                this.errorMsg = errorMsg;
            }
        }
     
    
}