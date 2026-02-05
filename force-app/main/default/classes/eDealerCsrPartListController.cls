public with sharing class eDealerCsrPartListController {
    
    @AuraEnabled (cacheable=true)
    public static List<String> getAllowedQtyCSRType(){
        
        String allowedTypesMtd= 'Allowed_CSR_type_for_qty_editing';
        eDealer_config__mdt allowedTypes = eDealer_config__mdt.getInstance(allowedTypesMtd);
        List<String> csrTypeList = eDealer_config__mdt.getInstance(allowedTypesMtd).Long_Value__c.split(';');
        return csrTypeList;
    }

    
    @AuraEnabled(cacheable=true)
    public static Decimal getWreckCSRMinPrice() {
        String metadataKey = 'Threshold_for_Store_and_Group_Wreck_CSR';

        // Reuse existing util method
        eDealer_Config__mdt config = EDealerConfigUtils.getConfigByDeveloperName(metadataKey);

        if (config != null && config.Value__c != null) {
            return config.Value__c;
        }

        // Fallback default if no valid config value
         throw new AuraHandledException('Unable to get min threshhold value for Wreak CSR');
    }

    
    // This method called on save as draft button clicked to save csr as draft.
    @AuraEnabled 
    public static Map<String,String> saveCSRChanges(String payload, String csrNumber, String phase,String jsonFileDetails){  
        
        if(String.isBlank(csrNumber)){
            system.debug('Add CSR Mode!!!'); 
            return saveCSRChangesAPICall(payload,jsonFileDetails); 
        }else{
            system.debug('EDIT CSR Mode!!!');             
            return editCSR(payload,csrNumber,phase,jsonFileDetails);
        }
    }
    
    @AuraEnabled 
    public static Map<String,String> submitCSR(String payload,String csrNumber,String phase,String jsonFileDetails){
        
        Map<String,String> mapOfCSRInfo = new Map<String,String>();
        try {
            String asiUserName;                   
            System.debug('payload=>'+payload);
            CsrPartsDataWrapper payloadFromUI = (CsrPartsDataWrapper) System.JSON.deserialize(payload, CsrPartsDataWrapper.class);
            System.debug('payloadFromUI=>'+payloadFromUI);
            asiUserName = payloadFromUI.headerData.CsrUser;
            RequestPayloadForSubmitCsr requestPayloadForSubmit = new RequestPayloadForSubmitCsr();            
            
            if (String.isBlank(csrNumber)) {
                mapOfCSRInfo = saveCSRChangesAPICall(payload,jsonFileDetails);
                if (!mapOfCSRInfo.containsKey('apiError')) {
                    requestPayloadForSubmit.CSRNumber = Integer.valueOf(mapOfCSRInfo.get('csr_num'));
                    requestPayloadForSubmit.Phase = Integer.valueOf(mapOfCSRInfo.get('phase')); 
                }
            } else {
                requestPayloadForSubmit.CSRNumber = Integer.valueOf(csrNumber);
                if (!mapOfCSRInfo.containsKey('apiError')) { 
                    requestPayloadForSubmit.Phase = Integer.valueOf(phase); 
                    mapOfCSRInfo = editCSR(payload, csrNumber, phase, jsonFileDetails);
                }
            }
            
            System.debug('mapOfCSRInfo-----' + mapOfCSRInfo);
            
            if (!mapOfCSRInfo.containsKey('apiError')) {
                requestPayloadForSubmit.UserName = asiUserName;
                String requestPayloadForSubmitStr = JSON.serialize(requestPayloadForSubmit);
                System.debug('requestPayloadForSubmitStr-----' + requestPayloadForSubmitStr);
                submitCSRAPICall(requestPayloadForSubmitStr);
                
                // Only execute if feature toggle is enabled
                Boolean featureEnabled = ToggleFeaturesController.isFeatureEnabled('USERSTORY1611839');
                
                if (featureEnabled) {
                    String payloadForSF = (String) mapOfCSRInfo.get('requestPayloadStr');
                    System.debug('payload for SF ' + payloadForSF);
                    saveCSRAndLinesDataToSF(
                        payloadForSF, 
                        String.valueOf(requestPayloadForSubmit.CSRNumber), 
                        String.valueOf(requestPayloadForSubmit.Phase)
                    );
                }
            }
            
            return mapOfCSRInfo;
            
        } catch (Exception exp) {
            System.debug(exp.getStackTraceString());
            System.debug(exp.getMessage());
            mapOfCSRInfo.clear();
            mapOfCSRInfo.put('error_message', exp.getMessage());
            return mapOfCSRInfo;
        }
    }
    
    
    // This method used to call submit CSR API
    private static String submitCSRAPICall(String requestPayloadForSubmitStr){
        
        Map<string,object> calloutDetails = new Map<string,object>();
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWSubmitCSRRequest');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',requestPayloadForSubmitStr);
        calloutDetails.put('classname','eDealerCsrPartListController');        
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        System.debug('----submit-resultData---'+resultData);  
        return resultData;
    }
    
    // This method used to call create CSR API   
    private static Map<String,String> saveCSRChangesAPICall(String payload,String jsonFileDetails){
        Map<String,String> mapOfCsrResponse = new Map<String,String>();
        try {
            system.debug('Payload save as Draft-- :'+payload);
            CsrPartsDataWrapper payloadFromUI = (CsrPartsDataWrapper) System.JSON.deserialize(payload, CsrPartsDataWrapper.class);
            CSRRequestPayload requestPayload = new CSRRequestPayload();
            requestPayload.DealerId = payloadFromUI.headerData.DealerId;    
            requestPayload.DealerSfx = ' ';  
            requestPayload.CompetitiveType = payloadFromUI.headerData.CompetitiveType;
            requestPayload.DealerType = payloadFromUI.headerData.DealerType;    
            requestPayload.CustomerName = payloadFromUI.headerData.CustomerName;
            requestPayload.CsrUser = payloadFromUI.headerData.CsrUser;
            requestPayload.CSRType = payloadFromUI.headerData.CSRType;
            if(requestPayload.CSRType == 'W'){
                requestPayload.Chassi = payloadFromUI.headerData.Chassi;
                requestPayload.InsComp = payloadFromUI.headerData.InsComp;
                requestPayload.WriteOff = payloadFromUI.headerData.WriteOff;
                requestPayload.DlrDisc = Integer.valueOf(payloadFromUI.headerData.DlrDisc);
            } else {
                requestPayload.Chassi = '';
                requestPayload.InsComp = '';
                requestPayload.WriteOff = '';
                requestPayload.DlrDisc = 0;            
            }
            if(requestPayload.CSRType == 'B') {
                requestPayload.DurBid = Integer.valueOf(payloadFromUI.headerData.DurBid);
                requestPayload.ExpMarkUp = payloadFromUI.headerData.ExpMarkUp;
            }else {
                requestPayload.DurBid = 0;
                requestPayload.ExpMarkUp = '';    
            }                                            
            List<CSRILine> csrlines = new List<CSRILine>();
            
            List<CsrPartsData> csrPartsWithoutCompId = new List<CsrPartsData>();
            List<CompInput> CompInput = new List<CompInput>();
            List<AffilInput> AffilInput = new List<AffilInput>();
            for(CsrPartsData partData : payloadFromUI.partDataList){
                if(String.isEmpty(partData.Competitor.CompetitorCode) && ( requestPayload.CSRType!='B' && requestPayload.CSRType!='W' )){
                    System.debug('in empty:::');
                    CompInput input = new CompInput();
                    input.ItmId = partData.Part;
                    input.CompetitorName = partData.Competitor.CompetitorName;
                    input.City = partData.Competitor.CompCity;
                    input.State = partData.Competitor.CompState;
                    input.Postal = partData.Competitor.CompPostal;
                    if(partData.Competitor.Affiliation !=null){
                        for(String affiliation : partData.Competitor.Affiliation) {
                            AffilInput affInput = new AffilInput();
                            affInput.AffilCd = Integer.valueOf(affiliation);
                            AffilInput.add(affInput);
                        }
                    }
                    
                    input.AffilInput = AffilInput;
                    input.Type = payloadFromUI.headerData.CompetitiveType;
                    input.UserId = payloadFromUI.headerData.CsrUser;
                    csrPartsWithoutCompId.add(partData);
                    CompInput.add(input);
                }
                else{
                    CSRILine csrLine = new CSRILine();
                    csrLine.PartNumber = partData.Part; 
                    csrLine.PartDescription = partData.PartDescription; 
                    csrLine.Quantity = '1';
                    if(( requestPayload.CSRType!='B' && requestPayload.CSRType!='W' )){
                        csrLine.CompPart =partData.CompPart;    
                        csrLine.Price =partData.CompPrice;  
                        csrLine.CompetitorBrand = partData.Brand;
                        csrLine.CompetitorCode = partData.Competitor.CompetitorCode; 
                    }else {
                        if(requestPayload.CSRType =='B'){
                            csrLine.CompetitorCode = '002995';
                        }
                        if(requestPayload.CSRType =='W'){
                            csrLine.CompetitorCode = '002994';
                        }
                    }
                    if(partData.Channel == 'PDC'){
                        csrLine.Channel = 'WHS'; 
                    }else if(partData.Channel == 'DSP'){
                        csrLine.Channel = partData.Channel;  
                    }
                    requestPayload.CSRILine.add(csrLine); 
                }
            }
            if(!csrPartsWithoutCompId.isEmpty()){
                CompetitorRequestPayloadWrapper competitorRequestpayload = new CompetitorRequestPayloadWrapper();
                competitorRequestpayload.DealerId = payloadFromUI.headerData.DealerId;
                competitorRequestpayload.CompInput = CompInput;
                String jsonCompetitor = JSON.serialize(competitorRequestpayload);
                AddCompetitorResWrapper addCompetitorRes = addCompetitorApiCall(jsonCompetitor);
                if (addCompetitorRes.ErrorResponse.ErrorMessages != null && !addCompetitorRes.ErrorResponse.ErrorMessages.isEmpty()) {  
                    String errorDescription = addCompetitorRes.ErrorResponse.ErrorMessages[0].ErrorDescription;
                    System.debug('errorDescription----'+errorDescription);
                    if(errorDescription !=null){
                        mapOfCsrResponse.put('apiError',errorDescription);
                        return mapOfCsrResponse;
                    }     
                }          
                for(CsrPartsData partData : csrPartsWithoutCompId){
                    CSRILine csrLine = new CSRILine();
                    csrLine.PartNumber = partData.Part; 
                    csrLine.PartDescription = partData.PartDescription; 
                    csrLine.Quantity = '1';
                    if(( requestPayload.CSRType!='B' && requestPayload.CSRType!='W' )){
                        csrLine.CompPart =partData.CompPart;    
                        csrLine.Price =partData.CompPrice;  
                        csrLine.CompetitorBrand = partData.Brand;
                        system.debug('the data for findCompetitorCode : '+partData+' and '+addCompetitorRes);
                        csrLine.CompetitorCode = findCompetitorCode(partData,addCompetitorRes); 
                    } else {
                        if(requestPayload.CSRType =='B'){
                            csrLine.CompetitorCode = '002995';
                        }
                        if(requestPayload.CSRType =='W'){
                            csrLine.CompetitorCode = '002994';
                        }
                    }                    
                    if(partData.Channel == 'PDC'){
                        csrLine.Channel = 'WHS'; 
                    }else if(partData.Channel == 'DSP'){
                        csrLine.Channel = partData.Channel;  
                    }
                    System.debug('csrLine.CompetitorCode:::'+csrLine.CompetitorCode);
                    requestPayload.CSRILine.add(csrLine);                 
                }
            }      
            String requestPayloadStr = JSON.serialize(requestPayload);
            System.debug('requestPayloadStr for create CSR:::'+requestPayloadStr);
            Map<String,object> calloutDetails = new Map<string,object>();             
            calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWCreateCSRRequest');
            calloutDetails.put('namedCredentials','callout:GatewayApplication');
            calloutDetails.put('method','POST');
            calloutDetails.put('body',requestPayloadStr);
            calloutDetails.put('classname','eDealerCsrPartListController');        
            String resultData = EDealerHttpHandler.callout(calloutDetails);
            system.debug('----resultData--' + resultData);
            if(resultData !=null && !resultData.contains('apiError')){
                system.debug('resultData.contains' + !resultData.contains('apiError'));
                Map<String, Object> jsonResultDataObject = (Map<String, Object>) JSON.deserializeUntyped(resultData);
                system.debug('----jsonResultDataObject--' + jsonResultDataObject);
                Boolean isSuccess = Boolean.valueOf(((Map<String, Object>) jsonResultDataObject.get('ErrorResponse')).get('IsSuccess'));
                String csrNumber = String.valueof(((Map<String, Object>) jsonResultDataObject.get('CSROutput')).get('Sanbr'));
                Integer phase = Integer.valueof(((Map<String, Object>) jsonResultDataObject.get('CSROutput')).get('Phase'));
                if(isSuccess){
                    EDealerCsrFileUpload.uploadFile(jsonFileDetails,csrNumber,phase);
                }
                
                mapOfCsrResponse = new Map<String,String>();
                CSRResponseWrapper responseWrapper = new CSRResponseWrapper();
                system.debug('\n--resultData--'+resultData);
                
                mapOfCsrResponse = readCSRCreateUpdateResponse(resultData);
                
                if (ToggleFeaturesController.isFeatureEnabled('USERSTORY1611839')) {
                    mapOfCsrResponse.put('requestPayloadStr', requestPayloadStr);
                } 
                
                return mapOfCsrResponse;
                
            } else if(resultData.contains('apiError')){
                system.debug('resultData.contains---true-----' + !resultData.contains('apiError'));
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(resultData);
                mapOfCsrResponse.put('apiError',(String) jsonMap.get('apiError'));
            }
            
            return mapOfCsrResponse; 
        }  catch (Exception exp) {
            system.debug('---getMessage--' + exp.getMessage());
            system.debug('---getCause--' + exp.getCause());
            system.debug('---getStackTraceString--' + exp.getStackTraceString());
            system.debug('---getLineNumber--' + exp.getLineNumber());
            mapOfCsrResponse.put('error_message', exp.getMessage());
            return mapOfCsrResponse;
        }
    }
    
    private static Map<String,String> readCSRCreateUpdateResponse(string responseFromASI){
        Map<String,String> mapOfCsrResponse = new Map<String,String>();
        
        // Deserialize the JSON string into a Map<String, Object>
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(responseFromASI);
        
        // Get the CSROutput map from the JSON
        Map<String, Object> csroOutputMap = (Map<String, Object>) jsonMap.get('CSROutput');
        
        
        // Get the values of Sanbr and Phase
        Integer sanbr = (Integer) csroOutputMap.get('Sanbr');
        Integer phase = (Integer) csroOutputMap.get('Phase');
        
        mapOfCsrResponse.put('csr_num',String.valueOf(sanbr));
        mapOfCsrResponse.put('phase',String.valueOf(phase));
        
        // Access the ErrorResponse object
        Map<String, Object> errorResponse = (Map<String, Object>) jsonMap.get('ErrorResponse');
        // Check if IsSuccess is false
        String isSuccess = (String) errorResponse.get('IsSuccess');
        List<Object> errorMessages = (List<Object>) errorResponse.get('ErrorMessages');
        if (isSuccess != null && (isSuccess.equalsIgnoreCase('false') || !errorMessages.isEmpty())) {
            
            for (Object errorMessage : errorMessages) {
                Map<String, Object> errorMap = (Map<String, Object>) errorMessage;
                String errorIdentifier = (String) errorMap.get('ErrorIdentifier');
                String errorDescription = (String) errorMap.get('ErrorDescription');
                
                mapOfCsrResponse.put('error_message',errorDescription);
            }
        }
        return mapOfCsrResponse;
    }
    
    public static String findCompetitorCode(CsrPartsData partData,AddCompetitorResWrapper addCompRes){
        System.debug('====> the partData : '+partData+' and addCompRes : '+addCompRes);
        String compCode = '';
        for(Integer i = 0; i < addCompRes.data.CompOutput.size(); i++){
            if(partData.Competitor.CompetitorName == addCompRes.data.compOutput[i].CompetitorName){
                compCode = addCompRes.data.compOutput[i].competitorCode;
            }
        }
        return compCode;
    }
    
    private static AddCompetitorResWrapper addCompetitorApiCall(String requestPayloadForAddCompetitor){
        Map<String,object> calloutDetails = new Map<string,object>(); 
        Map<String,String> mapOfCsrResponse = new Map<String,String>();
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWAddCompetitorDetails');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',requestPayloadForAddCompetitor);
        calloutDetails.put('classname','eDealerCsrPartListController');        
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        if(resultData.contains('apiError')){
            AddCompetitorResWrapper wrapper = new AddCompetitorResWrapper();
            ErrorMessages errorMessage = new ErrorMessages();
            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(resultData);
            errorMessage.ErrorDescription = (String)jsonMap.get('apiError');
            wrapper.ErrorResponse = new ErrorResponse();
            wrapper.ErrorResponse.ErrorMessages = new List<ErrorMessages>{ errorMessage };
                System.debug('wrapper------'+wrapper);
            return wrapper;
        }
        System.debug('resultData for add competitor:::'+resultData);
        String correctJSON = resultData.replace('"IsSuccess":"True"', '"IsSuccess":true');
        System.debug('correctJSON:::'+correctJSON);
        AddCompetitorResWrapper addCompRes = (AddCompetitorResWrapper)JSON.deserialize(correctJSON,AddCompetitorResWrapper.class);
        return addCompRes;
    }
    
    // This method use to cancel CSR
    @AuraEnabled
    public static String cancelCSR(String userName,String csrNumber,String csrPhase, String dealerId){      //modified to add dealerId, Chito 05-01-2024
        CancelCSRRequestPayloadWrapper requestPayloadWrpper = new CancelCSRRequestPayloadWrapper();
        requestPayloadWrpper.CSRNumber = csrNumber;
        requestPayloadWrpper.UserName = (userName != null )? userName : UserInfo.getName() ;
        requestPayloadWrpper.Phase = csrPhase;
        requestPayloadWrpper.Dealerid = dealerId;     // added 05-01-2024
        Map<String,object> calloutDetails = new Map<string,object>(); 
        String requestPayload = JSON.serialize(requestPayloadWrpper);
        System.debug('requestPayload for cancel:::'+requestPayload);
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWCSRCancel');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',requestPayload);
        calloutDetails.put('classname','eDealerCsrPartListController');        
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        System.debug('resultData----'+resultData);
        return resultData;
    }
    
    private static Map<String,String> editCSR(String payload, String csrNumber, String csrPhase,String jsonFileDetails){
        Map<String,String> mapOfCsrResponse = new Map<String,String>();
        try {  
            CsrPartsDataWrapper payloadFromUI = (CsrPartsDataWrapper) System.JSON.deserialize(payload, CsrPartsDataWrapper.class);
            system.debug('payloadFromUI.headerData.DealerId----'+payloadFromUI.headerData.DealerId);
            EditCsrRequestWrapper requestPayload = new EditCsrRequestWrapper();
            
            requestPayload.DealerId = payloadFromUI.headerData.DealerId;    
            requestPayload.DealerSfx = ' '; 
            requestPayload.CompetitiveType = payloadFromUI.headerData.CompetitiveType;
            requestPayload.DealerType = payloadFromUI.headerData.DealerType;    
            requestPayload.CustomerName = payloadFromUI.headerData.CustomerName;
            requestPayload.CsrUser = payloadFromUI.headerData.CsrUser;
            requestPayload.CSRType = payloadFromUI.headerData.CSRType;
            requestPayload.CSRNBR = Integer.valueOf(csrNumber);
            requestPayload.Phase = Integer.valueOf(csrPhase);
            if(requestPayload.CSRType == 'W'){
                requestPayload.Chassi = payloadFromUI.headerData.Chassi;
                requestPayload.InsComp = payloadFromUI.headerData.InsComp;
                requestPayload.WriteOff = payloadFromUI.headerData.WriteOff;
                requestPayload.DlrDisc = Integer.valueOf(payloadFromUI.headerData.DlrDisc);
            } else {
                requestPayload.Chassi = '';
                requestPayload.InsComp = '';
                requestPayload.WriteOff = '';
                requestPayload.DlrDisc = 0;            
            }
            if(requestPayload.CSRType == 'B'){
                requestPayload.DurBid = Integer.valueOf(payloadFromUI.headerData.DurBid);
                requestPayload.ExpMarkUp = payloadFromUI.headerData.ExpMarkUp;
            } else {
                requestPayload.DurBid = 0;
                requestPayload.ExpMarkUp = '';
            }
            List<CsrPartsData> csrPartsWithoutCompId = new List<CsrPartsData>();
            List<CompInput> CompInput = new List<CompInput>();
            List<AffilInput> AffilInput = new List<AffilInput>();
            for(CsrPartsData partData : payloadFromUI.partDataList){
                system.debug('Competitor Code '+partData.Competitor.CompetitorCode);
                if(String.isEmpty(partData.Competitor.CompetitorCode) && ( requestPayload.CSRType!='B' && requestPayload.CSRType!='W' )){
                    System.debug('in empty:::');
                    CompInput input = new CompInput();
                    input.ItmId = partData.Part;
                    input.CompetitorName = partData.Competitor.CompetitorName;
                    input.City = partData.Competitor.CompCity;
                    input.State = partData.Competitor.CompState;
                    input.Postal = partData.Competitor.CompPostal;
                    if(partData.Competitor.Affiliation !=null){
                        for(String affiliation : partData.Competitor.Affiliation) {
                            AffilInput affInput = new AffilInput();
                            affInput.AffilCd = Integer.valueOf(affiliation);
                            AffilInput.add(affInput);
                        }
                    }
                    input.AffilInput = AffilInput;
                    input.Type = payloadFromUI.headerData.CompetitiveType;
                    input.UserId = payloadFromUI.headerData.CsrUser;
                    csrPartsWithoutCompId.add(partData);
                    CompInput.add(input);
                }
                else{
                    CSRILine csrLine = new CSRILine();
                    csrLine.PartNumber = partData.Part; 
                    csrLine.PartDescription = partData.PartDescription; 
                    csrLine.Quantity = '1';
                    if(( requestPayload.CSRType!='B' && requestPayload.CSRType!='W' )){
                        csrLine.CompPart =partData.CompPart;    
                        csrLine.Price =partData.CompPrice;  
                        csrLine.CompetitorBrand = partData.Brand;
                        csrLine.CompetitorCode = partData.Competitor.CompetitorCode; 
                    } else {
                        if(requestPayload.CSRType =='B'){
                            csrLine.CompetitorCode = '002995';
                        }
                        if(requestPayload.CSRType =='W'){
                            csrLine.CompetitorCode = '002994';
                        }
                    }
                    
                    if(partData.Channel == 'PDC'){
                        csrLine.Channel = 'WHS'; 
                    }else if(partData.Channel == 'DSP'){
                        csrLine.Channel = partData.Channel;  
                    }
                    requestPayload.CSRILine.add(csrLine); 
                }
                
            }
            if(!csrPartsWithoutCompId.isEmpty()){
                CompetitorRequestPayloadWrapper competitorRequestpayload = new CompetitorRequestPayloadWrapper();
                competitorRequestpayload.DealerId = payloadFromUI.headerData.DealerId;
                competitorRequestpayload.CompInput = CompInput;
                String jsonCompetitor = JSON.serialize(competitorRequestpayload);
                AddCompetitorResWrapper addCompetitorRes = addCompetitorApiCall(jsonCompetitor);  
                if (addCompetitorRes.ErrorResponse.ErrorMessages != null && !addCompetitorRes.ErrorResponse.ErrorMessages.isEmpty()) {  
                    String errorDescription = addCompetitorRes.ErrorResponse.ErrorMessages[0].ErrorDescription;
                    System.debug('errorDescription----'+errorDescription);
                    if(errorDescription !=null){
                        mapOfCsrResponse.put('apiError',errorDescription);
                        return mapOfCsrResponse;
                    }}
                for(CsrPartsData partData : csrPartsWithoutCompId){
                    CSRILine csrLine = new CSRILine();
                    csrLine.PartNumber = partData.Part; 
                    csrLine.PartDescription = partData.PartDescription; 
                    csrLine.Quantity = '1';
                    if(( requestPayload.CSRType!='B' && requestPayload.CSRType!='W' )){
                        csrLine.CompPart =partData.CompPart;    
                        csrLine.Price =partData.CompPrice;  
                        csrLine.CompetitorBrand = partData.Brand;
                        csrLine.CompetitorCode = findCompetitorCode(partData,addCompetitorRes); 
                    }
                    
                    if(partData.Channel == 'PDC'){
                        csrLine.Channel = 'WHS'; 
                    }else if(partData.Channel == 'DSP'){
                        csrLine.Channel = partData.Channel;  
                    }
                    requestPayload.CSRILine.add(csrLine);                 
                }
            }
            String requestPayloadStr = JSON.serialize(requestPayload);
            system.debug('Request Payload:'+requestPayloadStr);
            Map<String,object> calloutDetails = new Map<string,object>(); 
            calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWCSRUpdDraft');
            calloutDetails.put('namedCredentials','callout:GatewayApplication');
            calloutDetails.put('method','POST');
            calloutDetails.put('body',requestPayloadStr);
            calloutDetails.put('classname','eDealerCsrPartListController');        
            String resultData = EDealerHttpHandler.callout(calloutDetails); 
            System.debug('resultData--'+resultData);
            if(resultData !=null && !resultData.contains('apiError')){
                Map<String, Object> jsonResultDataObject = (Map<String, Object>) JSON.deserializeUntyped(resultData);
                Map<String, Object> errorResponse = (Map<String, Object>) jsonResultDataObject.get('ErrorResponse');
                if(Boolean.valueOf(errorResponse.get('IsSuccess'))){
                    EDealerCsrFileUpload.uploadFile(jsonFileDetails,csrNumber,Integer.valueOf(csrPhase));
                    System.debug('resultData--file-edit--'+errorResponse.get('IsSuccess'));
                }
                
                mapOfCsrResponse = new Map<String,String>();
                CSRResponseWrapper responseWrapper = new CSRResponseWrapper();
                mapOfCsrResponse.put('csr_num',csrNumber);
                mapOfCsrResponse.put('phase',csrPhase);
            } else if(resultData.contains('apiError')){
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(resultData);
                mapOfCsrResponse.put('apiError',(String) jsonMap.get('apiError'));
            }
            // Only add requestPayloadStr when toggle is enabled
            if (ToggleFeaturesController.isFeatureEnabled('USERSTORY1611839')) {
                mapOfCsrResponse.put('requestPayloadStr', requestPayloadStr);
            } 
            
            return mapOfCsrResponse; 
        } catch (Exception exp) {
            mapOfCsrResponse.put('error_message', exp.getMessage());
            return mapOfCsrResponse;
        }
    }
    
    @AuraEnabled
    public static Map<String,Object> getColumnHeaders(String reportName){
        return EDealerMetadataUtility.translateColumnHeadersVersion2(reportName);
    }
    
    @AuraEnabled
    public static List <Map<String,String>> getPartsColumnHeaders(){
        return EDealerMetadataUtility.tableColumnHeaderTranslations('partsTableHeader');
    }    
    public static void saveCSRAndLinesDataToSF(String payload, String csrNumber, String phase) {
        if (String.isBlank(payload)) return;
        
        CSRRequestPayload payloadObj = (CSRRequestPayload) JSON.deserialize(payload, CSRRequestPayload.class);
        csr_CreateCSRController.DealerDetail detail= csr_CreateCSRController.getDealerInfo(payloadObj.DealerId);
        List<Account> accList = AccountDAO.getAccountsByDealerCodes(new Set<String>{ payloadObj.DealerId });
        
        CSR__c csrRecord=upsertCSR(payloadObj, csrNumber, phase, detail, accList);
        
        
        if (payloadObj.CSRILine != null && !payloadObj.CSRILine.isEmpty()) {
            upsertCSRLines(csrRecord.Id, payloadObj.CSRILine);
        }
    }
    
    private static CSR__c upsertCSR(CSRRequestPayload payloadObj, String csrNumber,String phase, csr_CreateCSRController.DealerDetail detail,List<Account> accList) {
        List<CSR__c> existingCSR = csr_CSRSelector.getExistingCSRByNumberAndPhase(csrNumber, phase);
        CSR__c csrRecord = existingCSR.isEmpty() ? new CSR__c() : existingCSR[0];
        
        csrRecord.CSR_Number__c             = csrNumber;
        csrRecord.csr_Phase__c              = String.isNotBlank(phase) ? Decimal.valueOf(phase) : null;
        csrRecord.csr_DealerCode__c         = payloadObj.DealerId;
        csrRecord.csr_Type__c               = payloadObj.CSRType;
        csrRecord.csr_User__c               = payloadObj.CsrUser;
        csrRecord.csr_Competitive_Type__c   = payloadObj.CompetitiveType;
        csrRecord.csr_Dealer_Type__c        = payloadObj.DealerType;
        csrRecord.csr_Customer_Name__c      = payloadObj.CustomerName;
        csrRecord.csr_Chassis_Number__c     = payloadObj.Chassi;
        csrRecord.csr_Insurance_Company__c  = payloadObj.InsComp;
        csrRecord.csr_Write_Off__c          = String.isNotBlank(payloadObj.WriteOff) ? Decimal.valueOf(payloadObj.WriteOff) : null;
        csrRecord.csr_Dealer_Discount__c    = payloadObj.DlrDisc;
        csrRecord.csr_Duration_Days__c      = payloadObj.DurBid;
        csrRecord.csr_Expected_Markup__c    = payloadObj.ExpMarkUp;
        csrRecord.csr_DealerGroup__c        = detail.Dlrgroup;
        csrRecord.csr_DealerDivision__c     = detail?.Division;
        csrRecord.csr_Dealer_Name__c        = detail.Dlrname;
        csrRecord.csr_AccountId__c          = !accList.isEmpty() ? accList[0].Id : null;
        csrRecord.csr_Status__c             = 'D';
        
        upsert csrRecord;
        return csrRecord;
    }
    
    private static void upsertCSRLines(Id csrId, List<CSRILine> csrLines) {
        List<CSR_Line__c> existingLines = csr_CSRLineSelector.getCSRLinesWherePartNumberChannelAndQuantityIsNotNull(csrId);
        
        // Build map of existing lines
        Map<String, CSR_Line__c> existingLinesMap = new Map<String, CSR_Line__c>();
        for (CSR_Line__c line : existingLines) {
            String key = line.csr_Parts_Number__c + line.csr_W_D__c + line.csr_Quantity__c;
            existingLinesMap.put(key, line);
        }
        
        List<CSR_Line__c> linesToUpsert = new List<CSR_Line__c>();
        for (CSRILine part : csrLines) {
            String key = part.PartNumber + part.Channel + part.Quantity;
            CSR_Line__c line = existingLinesMap.containsKey(key) 
                ? existingLinesMap.get(key) 
                : new CSR_Line__c(CSR__c = csrId);
            
            line.csr_Parts_Number__c          = part.PartNumber;
            line.csr_Part_Type_Description__c = part.PartDescription;
            line.csr_Quantity__c              = String.isNotBlank(part.Quantity) ? Decimal.valueOf(part.Quantity) : null;
            line.csr_W_D__c                   = part.Channel;
            line.csr_Competitor__c            = part.CompetitorCode; 
            line.csr_Competitor_P_N__c        = part.CompPart;
            line.csr_Competitor_Price__c      = String.isNotBlank(part.Price) ? Decimal.valueOf(part.Price) : null;
            line.csr_Competitor_Brand__c      = part.CompetitorBrand;
            line.csr_Status__c                = 'D';
            
            linesToUpsert.add(line);
        }
        
        if (!linesToUpsert.isEmpty()) {
            upsert linesToUpsert;
        }
    }
    public class CsrPartsDataWrapper{
        public CsrHeaderData headerData;
        public List<CsrPartsData> partDataList = new List<CsrPartsData>();
    }
    
    public class CsrHeaderData {
        public String DealerId; 
        public String CSRType;
        public String CsrUser;    
        public String CompetitiveType;  
        public String DealerType;   
        public String CustomerName; 
        public String Chassi;
        public String InsComp;
        public String WriteOff;
        public Integer DlrDisc;
        public Integer DurBid;
        public String ExpMarkUp;
        public String Status;   
    }
    
    public class CsrPartsData {
        public String Id;   
        public String Part; 
        public String PartDescription;  
        public Integer Quantity;    
        public String Channel;  
        public Competitor Competitor;
        public String CompPart; 
        public String CompPrice;
        public Channels[] Channels;
        public String Brand;    
        public Boolean isSelected;
        public String isbestNetGreateThen200;
        public Integer srNum;
        
    }
    
    public class Channels{
        public String label;    
        public String value;
    }
    
    public class Competitor {
        public String Confirmation; 
        public String CompType; 
        public String CompState;    
        public String CompPostal;   
        public String CompetitorName;   
        public String CompetitorCode;   
        public String CompCity; 
        public List<String> Affiliation;    
        public Boolean isSelected;
    } 
    
    public class CSRRequestPayload{
        public String DealerId; 
        public String DealerSfx;    
        public String CompetitiveType;
        public String DealerType;   
        public String CustomerName;
        public String CsrUser;
        public String CSRType;
        public String Chassi;
        public String InsComp;
        public String WriteOff;
        public Integer DlrDisc;
        public Integer DurBid;
        public String ExpMarkUp;  
        public List<CSRILine> CSRILine = new List<CSRILine>();  
    }
    
    public class CSRILine {
        public String PartNumber;   
        public String PartDescription;  
        public String Quantity; 
        public String Channel;  
        public String CompetitorCode;
        public String CompPart; 
        public String Price;    
        public String CompetitorBrand;
    }
    
    public class CSRResponseWrapper{
        public CSROutput CSROutput;
        public ErrorResponse ErrorResponse;
    }
    
    public class CSROutput {
        public Integer Sanbr;   
        public Integer Phase;   
    }
    
    public class ErrorResponse {
        public String IsSuccess;    
        public ErrorMessages[] ErrorMessages;
    }
    
    public class ErrorMessages {
        public String ErrorIdentifier;  
        public String ErrorDescription; 
    }
    
    public class RequestPayloadForSubmitCsr{
        public Integer CSRNumber;   
        public Integer Phase;   
        public String UserName;        
    }
    
    public class CancelCSRRequestPayloadWrapper{
        public String CSRNumber;    
        public String UserName;
        public String Phase; 
        public String Dealerid;    //added 05-01-2024
    }
    
    public class CompetitorRequestPayloadWrapper{
        public String DealerId; 
        public List<CompInput> CompInput;
    }
    
    public class CompInput {
        public String ItmId;    
        public String CompetitorName;   
        public String City; 
        public String State;    
        public String Postal;   
        public List<AffilInput> AffilInput;
        public String Type; 
        public String UserId;   
    }
    
    public class AffilInput {
        public Integer AffilCd; 
    }
    
    public class AddCompetitorResWrapper{
        public CompData Data;
        public ErrorResponse ErrorResponse;
    }
    public class CompData {
        public String DealerId;	//I080
        public List<CompOutput> CompOutput;
    }
    public class CompOutput {
        public String ItmId;	//5008414BXW
        public String CompetitorCode;	//009967
        public String CompetitorName;	//HtKenworth
        public String City;	//Sunam Udham Singh Wala
        public String State;	//PB
        public String Postal;	//148028
        public String Type;	//B
        public List<AffilOutput> AffilOutput;
    }
    public class AffilOutput {
        public Integer AffilCd;	//1
        public String AffilName;	//Kenworth
    }
    
    public class ErrorResponses {
        public Boolean IsSuccess;    
        public Integer ErrorMessagesCount;  
        public List<ErrorMessages> ErrorMessages;
    }
    
    public class EditCsrRequestWrapper{
        public Integer CSRNBR;  
        public Integer Phase;   
        public String DealerId; 
        public String DealerSfx;     
        public String CompetitiveType;  
        public String DealerType;   
        public String CustomerName; 
        public String CSRType;   
        public String CsrUser;   
        public String Chassi;   
        public String InsComp;  
        public String WriteOff;    
        public Integer DlrDisc;
        public Integer DurBid;  
        public String ExpMarkUp;    
        public List<CSRILine> CSRILine = new List<CSRILine>();
    }
    
}