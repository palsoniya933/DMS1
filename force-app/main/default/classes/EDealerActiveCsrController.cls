public with sharing class EDealerActiveCsrController {
    //CSR listing methods
    @AuraEnabled
    public static string getActiveCSRList(List<String> dealerCodeList,String frequency,String csrtype) {
        // Construct the request body JSON
        Map<String,String> frequencyMap = new Map<String,String>();
        
        Map<String, Object> requestBodyMap = new Map<String, Object>();        
        requestBodyMap.put('frequency', frequency); 
        requestBodyMap.put('dealerCodes', dealerCodeList);
        if(csrtype == 'Posted'){
            requestBodyMap.put('status', new List<String>{'P'});  

        }
        else if(csrtype == 'Denied'){
            requestBodyMap.put('status', new List<String>{'R'});  

        }
        else{
            requestBodyMap.put('status', new List<String>{'P','R'});  

        }
        requestBodyMap.put('csrType', new List<String>{'W','B','C'});        
      
        String requestBody = JSON.serialize(requestBodyMap);
        system.debug(requestBody);
        Map<String, String> header = new Map<String, String>();
        Map<string, object> calloutDetails = new Map<string, object>();
        calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
        calloutDetails.put(
            'endpoint',
            '/dealerships/csr/quarter-to-date-listing/kpi'
        );
        calloutDetails.put('headers', header);
        calloutDetails.put('method', 'POST');
        calloutDetails.put('body', requestBody);
        calloutDetails.put('classname', 'EDealerActiveCsrController');
        String jsonString = EDealerHttpHandler.callout(calloutDetails);
        system.debug('Json String Value '+jsonString);
         
        return jsonString;
    }
    
    @AuraEnabled
    public static string getDraftCsrList(List<String> dealerCodeList, String frequency){
        
        // Construct the request body JSON
        Map<String, Object> requestBodyMap = new Map<String, Object>();        
        requestBodyMap.put('frequency', frequency); 
        requestBodyMap.put('dealerCodes', dealerCodeList);
        requestBodyMap.put('status', new List<String>{'N'});    
        requestBodyMap.put('csrType', new List<String>{'W','B','C'});        
    
        String requestBody = JSON.serialize(requestBodyMap);
        system.debug(requestBody);

        Map<String, String> header = new Map<String, String>();
        Map<string, object> calloutDetails = new Map<string, object>();
        calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
        calloutDetails.put(
            'endpoint',
            '/dealerships/csr/quarter-to-date-listing/kpi'
        );
        calloutDetails.put('headers', header);
        calloutDetails.put('method', 'POST');
        calloutDetails.put('body', requestBody);
        calloutDetails.put('classname', 'EDealerActiveCsrController');
        String jsonString = EDealerHttpHandler.callout(calloutDetails);
        system.debug('Json String Value '+jsonString);
        
      
        return jsonString;
    }
    @AuraEnabled
    public static string getPendingCsrList(List<String> dealerCodeList,String frequency,String csrtype){
       // Construct the request body JSON
       Map<String, Object> requestBodyMap = new Map<String, Object>();        
       requestBodyMap.put('frequency', frequency); 
       requestBodyMap.put('dealerCodes', dealerCodeList);
       if(csrtype == 'Process'){
        requestBodyMap.put('status', new List<String>{'D','M','S','U','A','X','I'});    

        }
        else if(csrtype == 'Waiting'){
            requestBodyMap.put('status', new List<String>{'W'});  

        }
        else{
            requestBodyMap.put('status', new List<String>{'D','M','S','U','W','A','X','I'});    

        }
       requestBodyMap.put('csrType', new List<String>{'W','B','C'});        
   
       String requestBody = JSON.serialize(requestBodyMap);
       system.debug(requestBody);

       Map<String, String> header = new Map<String, String>();
       Map<string, object> calloutDetails = new Map<string, object>();
       calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
       calloutDetails.put(
           'endpoint',
           '/dealerships/csr/quarter-to-date-listing/kpi'
       );
       calloutDetails.put('headers', header);
       calloutDetails.put('method', 'POST');
       calloutDetails.put('body', requestBody);
       calloutDetails.put('classname', 'EDealerActiveCsrController');
       String jsonString = EDealerHttpHandler.callout(calloutDetails);
       system.debug('Json String Value '+jsonString);
       
     
      
        return jsonString;
    }
    @AuraEnabled
    public static string renewCSR(Integer csrNumber, Integer csrPhase, String dealerId){   //modified to add dealerId, Chito 05-01-2024
        Map<string,object> calloutDetails = new Map<string,object>();
           //  
        //Map<String, Integer> params = new Map<String, Integer>();       //added 05-01-2024 start
        //params.put('CSRNumber',csrNumber);                              //
        //params.put('Phase', csrPhase);                                  //
        String strcsrNumber = String.valueOf(csrNumber);                  //
        String strPhase = String.valueOf(csrPhase);                       //
        Map<String, String> params = new Map<String, String>();           //
        params.put('CSRNumber',strcsrNumber);                             //
        params.put('Phase',strPhase);                                     // 
        params.put('Dealerid',dealerId);                                  //added 05-01-2024 end
        
        String jsonBody = JSON.serialize(params);
        Map<String, String> header = new Map<String, String>();
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWCSRRenewal');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('headers', header);
        calloutDetails.put('method','POST');
        calloutDetails.put('body',jsonBody);
        calloutDetails.put('classname', 'EDealerActiveCsrController');
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        return resultData;
    }
    @AuraEnabled
    public static string getCSRsWithFiles(List<String> dealerCodeList){
        system.debug('execute getCSRsWithFiles');
        string s3_bucket = eDealer_Config__mdt.getInstance('eDealer_Files_s3_Bucket').Long_Value__c;

        Map<string,object> calloutDetails = new Map<string,object>();
        
        Map<String, Object> params = new Map<String, Object>();
        params.put('DealerCodes',dealerCodeList);
        params.put('s3_bucket', s3_bucket);
        String jsonBody = JSON.serialize(params);
        Map<String, String> header = new Map<String, String>();
        calloutDetails.put('endpoint','/dealerships/csr/HasCsrFilesListing/kpi');
        calloutDetails.put('namedCredentials','callout:GatewayAWSConnection');
        calloutDetails.put('headers', header);
        calloutDetails.put('method','POST');
        calloutDetails.put('body',jsonBody);
        calloutDetails.put('classname', 'EDealerActiveCsrController');
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        system.debug(resultData);
        return resultData;
    }
    //CSR Tile Methods
    @AuraEnabled
    public static string getActiveCSR(List<String> dealerCodeList,String selectedCsrType, string frequency) {
       system.debug('getActiveCSR tile values');
        Map<string, object> calloutDetails = new Map<string, object>();
        //String JSONBody = getEndPointParameters(dealerCodeList);
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
        if(selectedCsrType == 'P'){
            gen.writeObjectField('status', new List<String>{selectedCsrType});

        }
        else if(selectedCsrType == 'R'){
            gen.writeObjectField('status', new List<String>{selectedCsrType});

        }
        else{
            gen.writeObjectField('status', new List<String>{'P','R'});

        }
        gen.writeObjectField('csrType', new List<String>{'B','C','W'} );

        gen.writeObjectField('frequency', new List<String>{frequency} );
        gen.writeEndObject();
        // Get the JSON string.
        String JSONBody = gen.getAsString();
        
        calloutDetails.put('body', JSONBody);
        calloutDetails.put('classname', 'EDealerActiveCsrController');
        system.debug('getActiveCSR request built: '+ JSONBody);
        //String jsonString ='{"ALL":{"P":10 , "R":5}}';
        String jsonString = EDealerHttpHandler.callout(calloutDetails);
        system.debug('Json String Response Value '+jsonString);
        if (jsonString != null) {
            system.debug('Json String Response Value '+jsonString);

            return jsonString;
            
        } else {
            // MasterResponseWrapper res = (MasterResponseWrapper)System.JSON.deserialize(resultData, MasterResponseWrapper.class);
            //String eMsg = res.ErrorResponse.ErrorMessages[0].ErrorDescription;
            return 'error';
        }
    }
    @AuraEnabled
    public static string getMyCSR(List<String> dealerCodeList) {
        Map<string, object> calloutDetails = new Map<string, object>();
        //String JSONBody = getEndPointParameters(dealerCodeList);
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
    @AuraEnabled
    public static string getPendingCSR(List<String> dealerCodeList) {
        Map<string, object> calloutDetails = new Map<string, object>();
        //String JSONBody = getEndPointParameters(dealerCodeList);
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

        gen.writeObjectField('status', new List<String>{'S','D','M','U','A','X','I','W'});
        gen.writeObjectField('csrType', new List<String>{'B','C','W'} );

       
        gen.writeObjectField('frequency', new List<String>{'ALL'} );
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
    //get CSR detail and parts
    @AuraEnabled
    public static string getCSRDetails(Integer csrNumber, Integer csrPhase){
        
        Map<string,object> calloutDetails = new Map<string,object>();
        
        Map<String, Integer> params = new Map<String, Integer>();
        params.put('CSRNumber',csrNumber);
        params.put('Phase', csrPhase);
        String jsonBody = JSON.serialize(params);
        Map<String, String> header = new Map<String, String>();
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GetCSRRecord');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('headers', header);
        calloutDetails.put('method','POST');
        calloutDetails.put('body',jsonBody);
        calloutDetails.put('classname', 'EDealerActiveCsrController');
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        return resultData;
    }
    
    @AuraEnabled
    public static string getCSRPartList(String csrnumber){
        List<CSRPart> partLst = new List<CSRPart>();
        // List<String> brands = new List<String>{'BENDIX', 'EXIDE', 'TOKOHAMA', 'GOOD YEAR'};
        //     List<String> descriptions = new List<String>{'Bills Trucking Order', 'Cabina', 'Model 579 parts'};
        //         Decimal minPrice = 10.5;
        // Decimal maxPrice = 100.7;
        // for (Integer i = 0; i < 30; i++) {
        //     CSRPart part = new CSRPart();
        //     part.partSR = i+1;
        //     part.partDescription = descriptions[Math.mod(Math.abs(Crypto.getRandomInteger()), descriptions.size())];
        //     part.partChannel = 'DSP';
        //     part.partCompetitor = 'FRAS-LE';
        //     part.partCompPart = '';
        //     //Comp. part
        //     for (Integer j = 0; j < 8; j++) {
        //         Integer rand = Math.mod(Math.abs(Crypto.getRandomInteger()), 36);
        //         part.partCompPart += '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(rand, rand+1);
        //     }
        //     //Part number generation
        //     part.partNumber = '';
        //     for (Integer j = 0; j < 8; j++) {
        //         Integer rand = Math.mod(Math.abs(Crypto.getRandomInteger()), 36);
        //         part.partNumber += '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(rand, rand+1);
        //     }
        //     part.partBrand = brands[Math.mod(Math.abs(Crypto.getRandomInteger()), brands.size())];
        //     part.partCompPrice = '$ ' + Math.round((Math.random() * (maxPrice - minPrice)) + minPrice);
        //     partLst.add(part);
        // }
        return JSON.serialize(partLst);
    }
   
    
   @Testvisible 
   private static String getEndPointParameters(List<String> dealerCodeList) {
        //JSON Generator
        string username = UserInfo.getName();
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeObjectField('dealer_codes', dealerCodeList);
        gen.writeObjectField('status', new List<String>{'P','R'});
        gen.writeObjectField('frequency', new List<String>{'DAY','WEEK','MONTH', 'QUARTER','YEAR','ALL'} );
        gen.writeEndObject();
        // Get the JSON string.
        String pretty = gen.getAsString();
        return pretty;
    }
    
    public class CSRItem {
        @AuraEnabled
        public Integer SR { get; set; }
        @AuraEnabled
        public String DealerId { get; set; }
        @AuraEnabled
        public String CSRNumber { get; set; }
        @AuraEnabled
        public Integer Phase { get; set; }
        @AuraEnabled
        public String Description { get; set; }
        @AuraEnabled
        public String Createdby { get; set; }
        @AuraEnabled
        public string LastUpdated { get; set; }
        @AuraEnabled
        public string ExpirationDate { get; set; }
        @AuraEnabled
        public String Status { get; set; }
        @AuraEnabled
        public String csrType { get; set; }
        @AuraEnabled
        public String dealer { get; set; }
        @AuraEnabled
        public String dealerType { get; set; }
        @AuraEnabled
        public String competitiveType { get; set; }
        @AuraEnabled
        public String customerName { get; set; }
        @AuraEnabled
        public boolean hasComments { get; set; }
        @AuraEnabled
        public boolean hasFiles { get; set; }
        
    }
    
    public class CSRPart {
        @AuraEnabled
        public Integer partSR { get; set; }
        @AuraEnabled
        public String partNumber { get; set; }
        @AuraEnabled
        public String partDescription { get; set; }
        @AuraEnabled
        public String partChannel { get; set; }
        @AuraEnabled
        public String partCompetitor { get; set; }
        @AuraEnabled
        public String partCompPart { get; set; }
        @AuraEnabled
        public String partCompPrice { get; set; }
        @AuraEnabled
        public String partBrand { get; set; }
    }
    
    //get translations for Active CSR
    @AuraEnabled(cacheable=true)
    public static CSRTile getCSRTileTranslations() {
        List<Map<String, String>> csrType = getListValuesByName(
            'CSRType',
            'eDealerActiveCsrTile'
        );
        Map<String, String> csrTitle = getTranslationValuesByName(
            'CSRTitle',
            'eDealerActiveCsrTile'
        );
        List<Map<String, String>> timeFilter = getListValuesByName(
            'TimeFilter',
            'eDealerActiveCsrTile'
        );
        Map<String, String> helpText = getTranslationValuesByName(
            'HelpText',
            'eDealerActiveCsrTile'
        );
        Map<String, String> errorMsg = getTranslationValuesByName(
            'ErrorMessage',
            'eDealerActiveCsrTile'
        );
        return new CSRTile(csrType, csrTitle, timeFilter, helpText, errorMsg );
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
    
    //get translations for Pending CSR(s) Tile
    @AuraEnabled(cacheable=true)
    public static CSRTile getPendingCSRTileTranslations() {
        List<Map<String, String>> csrType = getListValuesByName(
            'CSRType',
            'eDealerPendingCsrTile'
        );
        Map<String, String> csrTitle = getTranslationValuesByName(
            'CSRTitle',
            'eDealerPendingCsrTile'
        );
        Map<String, String> helpText = getTranslationValuesByName(
            'HelpText',
            'eDealerPendingCsrTile'
        );
        Map<String, String> errorMsg = getTranslationValuesByName(
            'ErrorMessage',
            'eDealerPendingCsrTile'
        );
        return new CSRTile(csrType, csrTitle, null, helpText,errorMsg);
    }
    
    @AuraEnabled(cacheable=true)
    public static CSRDrilldown getCSRDrilldownTranslations() {
        List<Map<String, String>> csrHeader = getListValuesByName(
            'CSRHeader',
            'eDealerCsrListing'
        );
        List<Map<String, String>> tableHeader = getListValuesByName(
            'TableHeader',
            'eDealerCsrListing'
        );
        Map<String, String> csrList = getTranslationValuesByName(
            'CSRList',
            'eDealerCsrListing'
        );
        Map<String, String> download = getTranslationValuesByName(
            'Download',
            'eDealerCsrListing'
        );
        Map<String, String> successRenewalMessage = getTranslationValuesByName(
            'successRenewalMessage',
            'eDealerCsrListing'
        );
        Map<String, String> renewalConfirmationMessage = getTranslationValuesByName(
            'renewalConfirmationMessage',
            'eDealerCsrListing'
        );
        
        return new CSRDrilldown(csrHeader, tableHeader, csrList, download, successRenewalMessage, renewalConfirmationMessage,null);
    }
    
    @AuraEnabled(cacheable=true)
    public static CSRDrilldown getDraftCsrDrilldownTranslations() {
        List<Map<String, String>> csrHeader = getListValuesByName(
            'DraftCsrHeader',
            'eDealerCsrListing'
        );
        List<Map<String, String>> tableHeader = getListValuesByName(
            'TableHeader',
            'eDealerPartNumberSearch'
        );
        Map<String, String> csrList = getTranslationValuesByName(
            'CSRList',
            'eDealerCsrListing'
        );
        Map<String, String> download = getTranslationValuesByName(
            'Download',
            'eDealerCsrListing'
        );
        Map<String, String> cancelationConfirmationMessage = getTranslationValuesByName(
            'cancelationConfirmationMessage',
            'eDealerCsrListing'
        );
        return new CSRDrilldown(csrHeader, tableHeader, csrList, download,null,null,cancelationConfirmationMessage);
    }
    
    @AuraEnabled(cacheable=true)
    public static CSRDrilldown getPendingCsrDrilldownTranslations() {
        List<Map<String, String>> csrHeader = getListValuesByName(
            'PendingCsrHeader',
            'eDealerCsrListing'
        );
        List<Map<String, String>> tableHeader = getListValuesByName(
            'TableHeader',
            'eDealerCsrListing'
        );
        Map<String, String> csrList = getTranslationValuesByName(
            'CSRList',
            'eDealerCsrListing'
        );
        Map<String, String> download = getTranslationValuesByName(
            'Download',
            'eDealerCsrListing'
        );
        
        return new CSRDrilldown(csrHeader, tableHeader, csrList, download,null,null,null);
    }
    
    @AuraEnabled(cacheable=true)
    public static CSRDashboard getCSRDashboardTranslations() {
        
        Map<String, String> dashboard = getTranslationValuesByName(
            'Dashboard',
            'eDealerKPIContainer'
        );
        Map<String, String> activecsr = getTranslationValuesByName(
            'ActiveCSR',
            'eDealerKPIContainer'
        );
        Map<String, String> csr = getTranslationValuesByName(
            'CSR',
            'eDealerKPIContainer'
        );
        
        return new CSRDashboard(dashboard,activecsr,csr);
    }
    
    @AuraEnabled(cacheable=true)
    public static CSRDashboard getDraftCSRDashboardTranslations(){
        
        Map<String, String> dashboard = getTranslationValuesByName(
            'Dashboard',
            'eDealerKPIContainer'
        );
        Map<String, String> draftcsr = getTranslationValuesByName(
            'DraftCSR',
            'eDealerKPIContainer'
        );
        Map<String, String> csr = getTranslationValuesByName(
            'CSR',
            'eDealerKPIContainer'
        );
        return new CSRDashboard(dashboard,draftcsr,csr);
    }
    
    @AuraEnabled(cacheable=true)
    public static CSRDashboard getPendingCSRDashboardTranslations(){
        
        Map<String, String> dashboard = getTranslationValuesByName(
            'Dashboard',
            'eDealerKPIContainer'
        );
        Map<String, String> pendingcsr = getTranslationValuesByName(
            'PendingCSR',
            'eDealerKPIContainer'
        );
        Map<String, String> csr = getTranslationValuesByName(
            'CSR',
            'eDealerKPIContainer'
        );
        return new CSRDashboard(dashboard,pendingcsr,csr);
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
        }else if(cmpName == 'eDealerPartNumberSearch'){
            csrTranslations = EDealerMetadataUtility.csrDrilldownTranslations;
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
    
    public class CSRDrilldown {
        @AuraEnabled
        public List<Map<String, String>> csrHeader;
        @AuraEnabled
        public List<Map<String, String>> tableHeader;
        @AuraEnabled
        public Map<String, String> csrList;
        @AuraEnabled
        public Map<String, String> download;
        @AuraEnabled
        public Map<String, String> successRenewalMessage;
        @AuraEnabled
        public Map<String, String> renewalConfirmationMessage;
        @AuraEnabled
        public Map<String, String> cancelationConfirmationMessage;
        
        public CSRDrilldown(
            List<Map<String, String>> csrHeader,
            List<Map<String, String>> tableHeader,
            Map<String, String> csrList,
            Map<String, String> download,
            Map<String, String> successRenewalMessage,
            Map<String, String> renewalConfirmationMessage,
            Map<String, String> cancelationConfirmationMessage
        ) {
            this.csrHeader = csrHeader;
            this.tableHeader = tableHeader;
            this.csrList = csrList;
            this.download = download;
            this.successRenewalMessage = successRenewalMessage;
            this.renewalConfirmationMessage = renewalConfirmationMessage;
            this.cancelationConfirmationMessage = cancelationConfirmationMessage;
        }
    }
    public class CSRDashboard {
        @AuraEnabled
        public Map<String, String> dashboard;
        @AuraEnabled
        public Map<String, String> activecsr;
        @AuraEnabled
        public Map<String, String> csr;
        
        public CSRDashboard(
            Map<String, String> Dashboard,
            Map<String, String> ActiveCSR,
            Map<String, String> csr
        ) {
            this.dashboard = dashboard;
            this.activecsr = activecsr;
            this.csr = csr;
        } 
    }

    @AuraEnabled (cacheable=true)
    public static decimal getdownloadsize(){
        return eDealer_Config__mdt.getInstance('CSR_download_file_size').Value__c;
    }

}