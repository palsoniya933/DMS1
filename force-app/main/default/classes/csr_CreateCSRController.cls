public class csr_CreateCSRController {
    
    @AuraEnabled
    public static List<Dealer> getDealers() {
        try {
            String resultData = EDealerHttpHandler.callout(new Map<String, Object>{
                'endpoint' => '/sales-part/CompetitiveSalesRequest/v1/GetDealers',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method' => 'GET',
                    'classname' => 'csr_CreateCSRController'
                    });
            
            if (String.isBlank(resultData) || resultData.contains('apiError')) {
                return new List<Dealer>();
            }
            
            GetDealersResponse response = (GetDealersResponse) JSON.deserialize(resultData, GetDealersResponse.class);
            if (response?.Dealers == null || response.Dealers.isEmpty()) {
                return new List<Dealer>();
            }
            List<Dealer> result = mapDealersToAccounts(response.Dealers);
            System.debug('<<< Exiting getDealers with return: ' + JSON.serialize(result));
            return mapDealersToAccounts(response.Dealers);
            
        } catch (Exception e) {
            System.debug('Exception in getDealers: ' + e.getMessage());
            return new List<Dealer>();
        }
    }
    
    /**
* Calls external service to fetch dealer details by dealer code.
* Returns a DealerDetail wrapper object with additional information.
*/
    @AuraEnabled
    public static DealerDetail getDealerInfo(String dealerCode) {
        System.debug('>>> Entering getDealerInfo -- dealerCode=' + dealerCode);
        DealerDetail detail = new DealerDetail();
        try {
            Map<String, Object> calloutDetails = new Map<String, Object>{
                'endpoint' => '/sales-part/CompetitiveSalesRequest/v1/GWPRDealerInfo',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method' => 'POST',
                    'body' => JSON.serialize(new Map<String, String>{ 'DlrCodeIn' => dealerCode }),
                    'classname' => 'csr_CreateCSRController'
                    };
                        
                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            if (resultData.contains('apiError')) return null;
            
            resultData = resultData.replace('"IsSuccess":"True"', '"IsSuccess":true');
            resultData = resultData.replace('"IsSuccess":"False"', '"IsSuccess":false');
            System.debug('<<< Exiting resultData with return: ' + JSON.serializePretty(resultData));
            
            DealerInfoResponseWrapper wrapper = (DealerInfoResponseWrapper) JSON.deserialize(resultData, DealerInfoResponseWrapper.class);
            if (wrapper != null && wrapper.Data != null) detail = wrapper.Data;
            
        } catch (Exception e) {
            System.debug('Exception in getDealerInfo: ' + e.getMessage());
        }
        System.debug('<<< Exiting getDealerInfo with return: ' + JSON.serializePretty(detail));
        
        return detail;
    }
    
    /**
* Saves CSR header and associated CSR line records.
* If csrId is provided, updates the existing CSR.
* Returns a SaveResultWrapper containing saved CSR and CSR line data.
*/
    @AuraEnabled
    public static SaveResultWrapper saveCSRWithLines(
        String csr, 
        String csrLines,
        List<Id> recordsToDeleteIds,
        Id csrId
    ) {
        System.debug('Input Parameters for saveCSRWithLines => ' +
                     '\n csr: ' + csr +
                     '\n csrLines: ' + csrLines +
                     '\n recordsToDeleteIds: ' + recordsToDeleteIds +
                     '\n csrId: ' + csrId
                    );
        SaveResultWrapper result = new SaveResultWrapper();
        try {
            result.csrData = saveCSRRecord(csr);
            csrId = result.csrData.id;
            
            if (csrId != null && csrLines != null && !String.isEmpty(csrLines)) {
                result.csrLines = saveCsrLines(csrId, csrLines, recordsToDeleteIds);
            }
            
        } catch (Exception e) {
            System.debug('Exception in saveCSRWithLines: ' + e.getMessage() +'\n----'+e.getStackTraceString());            
            throw new AuraHandledException('Unable to save CSR and Lines: ' + e.getMessage());
        }
        System.debug('Output Result => ' +
                     '\n CSR Data: ' + result.csrData +
                     '\n CSR Lines: ' + result.csrLines
                    );
        return result;
    }
    
    
    /**
* Fetches CSR record and associated CSR Lines by CSR Id.
* Returns CSRWithLinesWrapper with both header and line data.
*/
    @AuraEnabled
    public static CSRWithLinesWrapper fetchCsrAndCsrLinesById(Id csrId) {
        System.debug('>>> Entering fetchCsrAndCsrLinesById -- csrId=' + csrId);
        
        if (csrId == null) {
            throw new AuraHandledException('CSR Id is required.');
        }
        
        CSRWithLinesWrapper result = new CSRWithLinesWrapper();
        
        try {
            CSRWrapper csrWrapper = fetchCsrById(csrId);
            result.csrRecord = csrWrapper;
            
            List<CsrLineWrapper> csrLines = getCSRLines(csrId);
            result.csrLines = csrLines != null ? csrLines : new List<CsrLineWrapper>();
            
        } catch (Exception ex) {
            System.debug('Error in fetchCsrAndCsrLinesById: ' + ex.getMessage());
            throw new AuraHandledException('Unable to fetch CSR and Lines: ' + ex.getMessage());
        }
        System.debug('Output Result => ' +
                     '\n CSR Data: ' + result.csrRecord +
                     '\n CSR Lines: ' + result.csrLines
                    );
        return result;
    }
    
    /**
* Returns the currently logged-in User record.
*/
    @AuraEnabled(cacheable=true)
    public static User getCurrentUser() {
        List<User> users = UserDAO.getById(new Set<Id>{ UserInfo.getUserId() });
        return (!users.isEmpty()) ? users[0] : null;
    }
    
    /**
* Returns the name of a User by Id.
*/
    @AuraEnabled(cacheable=true)
    public static String getUserNameById(Id userId) {
        if (userId == null) {
            throw new AuraHandledException('User Id is required.');
        }
        List<User> users = UserDAO.getById(new Set<Id>{ userId });
        return (!users.isEmpty()) ? (users[0].FirstName + ' ' + users[0].LastName) : null;
    }
    
    /**
* Returns all Users who have access to CSR functionality.
*/
    @AuraEnabled
    public static List<User> getAllUsers() {
        return UserDAO.getAllUsersWithCSRAccess();
    }
    /**
* Returns a map of CSR Status picklist values for CSR__c.csr_Status__c.
* Key   = API value
* Value = Label
*/
    private static Map<String, String> getStatusMap() {
        Map<String, String> statusMap = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = CSR__c.csr_Status__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry : values) {
            statusMap.put(entry.getValue(), entry.getLabel());
        }
        
        return statusMap;
    }
    
    /**
* Returns a reverse map of CSR Status picklist values for CSR__c.csr_Status__c.
* Key   = Label
* Value = API value
*/
    private static Map<String, String> getReverseStatusMap() {
        Map<String, String> reverseMap = new Map<String, String>();
        for (Schema.PicklistEntry entry : CSR__c.csr_Status__c.getDescribe().getPicklistValues()) {
            reverseMap.put(entry.getLabel(), entry.getValue());
        }
        return reverseMap;
    }
    
    /**
* Calls external service to fetch a list of dealers.
* Maps dealer codes to Salesforce Accounts where available.
* Returns a list of Dealer wrapper objects.
*/
    
    private static List<Dealer> mapDealersToAccounts(List<Dealer> dealers) {
        Set<String> dealerCodes = new Set<String>();
        for (Dealer d : dealers) {
            if (d?.DealerId != null) dealerCodes.add(d.DealerId);
        }
        
        Map<String, Id> dealerCodeToAccountIdMap = new Map<String, Id>();
        if (!dealerCodes.isEmpty()) {
            for (Account acc : AccountDAO.getAccountsByDealerCodes(dealerCodes)) {
                if (acc?.Dealer_Code__c != null) {
                    dealerCodeToAccountIdMap.put(acc.Dealer_Code__c, acc.Id);
                }
            }
        }
        
        List<Dealer> result = new List<Dealer>();
        for (Dealer d : dealers) {
            if (d?.DealerId != null) {
                d.AccountId = dealerCodeToAccountIdMap.get(d.DealerId);
                result.add(d);
            }
        }
        return result;
    }
    
    /**
* Creates or updates a CSR__c record.
* If Id exists, updates the CSR, otherwise inserts a new CSR.
* Returns updated CSRSaveWrapper with record Id populated.
*/
    private static CSRSaveWrapper saveCSRRecord(String wrapper) {
        System.debug('wrapper=>'+wrapper);
        CSRSaveWrapper csrData = (CSRSaveWrapper) JSON.deserialize(wrapper, CSRSaveWrapper.class);
        System.debug('csrData=>'+csrData);
        CSR__c csrRecord = (csrData.id != null) 
            ? csr_CSRSelector.getCSRById(csrData.id) 
            : new CSR__c(csr_Status__c = 'N');
        
        mapCSRFields(csrRecord, csrData);
        
        upsert csrRecord;
        csrData.id = csrRecord.Id;   
        return csrData;
    }
    
    // --- Mapping helper for CSR ---
    private static void mapCSRFields(CSR__c csrRecord, CSRSaveWrapper csrData) {
        csrRecord.CSR_Number__c = csrData.csrNumber;
        csrRecord.csr_Phase__c = csrData.phase;
        csrRecord.csr_Type__c = csrData.csrType;
        csrRecord.csr_Competitive_Type__c = csrData.competitiveType;
        csrRecord.csr_Effective_Date__c = csrData.effectiveDate;
        csrRecord.csr_Expiration_Date__c = csrData.expirationDate;
        csrRecord.csr_Dealer_Type__c = csrData.dealerType;
        csrRecord.csr_Dealer_Name__c = csrData.dealerName;
        csrRecord.csr_Customer_Name__c = csrData.customerName;
        csrRecord.csr_Assigned_To__c = csrData.assignedTo;
        csrRecord.csr_AccountId__c = csrData.accountId;
        csrRecord.csr_DealerGroup__c = csrData.dealerGroup;
        csrRecord.csr_DealerDivision__c = csrData.dealerDivision;
        csrRecord.csr_DealerCode__c = csrData.dealerCode;
        csrRecord.csr_Country__c =csrData.country;
        csrRecord.csr_Exchange_Rate__c = csrData.exchangeRate;
        csrRecord.csr_DPM_Name__c = csrData.dpmName;
        csrRecord.csr_Region__c = csrData.region;
        csrRecord.csr_District__c = csrData.district;
        csrRecord.csr_Currency_Code__c = csrData.currencyCode;
        csrRecord.csr_RSM_Name__c = csrData.rsmName;
        if(getReverseStatusMap().get(csrData.status) != 'S'){
            csrRecord.csr_Status__c = getReverseStatusMap().get(csrData.status);
        }
        if(csrData.expedite == null){
            csrRecord.csr_Expedite__c = false;
        }else{
            csrRecord.csr_Expedite__c = csrData.expedite;
        }
        if(csrData.dealerAction == null){
            csrRecord.csr_Dealer_Action__c = false;
        }else{
            csrRecord.csr_Dealer_Action__c = csrData.dealerAction;
        }
        if(csrData.internalCheckbox == null){
            csrRecord.csr_Internal_Checkbox__c = false;
        }else{
            csrRecord.csr_Internal_Checkbox__c = csrData.internalCheckbox;
        }
    }    
    
    /**
* Creates or updates CSR Line records for a given CSR.
* Deletes records in recordsToDeleteIds.
* Returns updated CSR line wrappers with record Ids.
*/
    private static List<CsrLineWrapper> saveCsrLines(Id csrHeaderId, String csrLines, List<Id> recordsToDeleteIds) {
        List<CsrLineWrapper> csrLinesData = 
            (List<CsrLineWrapper>) JSON.deserialize(csrLines, List<CsrLineWrapper>.class);
        Map<Id, CSR_Line__c> existingMap = new Map<Id, CSR_Line__c>();
        Set<Id> incomingIds = new Set<Id>();
        
        for (CsrLineWrapper w : csrLinesData) if (w.id != null) incomingIds.add(w.id);
        if (!incomingIds.isEmpty()) existingMap = csr_CSRLineSelector.getCSRlinesByIds(incomingIds);
        
        List<CSR_Line__c> linesToUpsert = new List<CSR_Line__c>();
        Map<CsrLineWrapper, CSR_Line__c> wrapperToLineMap = new Map<CsrLineWrapper, CSR_Line__c>();
        
        for (CsrLineWrapper w : csrLinesData) {
            CSR_Line__c line = (w.id != null && existingMap.containsKey(w.id)) 
                ? existingMap.get(w.id) 
                : new CSR_Line__c(CSR__c = csrHeaderId);
            
            mapCSRLineFields(line, w);
            
            wrapperToLineMap.put(w, line);
            linesToUpsert.add(line);
        }
        
        if (recordsToDeleteIds != null && !recordsToDeleteIds.isEmpty()) {
            delete csr_CSRLineSelector.getForDelete(recordsToDeleteIds);
        }
        
        if (!linesToUpsert.isEmpty()) {
            upsert linesToUpsert;
        }
        
        for (CsrLineWrapper w : wrapperToLineMap.keySet()) {
            CSR_Line__c line = wrapperToLineMap.get(w);
            w.id = line.Id;
            w.csr = line.CSR__c;
        }
        
        return new List<CsrLineWrapper>(wrapperToLineMap.keySet());
    }
    
    // --- Mapping helper for CSR Line ---
    private static void mapCSRLineFields(CSR_Line__c line, CsrLineWrapper w) {
        line.Name                         = w.lineNumber;
        line.csr_Best_Net__c              = w.bestNet;
        line.csr_Competitor__c            = (w.competitor != null) ? w.competitor.CompetitorCode : null;
        line.csr_Competitor_Brand__c      = w.competitorBrand;
        line.csr_Competitor_P_N__c        = w.competitorP_N;
        line.csr_Competitor_Price__c      = w.competitorPrice;
        line.Csr_Price__c                 = w.csrPrice;
        line.csr_Discount__c              = w.discount;
        line.csr_Part_Description__c      = w.partDesc;
        line.csr_Part_Type__c             = w.partType;
        line.csr_Parts_Number__c          = w.partNumber;
        line.csr_PPD_MRG__c               = w.ppdMrg;
        line.csr_Quantity__c              = w.qty;
        line.csr_Requested_Discount__c    = w.requestedDiscount;
        line.csr_Stock_Class__c           = w.stockClass;
        line.csr_W_D__c                   = w.channel;
        line.csr_Landing_Cost__c          = w.landingCost;
        line.csr_STDDLERNET__c            = w.stddlrnet;
        line.csr_Part_Type_Description__c = w.PartTypeDesc;
        line.csr_Cancel_Reason__c         = w.cancelReason;
        line.csr_Marketing_Review__c      = w.isMRChecked == null ? false : w.isMRChecked;
        line.csr_Exception_Comment__c	  = w.exceptionComment;
        line.csr_Pricing_Alert__c		  = w.pricingAlert;
        if (String.isNotBlank(w.status)) {
            line.csr_Status__c = getReverseStatusMap().get(w.status);
        }
    }
    /**
* Fetches CSR Line records by CSR Id.
* Converts them into CsrLineWrapper objects with status label mapping.
*/
    private static List<CsrLineWrapper> getCSRLines(Id csrId) {
        List<CsrLineWrapper> wrapperList = new List<CsrLineWrapper>();
        
        List<CSR_Line__c> lines = csr_CSRLineSelector.getCSRlinesByCSRId(csrId);
        
        for (CSR_Line__c line : lines) {
            CsrLineWrapper w = new CsrLineWrapper();
            w.id = line.Id;
            w.lineNumber = line.Name;
            w.partType = line.csr_Part_Type__c;
            w.partDesc = line.csr_Part_Description__c;
            w.discount = line.csr_Discount__c;
            w.csrPrice = line.Csr_Price__c;
            w.competitorPrice = line.csr_Competitor_Price__c;
            w.competitorP_N = line.csr_Competitor_P_N__c;
            w.competitorBrand = line.csr_Competitor_Brand__c;
            w.competitor = new CompetitorWrapper();
            w.competitor.CompetitorCode = line.csr_Competitor__c;
            w.bestNet = line.csr_Best_Net__c;
            w.channel = line.csr_W_D__c;
            w.stockClass = line.csr_Stock_Class__c;
            w.requestedDiscount = line.csr_Requested_Discount__c;
            w.qty = line.csr_Quantity__c;
            w.partNumber = line.csr_Parts_Number__c;
            w.ppdMrg = line.csr_PPD_MRG__c;
            w.landingCost = line.csr_Landing_Cost__c;
            w.stddlrnet = line.csr_STDDLERNET__c;
            w.PartTypeDesc = line.csr_Part_Type_Description__c;
            w.csr = line.CSR__c;
            w.cancelReason=line.csr_Cancel_Reason__c;
            w.isMRChecked=line.csr_Marketing_Review__c;
            w.status = getStatusMap().get(line.csr_Status__c); 
            w.exceptionComment = line.csr_Exception_Comment__c;
            w.pricingAlert = line.csr_Pricing_Alert__c;
            
            wrapperList.add(w);
        }
        
        return wrapperList;
    }
    
    /**
* Fetches CSR__c record by Id with additional CreatedBy and AssignedTo names.
* Returns CSRWrapper containing record and display fields.
*/
    
    private static CSRWrapper fetchCsrById(Id csrId) {
        if (csrId == null) {
            throw new AuraHandledException('CSR Id is required.');
        }
        
        CSR__c csr = csr_CSRSelector.getCSRById(csrId);
        if (csr == null) {
            throw new AuraHandledException('No CSR found with the provided CSR Id.');
        }
        
        CSRWrapper wrapper = new CSRWrapper();
        wrapper.csrRecord = csr;
        wrapper.csrRecord.csr_Status__c =getStatusMap().get(csr.csr_Status__c);
        // Collect all User Ids (CreatedBy + AssignedTo)
        Set<Id> userIds = new Set<Id>();
        userIds.add(csr.CreatedById);
        
        if (csr.csr_Assigned_To__c != null) {
            userIds.add(csr.csr_Assigned_To__c);
        }
        
        // Fetch all users in one query
        Map<Id, User> userMap = new Map<Id, User>(UserDAO.getById(userIds));
        
        // Assign CreatedBy name
        if (userMap.containsKey(csr.CreatedById)) {
            User createdBy = userMap.get(csr.CreatedById);
            wrapper.createdByName = createdBy.FirstName + ' ' + createdBy.LastName;
        } else {
            wrapper.createdByName = '';
        }
        
        // Assign AssignedTo name
        if (csr.csr_Assigned_To__c != null && userMap.containsKey(csr.csr_Assigned_To__c)) {
            User assignedTo = userMap.get(csr.csr_Assigned_To__c);
            wrapper.assignToName = assignedTo.FirstName + ' ' + assignedTo.LastName;
        } else {
            wrapper.assignToName = '';
        }
        
        return wrapper;
    }
    @AuraEnabled
    public static String createCSRAndLineInASI(String requestObj,Id csrId) {
        try {
            System.debug('Entering createCSRAndLineInASI ---Input paramenter requestObj'+ requestObj +
                         '/n csrId' + csrId );
            System.debug('payload'+ requestObj);
            CSR__c csrRecord =csr_CSRSelector.getCSRById(csrId);
            
            Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(requestObj);
            
            payloadMap.put('CreateDate', Integer.valueOf(csrRecord.CreatedDate.format('yyyyMMdd'))); 
            payloadMap.put('CreateBy', csrRecord.CreatedBy.FirstName);
            String updatedPayload = JSON.serialize(payloadMap);
            System.debug('updatedPayload createCSRAndLineInASI for ASI' +updatedPayload);
            Map<String, Object> calloutDetails = new Map<String, Object>{
                'endpoint'         => '/sales-part/CompetitiveSalesRequest/v1/GWPRCreateCSR',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method'           => 'POST',
                    'body'             => updatedPayload,
                    'classname'        => 'csr_CreateCSRController'
                    };
                        
                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('API Raw Response => ' + resultData);
            
            if (String.isBlank(resultData)) {
                return 'Empty response from API.';
            }
            
            CsrResponseWrapperForASI responseObj = 
                (CsrResponseWrapperForASI) JSON.deserialize(resultData, CsrResponseWrapperForASI.class);
            
            if (responseObj != null && 
                responseObj.ErrorResponse != null && 
                responseObj.ErrorResponse.ErrorMessages != null && 
                !responseObj.ErrorResponse.ErrorMessages.isEmpty()) {
                    
                    return responseObj.ErrorResponse.ErrorMessages[0];
                }
            
            return JSON.serialize(responseObj);
            
        } catch (Exception e) {
            System.debug('Exception in createCSRAndLineInASI: ' + e.getMessage() +'\n----'+e.getStackTraceString());            
            
            throw new AuraHandledException(e.getMessage());
            
            
        }
    }
    @AuraEnabled
    public static String updateCsrAndLinesInASI(String requestObj,Boolean callDealerActionAPI) {
        try {
            System.debug('>>> Entering updateCsrAndLinesInASI');
            System.debug('Payload: ' + requestObj  +'\ncallDealerActionAPI' + callDealerActionAPI);
            
            Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(requestObj);
            if (callDealerActionAPI && payloadMap != null) {
                String csrNumber = (String) payloadMap.get('CSRNumber');
                Integer phase = (Integer) payloadMap.get('Phase');
                
                if (csrNumber != null && phase != null) {
                    String status = updateHeaderStatusForDealerAction(csrNumber, phase);
                    payloadMap.put('CSRStatus', status);
                }
            }
            
            if (payloadMap.containsKey('CSRStatus')) {
                String sfStatus = (String) payloadMap.get('CSRStatus');
                String apiStatus = getReverseStatusMap().get(sfStatus);
                if (apiStatus != null) {
                    payloadMap.put('CSRStatus', apiStatus);
                }
            }
            
            if (payloadMap.containsKey('CSRILine')) {
                List<Object> csrLines = (List<Object>) payloadMap.get('CSRILine');
                for (Object lineObj : csrLines) {
                    Map<String, Object> lineMap = (Map<String, Object>) lineObj;
                    if (lineMap.containsKey('LineStatus')) {
                        String sfLineStatus = (String) lineMap.get('LineStatus');
                        String apiLineStatus = getReverseStatusMap().get(sfLineStatus);
                        if (apiLineStatus != null) {
                            lineMap.put('LineStatus', apiLineStatus);
                        }
                    }
                }
            }
            
            System.debug('>>> Final payloadMap before callout => ' + JSON.serializePretty(payloadMap));
            
            Map<String, Object> calloutDetails = new Map<String, Object>{
                'endpoint'         => '/sales-part/CompetitiveSalesRequest/v1/GWPRUpdateCSR',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method'           => 'POST',
                    'body'             => JSON.serialize(payloadMap),
                    'classname'        => 'csr_CreateCSRController'
                    };
                        
                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('API Raw Response => ' + resultData);
            
            if (String.isBlank(resultData)) {
                throw new AuraHandledException('Empty response from API.');
            }
            
            // Deserialize
            UpdateCsrResponse response = (UpdateCsrResponse) JSON.deserialize(resultData, UpdateCsrResponse.class);
            System.debug('Deserialized Response => ' + JSON.serializePretty(response));
            
            if (response != null && response.ErrorResponse != null 
                && response.ErrorResponse.ErrorMessages != null 
                && !response.ErrorResponse.ErrorMessages.isEmpty()) {
                    throw new AuraHandledException(response.ErrorResponse.ErrorMessages[0]);
                }
            
            if (response != null && response.Data != null && response.Data.Status != null) {
                String label = getStatusMap().get(response.Data.Status);
                if (label != null) {
                    response.Data.Status = label;
                }
            }
            
            if (response != null && response.Data != null && response.Data.CsrLines != null) {
                for (CsrLineResponse line : response.Data.CsrLines) {
                    if (line.LineStat != null) {
                        String sfStatus = getStatusMap().get(line.LineStat);
                        if (sfStatus != null) {
                            line.LineStat = sfStatus;
                        }
                    }
                }
            }
            
            return JSON.serialize(response);
            
        } catch (Exception e) {
            System.debug('Exception in updateCsrAndLinesInASI: ' + e.getMessage() + '\n' + e.getStackTraceString());
            throw new AuraHandledException('Unable to update CSR and Lines: ' + e.getMessage());
        }
    }
    @AuraEnabled
    public static String updateHeaderStatusForDealerAction(String csrNumber, Integer phase) {
        System.debug('>>> Entering updateHeaderStatusForDealerAction with csrNumber: ' + csrNumber + ', phase: ' + phase);
        String asiUsername = 
            (EDealerUserUtils.fetchLoggedInUserdetails() != null &&
             String.isNotBlank(EDealerUserUtils.fetchLoggedInUserdetails().ASI_Username__c))
            ? EDealerUserUtils.fetchLoggedInUserdetails().ASI_Username__c
            : '';
        
        // Prepare payload
        Map<String, Object> payloadMap = new Map<String, Object>{
            'CSRNumber' => csrNumber,
                'Phase'     => phase,
                'UserName'  => asiUsername
                };
                    
                    String requestBody = JSON.serialize(payloadMap);
        
        // Prepare callout details
        Map<String, String> calloutDetails = new Map<String, String>{
            'endpoint'         => '/sales-part/CompetitiveSalesRequest/v1/GWWaitForDealer',
                'namedCredentials' => 'callout:GatewayApplication',
                'method'           => 'POST',
                'body'             => requestBody,
                'classname'        => 'csr_CreateCSRController'
                };
                    
                    // Make callout
                    String resultData = EDealerHttpHandler.callout(calloutDetails);
        System.debug('WaitForDealer raw response => ' + resultData);
        
        if (String.isBlank(resultData)) {
            throw new AuraHandledException('Empty response from WaitForDealer');
        }
        
        // Deserialize response
        Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(resultData);
        
        // Extract only StatusCode and map to Salesforce label
        String statusLabel = '';
        if (respMap.containsKey('Data')) {
            Map<String, Object> dataMap = (Map<String, Object>) respMap.get('Data');
            if (dataMap.containsKey('StatusCode')) {
                String code = (String) dataMap.get('StatusCode');
                Map<String, String> statusMap = getStatusMap();
                if (statusMap.containsKey(code)) {
                    statusLabel = statusMap.get(code);
                }
            }
        }
        
        return statusLabel;
        
    } 
    @AuraEnabled
    public static List<CancelReasonOption> getCancelReasonsFromAPI() {
        List<CancelReasonOption> reasons = new List<CancelReasonOption>();
        try {
            Map<String, Object> calloutDetails = new Map<String, Object>{
                'endpoint'         => '/sales-part/CompetitiveSalesRequest/v1/GetCancelReasons',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method'           => 'GET',
                    'classname'        => 'csr_CreateCSRController'
                    };
                        
                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('Cancel Reasons API Raw Response => ' + resultData);
            
            if (String.isBlank(resultData) || resultData.contains('apiError')) {
                return reasons;
            }
            
            CancelReasonResponse response =
                (CancelReasonResponse) JSON.deserialize(resultData, CancelReasonResponse.class);
            
            if (response != null && response.CancelReasons != null) {
                for (CancelReasonWrapper reason : response.CancelReasons) {
                    reasons.add(new CancelReasonOption(reason.ReasonCode, reason.ReasonDescription));
                }
            }
            
        } catch (Exception e) {
            System.debug('Error fetching cancel reasons: ' + e.getMessage());
        }
        return reasons;
    }
    
    @AuraEnabled
    public static Boolean denyCSRLinesAPI(String denyCsrLinesPayload) {
        System.debug('>>> Entering denyCSRLines ' + denyCsrLinesPayload);
        try {
            Map<String, Object> calloutDetails = new Map<String, Object>{
                'endpoint' => '/sales-part/CompetitiveSalesRequest/v1/DenyCSRLines',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method' => 'POST',
                    'body' => denyCsrLinesPayload,
                    'classname' => 'csr_CreateCSRController'
                    };
                        System.debug('denyCSRLinesAPI raw response : ' + calloutDetails);
            
            String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('<<< Exiting denyCSRLines with return : ' + resultData);
            return !resultData.contains('apiError');
        }
        catch (Exception e) {
            System.debug('ERROR deleteDelegation: ' + e.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static void updateDeniedCSRLines(List<Id> csrLineIds, String reasonCode) {
        if (csrLineIds == null || csrLineIds.isEmpty()) return;
        
        Map<Id, CSR_Line__c> csrLineMap =
            csr_CSRLineSelector.getCSRlinesByIds(new Set<Id>(csrLineIds));
        
        if (csrLineMap.isEmpty()) {
            return;
        }
        
        List<CSR_Line__c> linesToUpdate = new List<CSR_Line__c>();
        
        for (CSR_Line__c line : csrLineMap.values()) {
            line.csr_Status__c = 'R';
            line.csr_Deny_Reason_Code__c = reasonCode;
            linesToUpdate.add(line);
        }
        
        if (!linesToUpdate.isEmpty()) {
            update linesToUpdate;
        }
    }

    @AuraEnabled
    public static Boolean reworkCSRLinesAPI(String reworkCsrLinesPayload) {
        System.debug('>>> Entering reworkCSRLines ' + reworkCsrLinesPayload);
        try {
            Map<String, Object> calloutDetails = new Map<String, Object>{
                'endpoint' => '/sales-part/CompetitiveSalesRequest/v1/ReworkCSRLines',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method' => 'POST',
                    'body' => reworkCsrLinesPayload,
                    'classname' => 'csr_CreateCSRController'
                    };
            System.debug('reworkCSRLinesAPI raw response : ' + calloutDetails);
            
            String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('<<< Exiting reworkCSRLines with return : ' + resultData);
            return !resultData.contains('apiError');
        }
        catch (Exception e) {
            System.debug('ERROR deleteDelegation: ' + e.getMessage());
            return false;
        }
    }

    @AuraEnabled
    public static void updateReworkedCSRLines(List<Id> csrLineIds) {
        if (csrLineIds == null || csrLineIds.isEmpty()) return;
        
        Map<Id, CSR_Line__c> csrLineMap = csr_CSRLineSelector.getCSRlinesByIds(new Set<Id>(csrLineIds));
        
        if (csrLineMap.isEmpty()) return;
        
        List<CSR_Line__c> linesToUpdate = new List<CSR_Line__c>();
        Set<Id> parentCsrIds = new Set<Id>();
        
        for (CSR_Line__c line : csrLineMap.values()) {
            line.csr_Status__c = 'Rework';
            linesToUpdate.add(line);

            if (line.CSR__c != null) {
                parentCsrIds.add(line.CSR__c);
            }
        }
        
        if (!linesToUpdate.isEmpty()) {
            update linesToUpdate;
        }

        if (!parentCsrIds.isEmpty()) {
            List<CSR__c> csrsToUpdate = new List<CSR__c>();

            for (Id csrId : parentCsrIds) {
                CSR__c csr = csr_CSRSelector.getCSRById(csrId);
                csr.csr_Status__c = 'Rework';
                csrsToUpdate.add(csr);
            }

            if (!csrsToUpdate.isEmpty()) {
                update csrsToUpdate;
            }
        }
    }
    
    @AuraEnabled
    public static CancelUncancelResponse cancelAndUncancelCSRLines(String requestObj) {
        try {
            System.debug('>>> Entering cancelAndUncancelCSRLines with payload: ' + requestObj);
            String asiUsername = 
                (EDealerUserUtils.fetchLoggedInUserdetails() != null &&
                 String.isNotBlank(EDealerUserUtils.fetchLoggedInUserdetails().ASI_Username__c))
                ? EDealerUserUtils.fetchLoggedInUserdetails().ASI_Username__c
                : '';
            // Deserialize payload
            Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(requestObj);
            
            // Put Username into payload
            payloadMap.put('UserName', asiUsername);
            
            // Serialize back to string
            String updatedRequest = JSON.serialize(payloadMap);
            Map<String, String> calloutDetails = new Map<String, String>{
                'endpoint'         => '/sales-part/CompetitiveSalesRequest/v1/GWPRCancelCSRLines',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method'           => 'POST',
                    'body'             => updatedRequest,
                    'classname'        => 'csr_CreateCSRController'
                    };
                        
                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('GWPRCancelCSRLines raw response => ' + resultData);
            
            if (String.isBlank(resultData)) {
                throw new AuraHandledException('Empty response from GWPRCancelCSRLines');
            }
            
            CancelUncancelResponse resp =
                (CancelUncancelResponse) JSON.deserialize(resultData, CancelUncancelResponse.class);
            
            //  Replace status code with Salesforce label
            if (resp != null && resp.data != null && resp.data.csrLinesO != null) {
                Map<String, String> statusMap = getStatusMap();
                for (cancelUncancelLine line : resp.data.csrLinesO) {
                    if (line.status != null && statusMap.containsKey(line.status)) {
                        line.status = statusMap.get(line.status);
                    }
                    if (line.cancelReason == null) {
                        line.cancelReason = '';
                    }
                }
            }
            
            return resp;
            
        } catch (Exception e) {
            System.debug(' Exception in cancelAndUncancelCSRLines: ' + e.getMessage());
            throw new AuraHandledException('Unable to cancel CSRLines: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static String submitCSRForApprovalApi(Integer csrNumber, Integer phase, String userName) {
        try {
            System.debug('>>> Entering submitCSRForApprovalApi with CSRNumber: ' + csrNumber + ', Phase: ' + phase + ', UserName: ' + userName);
            
            // Compose payload map
            Map<String, Object> bodyMap = new Map<String, Object>{
                'CSRNumber' => csrNumber,
                    'Phase' => phase,
                    'UserName' => userName
                    };
                        
                        String requestBody = JSON.serialize(bodyMap);
            
            Map<String, String> calloutDetails = new Map<String, String>{
                'endpoint'         => '/sales-part/CompetitiveSalesRequest/v1/SubmitCSRForApproval',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method'           => 'POST',
                    'body'             => requestBody,
                    'classname'        => 'csr_CreateCSRController'
                    };
                        
                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('submitCSRForApprovalApi raw response => ' + resultData);
            
            if (String.isBlank(resultData)) {
                throw new AuraHandledException('Empty response from SubmitCSRForApproval API');
            }
            
            return resultData;
            
        } catch (Exception e) {
            System.debug('Exception in submitCSRForApprovalApi: ' + e.getMessage());
            throw new AuraHandledException('Unable to submit CSR for approval: ' + e.getMessage());
        }
    }
    
    
    
    /*Copy CSR*/
    @AuraEnabled
    public static CSRWithLinesWrapper copyCSR(Id originalCsrId) {
        if (originalCsrId == null) {
            throw new AuraHandledException('Original CSR Id is required to copy.');
        }
        
        CSRWithLinesWrapper copyWrapper = new CSRWithLinesWrapper();
        
        try {
            // Fetch original CSR record with necessary fields
            CSR__c originalCsr = csr_CSRSelector.getCSRById(originalCsrId);
            originalCsr.csr_Dealer_Action__c = FALSE;
            originalCsr.CSR_Number__c = '';
            originalCsr.csr_Phase__c = null ;
            // Clone CSR record (shallow copy)
            CSR__c newCsr = originalCsr.clone(false, true, false, false);
            
            // Reset Id to null for insert
            newCsr.Id = null;
            
            newCsr.csr_Status__c = getReverseStatusMap().get('Holding');
            // Insert new CSR record
            insert newCsr;
            
            // Fetch original CSR lines
            List<CSR_Line__c> originalLines =csr_CSRLineSelector.getCSRlinesByCSRId(originalCsrId);
            
            List<CSR_Line__c> newLines = new List<CSR_Line__c>();
            for (CSR_Line__c line : originalLines) {
                CSR_Line__c newLine = line.clone(false, true, false, false);
                newLine.Id = null;
                newLine.CSR__c = newCsr.Id;
                newLine.csr_Status__c = getReverseStatusMap().get('Holding');
                newLine.csr_Best_Net__c = line.csr_Best_Net__c;
                newLine.csr_Exception_Comment__c = '';
                newLine.csr_Pricing_Alert__c = '';
                newLines.add(newLine);
            }
            
            if (!newLines.isEmpty()) {
                insert newLines;
            }
            
            // Prepare wrappers for return
            CSRWrapper csrWrapper = new CSRWrapper();
            csrWrapper.csrRecord = newCsr;
            csrWrapper.dealerGroup = newCsr.csr_DealerGroup__c;
            csrWrapper.dealerName = newCsr.csr_Dealer_Name__c;
            csrWrapper.division = newCsr.csr_DealerDivision__c;
            // Optionally set createdByName and assignToName if needed (null or empty for copied CSR)
            csrWrapper.createdByName = '';
            csrWrapper.assignToName = '';
            
            List<CsrLineWrapper> lineWrappers = new List<CsrLineWrapper>();
            for (CSR_Line__c l : newLines) {
                CsrLineWrapper lineWrapper = new CsrLineWrapper();
                lineWrapper.id = l.Id;
                lineWrapper.lineNumber = null; // will be set by client UI
                lineWrapper.partNumber = l.csr_Parts_Number__c;
                lineWrapper.partDesc = l.csr_Part_Description__c;
                lineWrapper.qty = l.csr_Quantity__c;
                lineWrapper.channel = l.csr_W_D__c;
                lineWrapper.competitor = new CompetitorWrapper();
                lineWrapper.competitor.CompetitorCode = l.csr_Competitor__c;
                lineWrapper.competitorP_N = l.csr_Competitor_P_N__c;
                lineWrapper.csrPrice = l.Csr_Price__c;
                lineWrapper.competitorBrand = l.csr_Competitor_Brand__c;
                lineWrapper.ppdMrg = l.csr_PPD_MRG__c;
                lineWrapper.discount = l.csr_Discount__c;
                lineWrapper.competitorPrice = l.csr_Competitor_Price__c;
                lineWrapper.stockClass = l.csr_Stock_Class__c;
                lineWrapper.requestedDiscount = l.csr_Requested_Discount__c;
                lineWrapper.landingCost = l.csr_Landing_Cost__c;
                lineWrapper.stddlrnet = l.csr_STDDLERNET__c;
                lineWrapper.PartTypeDesc = l.csr_Part_Type_Description__c;
                lineWrapper.partType = l.csr_Part_Type__c;
                lineWrapper.status = 'Holding';
                lineWrappers.add(lineWrapper);
            }
            
            copyWrapper.csrRecord = csrWrapper;
            copyWrapper.csrLines = lineWrappers;
            
            return copyWrapper;
            
        } catch (Exception ex) {
            throw new AuraHandledException('Failed to copy CSR: ' + ex.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static String fetchCSRRecordFromAPI(Integer csrNumber, Integer phase) {
        System.debug('>>> Entering fetchCSRRecordFromAPI -- csrNumber=' + csrNumber + ', phase=' + phase);
        
        if (csrNumber == null || phase == null) {
            throw new AuraHandledException('Both CSRNumber and Phase are required.');
        }
        
        CSRWithLinesWrapper result = new CSRWithLinesWrapper();
        
        Map<String, Object> payloadMap = new Map<String, Object>{
            'CSRNumber' => csrNumber,
                'Phase' => phase
                };
                    
                    String requestBody = JSON.serialize(payloadMap);
        
        Map<String, Object> calloutDetails = new Map<String, Object>{
            'endpoint' => '/sales-part/CompetitiveSalesRequest/v1/GWPRGetCSRRecord',
                'namedCredentials' => 'callout:GatewayApplication',
                'method' => 'POST',
                'body' => requestBody,
                'classname' => 'csr_CreateCSRController'
                };
                    
                    String resultData = EDealerHttpHandler.callout(calloutDetails);
        resultData =resultData.replace('"True"', 'true').replace('"False"', 'false');	
        if (String.isBlank(resultData)) {
            throw new AuraHandledException('Empty response from API.');
        }
        
        return resultData;
    }
    
    
    @AuraEnabled
    public static Id saveCSRApiResponse(String apiResponseJson,Integer csrNumber, Integer phase) {
        SaveResultWrapper result = new SaveResultWrapper();
        try {
            system.debug('apiResponseJson'+apiResponseJson);
            // Deserialize API response JSON to wrapper class
            ApiCSRResponseWrapper apiResponse = (ApiCSRResponseWrapper) JSON.deserialize(apiResponseJson, ApiCSRResponseWrapper.class);
            
            if (apiResponse == null || apiResponse.Data == null) {
                throw new AuraHandledException('No data found in API response.');
            }
            
            ApiCSRData data = apiResponse.Data;
            
            // Get maps
            Map<String, String> statusMap = getStatusMap();         // API value -> Label
            Map<String, String> reverseStatusMap = getReverseStatusMap(); // Label -> API value
            
            // Convert API status code to label (e.g., 'X' -> 'Routing')
            String statusLabel = statusMap.containsKey(data.Status) ? statusMap.get(data.Status) : data.Status;
            
            // Map API data to CSRSaveWrapper
            system.debug('saveCSRApiResponse csrNumber'+csrNumber);
            system.debug('saveCSRApiResponse String.valueof(csrNumber)'+String.valueof(csrNumber));
            CSRSaveWrapper csrSaveWrapper = new CSRSaveWrapper();
            csrSaveWrapper.csrNumber = String.valueof(csrNumber); // Adjust if CSRNumber is different
            csrSaveWrapper.phase = phase; // Set if available
            csrSaveWrapper.dealerCode = data.DealerId;
            csrSaveWrapper.dealerName = data.DlrName;
            csrSaveWrapper.country = data.Cntry;
            csrSaveWrapper.currencyCode = data.CurrCode;
            csrSaveWrapper.exchangeRate = data.CurrExchRate;
            csrSaveWrapper.district = data.District;
            csrSaveWrapper.dpmName = data.DPMName;
            csrSaveWrapper.region = data.Region;
            csrSaveWrapper.rsmName = data.RSMName;
            csrSaveWrapper.dealerGroup = data.DealerGroup;
            csrSaveWrapper.customerName = data.CustName;
            csrSaveWrapper.competitiveType = 'B';
            csrSaveWrapper.dealerType = data.DlrType;
            csrSaveWrapper.csrType = data.CSRType;
            csrSaveWrapper.status = statusLabel;
            csrSaveWrapper.dealerDivision = data.DealerDiv;
            csrSaveWrapper.effectiveDate = String.valueOf(data.EffDate);
            csrSaveWrapper.expirationDate = String.valueOf(data.ExpDate);
            csrSaveWrapper.internalCheckbox = false; // Set default or map if available
            csrSaveWrapper.dealerAction = false; // Set default or map if available
            // Map other fields as needed
            
            // Serialize CSRSaveWrapper to JSON for saveCSRWithLines method
            String csrJson = JSON.serialize(csrSaveWrapper);
            
            // Map API header comments to string JSON (optional - not saved in this example)
            // Map API CsrLines to List<CsrLineWrapper>
            List<CsrLineWrapper> lineWrappers = new List<CsrLineWrapper>();
            if (data.CsrLines != null) {
                for (ApiCsrLine apiLine : data.CsrLines) {
                    CsrLineWrapper line = new CsrLineWrapper();
                    line.lineNumber = apiLine.LineNbr != null ? String.valueOf(apiLine.LineNbr) : null;
                    
                    // Map API line status code to Salesforce picklist label
                    String lineStatusLabel = statusMap.containsKey(apiLine.LineStat) ? statusMap.get(apiLine.LineStat) : apiLine.LineStat;
                    
                    line.status = lineStatusLabel;
                    line.channel = apiLine.Channel;
                    line.partType = apiLine.PartType;
                    line.PartTypeDesc = apiLine.PartTypeDesc;
                    line.stockClass = apiLine.ItemClass;
                    line.partNumber = apiLine.Itmid;
                    line.partDesc = apiLine.ItemDesc;
                    line.qty = apiLine.Quantity;
                    line.ppdMrg = apiLine.PPDMRG;
                    line.bestNet = apiLine.BestNet;
                    line.csrPrice = apiLine.CSRPrice;
                    line.discount = apiLine.LnDisc;
                    line.competitorPrice = apiLine.CompPrice;
                    line.competitor = new CompetitorWrapper();
                    line.competitor.CompetitorCode = apiLine.CompCode;
                    line.competitorBrand = apiLine.CompBrnd;
                    line.cancelReason = apiLine.CancelReasonCode;
                    // Map other fields if needed
                    
                    lineWrappers.add(line);
                }
            }
            String csrLinesJson = JSON.serialize(lineWrappers);
            
            // Call existing method to save CSR and lines
            result = saveCSRWithLines(csrJson, csrLinesJson, null, null);
            
        } catch (Exception e) {
            System.debug('Exception in saveCSRApiResponse: ' + e.getMessage() + '\n' + e.getStackTraceString());
            throw new AuraHandledException('Unable to save CSR from API response: ' + e.getMessage());
        }
        return result.csrData.id;
    }
    
    // Helper method to parse date from integer (YYYYMMDD)
    private static Datetime parseDateFromInt(Integer yyyymmdd) {
        if (yyyymmdd == null) return null;
        try {
            String dateStr = String.valueOf(yyyymmdd);
            if (dateStr.length() != 8) return null;
            Integer year = Integer.valueOf(dateStr.substring(0, 4));
            Integer month = Integer.valueOf(dateStr.substring(4, 6));
            Integer day = Integer.valueOf(dateStr.substring(6, 8));
            return Datetime.newInstanceGmt(year, month, day, 0, 0, 0);
        } catch (Exception e) {
            return null;
        }
    }
    
    
    @AuraEnabled
    public static Map<String, Object> updatePricingTarget(String payloadJSON) {
        try {
            // Deserialize incoming payload
            Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(payloadJSON);
            
            // Add default values for missing fields (assign 0 or default)
            if (!payloadMap.containsKey('DutyCost')) {
                payloadMap.put('DutyCost', 0);
            }
            if (!payloadMap.containsKey('FreightCost')) {
                payloadMap.put('FreightCost', 0);
            }
            if (!payloadMap.containsKey('OtherCost')) {
                payloadMap.put('OtherCost', 0);
            }
            if (!payloadMap.containsKey('RebateCost')) {
                payloadMap.put('RebateCost', 0);
            }
            if (!payloadMap.containsKey('DisplayCurrencyCode')) {
                payloadMap.put('DisplayCurrencyCode', 'USD');
            }
            if (!payloadMap.containsKey('UserName')) {
                // Fetch current user ASI username or fallback
                String asiUsername = '';
                User currentUser = [SELECT ASI_Username__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
                if (currentUser != null && String.isNotBlank(currentUser.ASI_Username__c)) {
                    asiUsername = currentUser.ASI_Username__c;
                }
                payloadMap.put('UserName', asiUsername);
            }
            if (!payloadMap.containsKey('IsForMarketingReview')) {
                payloadMap.put('IsForMarketingReview', 'false');
            }
            
            // Serialize updated payload
            String requestBody = JSON.serialize(payloadMap);
            
            // Prepare callout details
            Map<String, Object> calloutDetails = new Map<String, Object>{
                'endpoint' => '/sales-part/CompetitiveSalesRequest/v1/GWLineCalculations', // Update with actual endpoint
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method' => 'POST',
                    'body' => requestBody,
                    'classname' => 'csr_CreateCSRController'
                    };
                        
                        // Make the callout
                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('GWLineCalculations API Response => ' + resultData);
            
            if (String.isBlank(resultData)) {
                throw new AuraHandledException('Empty response from GWLineCalculations API.');
            }
            
            // Parse the response JSON into a map
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(resultData);
            
            // Extract nested "Data" map
            Map<String, Object> dataMap = new Map<String, Object>();
            if (responseMap.containsKey('Data') && responseMap.get('Data') != null) {
                dataMap = (Map<String, Object>) responseMap.get('Data');
            } else {
                // If no 'Data' field, return zeros or throw error as needed
                dataMap = new Map<String, Object>();
            }
            System.debug('dataMap.get PaccarMargin'+(Decimal)dataMap.get('PaccarMargin'));
            System.debug('dataMap.getFinalNet'+dataMap.get('FinalNet'));
            System.debug('dataMap.getDiscount'+dataMap.get('Discount'));
            // Extract values from nested 'Data'
            Decimal paccarMargin = dataMap.containsKey('PaccarMargin') ? (Decimal) dataMap.get('PaccarMargin') : 0;
            Decimal finalNet = dataMap.containsKey('FinalNet') ? (Decimal) dataMap.get('FinalNet') : 0;
            Decimal discount = dataMap.containsKey('Discount') ? (Decimal) dataMap.get('Discount') : 0;
            
            System.debug('paccarMargin'+paccarMargin);
            System.debug('finalNet'+finalNet);
            System.debug('discount'+discount);
            Map<String, Object> response = new Map<String, Object>();
            response.put('PaccarMargin', paccarMargin);
            response.put('FinalNet', finalNet);
            response.put('Discount', discount);
            System.debug('response'+response);
            return response; 
            
            
        } catch (Exception e) {
            System.debug('Exception in GWLineCalculations: ' + e.getMessage() + '\n' + e.getStackTraceString());
            throw new AuraHandledException('Failed to update GWLineCalculations: ' + e.getMessage());
        }
    }
    
     @AuraEnabled
    public static String callTerminateCSRLines(String requestObj) {
        try {
            System.debug('callTerminateCSRLines received requestObj: ' + requestObj);

            if (String.isBlank(requestObj)) {
                throw new AuraHandledException('Request object is empty');
            }

            Map<String, Object> payloadMap;

            // Check if input looks like JSON object string
            if (requestObj.trim().startsWith('{')) {
                payloadMap = (Map<String, Object>) JSON.deserializeUntyped(requestObj);
            } else {
                throw new AuraHandledException('Invalid request format, expected JSON string');
            }

            // Add UserName to each CSR line
            if (payloadMap.containsKey('CSRsIn')) {
                List<Object> csrsIn = (List<Object>) payloadMap.get('CSRsIn');
                String asiUsername = (EDealerUserUtils.fetchLoggedInUserdetails() != null &&
                                      String.isNotBlank(EDealerUserUtils.fetchLoggedInUserdetails().ASI_Username__c))
                    ? EDealerUserUtils.fetchLoggedInUserdetails().ASI_Username__c
                    : '';
                for (Object obj : csrsIn) {
                    Map<String, Object> lineMap = (Map<String, Object>) obj;
                    lineMap.put('UserName', asiUsername);
                }
            }

            String updatedRequest = JSON.serialize(payloadMap);

            Map<String, String> calloutDetails = new Map<String, String>{
                'endpoint'         => '/sales-part/CompetitiveSalesRequest/v1/GWTerminateCSRLines',
                    'namedCredentials' => 'callout:GatewayApplication',
                    'method'           => 'POST',
                    'body'             => updatedRequest,
                    'classname'        => 'csr_CreateCSRController'
                    };

                        String resultData = EDealerHttpHandler.callout(calloutDetails);
            System.debug('Terminate Response: ' + resultData);

            if (String.isBlank(resultData)) {
                throw new AuraHandledException('Empty response from GWTerminateCSRLines API');
            }

            return resultData;

        } catch (Exception e) {
            System.debug('Exception in callTerminateCSRLines: ' + e.getMessage());
            throw new AuraHandledException('Unable to terminate CSR lines: ' + e.getMessage());
        }
    }


    @AuraEnabled
    public static void updateLocalCSRStatusAfterTermination(String csrNumber, Integer phase, List<Integer> terminatedLineNumbers) {
        // Use selector to get CSR record
        CSR__c csrRecord = csr_CSRSelector.getCSRByNumberAndPhase(csrNumber, phase);
        if (csrRecord == null) {
            throw new AuraHandledException('CSR not found.');
        }
        System.debug('csrRecord: ' + csrRecord);

        // Convert Integer line numbers to Strings for SOQL
        List<String> terminatedLineNumberStrings = new List<String>();
        for (Integer num : terminatedLineNumbers) {
            terminatedLineNumberStrings.add(String.valueOf(num));
        }

        // Use selector to get CSR lines by CSR Id and line numbers
        List<CSR_Line__c> linesToUpdate = csr_CSRLineSelector.getCSRLinesByCSRIdAndLineNumbers(csrRecord.Id, terminatedLineNumberStrings);
        System.debug('linesToUpdate: ' + linesToUpdate);

        // Update line statuses to 'T' (Terminated)
        for (CSR_Line__c line : linesToUpdate) {
            line.csr_Status__c = 'T';
        }
        update linesToUpdate;

        // Use selector to count active lines
        Integer activeLinesCount = csr_CSRLineSelector.countActiveLinesByCSRId(csrRecord.Id);
        System.debug('activeLinesCount: ' + activeLinesCount);

        if (activeLinesCount == 0) {
            // Update header status to 'T'
            csrRecord.csr_Status__c = 'T';
            update csrRecord;
        }
    }

    public class ApiCSRResponseWrapper {
        public ApiCSRData Data;
        public ApiErrorResponse ErrorResponse;
    }
    
    public class ApiCSRData {
        public String DealerId;
        public String DlrName;
        public String Cntry;
        public String CurrCode;
        public Decimal CurrExchRate;
        public String District;
        public String DPMName;
        public String Region;
        public String RSMName;
        public String DealerGroup;
        public String CustName;
        public String CompType;
        public String DlrType;
        public String CSRType;
        public String CsrUser;
        public String Chassi;
        public String InsComp;
        public Decimal WriteOff;
        public Decimal DlrDisc;
        public Decimal DurBid;
        public String ExpMarkUp;
        public String DealerDiv;
        public Integer CreateDate;
        public Integer EffDate;
        public Integer ExpDate;
        public String Status;
        public String IntCheck;
        public String AssignTo;
        public String CreateBy;
        public Decimal MinDSPMrg;
        public Decimal MinWHSMrg;
        public Decimal MinDisc;
        public Decimal MaxDisc;
        public Decimal MaxPropDisc;
        public List<ApiCSRLine> CsrLines;
        public List<ApiHeaderComment> HeaderCmts;
    }
    
    public class ApiCSRLine {
        public Integer LineNbr;
        public String LineStat;
        public String Channel;
        public String PartType;
        public String PartTypeDesc;
        public String ItemClass;
        public String Itmid;
        public String ItemDesc;
        public Decimal Quantity;
        public Decimal PPDMRG;
        public Decimal BestNet;
        public Decimal CSRPrice;
        public Decimal LnDisc;
        public Decimal CompPrice;
        public String CompCode;
        public String CompName;
        public String CompPart;
        public String CompBrnd;
        public String CancelReasonCode;
        public String CancelReasonDesc;
        public List<Object> LineCmts;
    }
    
    public class ApiHeaderComment {
        public String HCmtType;
        public Integer HCmtLine;
        public String HLngCode;
        public String HComment;
        public Integer HDte;
        public String HTimeAdded;
        public String HAddUser;
        public Integer HLstUpdDate;
        public String HLstUpdTime;
        public String HLstUpdUser;
    }
    
    public class ApiErrorResponse {
        public Boolean IsSuccess;
        public Integer ErrorMessagesCount;
        public List<String> ErrorMessages;
    }
    public class CancelReasonOption {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
        public CancelReasonOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
    
    public class CancelReasonResponse {
        public List<CancelReasonWrapper> CancelReasons;
    }
    
    public class CancelReasonWrapper {
        public String ReasonCode;
        public String ReasonDescription;
    }
    
    
    public class Dealer {
        @AuraEnabled public String DealerId { get; set; }
        @AuraEnabled public String DealerName { get; set; }
        @AuraEnabled public Id AccountId { get; set; }
    }
    
    public class DealerDetail {
        @AuraEnabled public String Dlrout { get; set; }
        @AuraEnabled public String Dlrname { get; set; }
        @AuraEnabled public String Dlrgroup { get; set; }
        @AuraEnabled public String Dlrgroupname { get; set; }
        @AuraEnabled public String Division { get; set; }
        @AuraEnabled public String Dpmname { get; set; }
        @AuraEnabled public String Country { get; set; }
        @AuraEnabled public String CurrencyCode { get; set; }
        @AuraEnabled public String RSMName { get; set; }
        @AuraEnabled public String Region { get; set; }
        @AuraEnabled public String District { get; set; }
        @AuraEnabled public String ExchRate { get; set; }
        @AuraEnabled public List<String> ErrMsg { get; set; }
    }
    
    public class GetDealersResponse {
        public List<Dealer> Dealers;
    }
    
    public class DealerInfoResponseWrapper {
        public DealerDetail Data;
        public DealerErrorResponse ErrorResponse;
    }
    
    public class DealerErrorResponse {
        public Boolean IsSuccess;
        public Integer ErrorMessagesCount;
        public List<String> ErrorMessages;
    }
    public class CsrLineWrapper {
        @AuraEnabled public Id id;
        @AuraEnabled public Boolean csrAlert;
        @AuraEnabled public Decimal bestNet;
        @AuraEnabled public Id csr;
        @AuraEnabled public CompetitorWrapper competitor;
        @AuraEnabled public String competitorBrand;
        @AuraEnabled public String competitorP_N;
        @AuraEnabled public Decimal competitorPrice;
        @AuraEnabled public String csrNumber;
        @AuraEnabled public Decimal csrPrice;
        @AuraEnabled public Decimal discount;
        @AuraEnabled public String name;
        @AuraEnabled public String partDesc;
        @AuraEnabled public String partType;
        @AuraEnabled public String partNumber;
        @AuraEnabled public String csrPhase;
        @AuraEnabled public Decimal ppdMrg;
        @AuraEnabled public Decimal csrPriorPrice;
        @AuraEnabled public Decimal csrPriorDiscount;
        @AuraEnabled public Decimal csrPriorPPDMrg;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Decimal requestedDiscount;
        @AuraEnabled public String status;
        @AuraEnabled public String stockClass;
        @AuraEnabled public String channel;
        @AuraEnabled public Decimal landingCost;
        @AuraEnabled public Decimal stddlrnet;
        @AuraEnabled public String lineNumber;
        @AuraEnabled public String PartTypeDesc; 
        @AuraEnabled public String cancelReason;  
        @AuraEnabled public Boolean isMRChecked; 
        @AuraEnabled public String exceptionComment;
        @AuraEnabled public String pricingAlert;
    }
    
    public class CompetitorWrapper {
        @AuraEnabled public String CompetitorName;
        @AuraEnabled public String Affiliation;
        @AuraEnabled public String City;
        @AuraEnabled public String State;
        @AuraEnabled public String PostalCode;
        @AuraEnabled public String Type;
        @AuraEnabled public String CompetitorCode;
    }
    public class SaveResultWrapper {
        @AuraEnabled public CSRSaveWrapper csrData;
        @AuraEnabled public List<CsrLineWrapper> csrLines;
    }
    public class CSRWrapper {
        @AuraEnabled public CSR__c csrRecord { get; set; }
        @AuraEnabled public String dealerGroup { get; set; }
        @AuraEnabled public String dealerName { get; set; }
        @AuraEnabled public String division { get; set; }
        @AuraEnabled public String createdByName { get; set; }
        @AuraEnabled public String assignToName { get; set; }
    }
    public class CSRWithLinesWrapper {
        @AuraEnabled public CSRWrapper csrRecord;       
        @AuraEnabled public List<CsrLineWrapper> csrLines; 
    }
    
    public class CSRSaveWrapper {
        @AuraEnabled public Id id;
        @AuraEnabled public Id accountId;
        @AuraEnabled public String csrNumber;
        @AuraEnabled public Integer phase;
        @AuraEnabled public String csrType;
        @AuraEnabled public String competitiveType;
        @AuraEnabled public String effectiveDate;
        @AuraEnabled public String expirationDate;
        @AuraEnabled public String dealerCode;
        @AuraEnabled public String dealerDivision;
        @AuraEnabled public String dealerGroup;
        @AuraEnabled public String dealerType;
        @AuraEnabled public String dealerName;
        @AuraEnabled public String customerName;
        @AuraEnabled public Id assignedTo;     
        @AuraEnabled public String assignedToName; 
        @AuraEnabled public Boolean internalCheckbox;
        @AuraEnabled public String status;
        @AuraEnabled public String dpmName ;
        @AuraEnabled public String country ;  
        @AuraEnabled public String currencyCode;
        @AuraEnabled public String region ;
        @AuraEnabled public String district ;
        @AuraEnabled public Decimal exchangeRate ;
        @AuraEnabled public String rsmName ;
        @AuraEnabled public Boolean expedite;
        @AuraEnabled public boolean dealerAction;
    }
    
    public class CsrResponseWrapperForASI {
        public DataWrapper Data;
        public ErrorResponseWrapperForASI ErrorResponse;
    }
    public class DataWrapper {
        public Integer CSRNumber;
        public Integer Phase;
        public List<CsrLineWrapperASIResponse> CsrLines; 
    }
    public class CsrLineWrapperASIResponse{
        public Integer LineNbr;
        public String Itmid;
        public String Channel;
        public Decimal Quantity;
        public List<ExceptionComments> ExceptionComments;
        public List<PricingAlerts> PricingAlerts;
    }
    public class ExceptionComments{
        public String ExceptionComment; 
    }
    public class PricingAlerts{
        public String PricingAlert; 
    }
    public class ErrorResponseWrapperForASI {
        public String IsSuccess;
        public List<String> ErrorMessages;
    }
    public class UpdateCsrResponse {
        public DataWrapperAfterUpdate Data;
        public String IsRequeryRequired;
        public ErrorResponseWrapperForASI ErrorResponse;
    }
    public class DataWrapperAfterUpdate {
        public String DealerId;
        public String DlrName;
        public String Cntry;
        public String CurrCode;
        public Decimal CurrExchRate;
        public String District;
        public String DPMName;
        public String Region;
        public String RSMName;
        public String DlrGroup;
        public String CustName;
        public String CompType;
        public String DlrType;
        public String CSRType;
        public String CsrUser;
        public String Chassi;
        public String InsComp;
        public Decimal WriteOff;
        public Decimal DlrDisc;
        public Decimal DurBid;
        public String ExpMarkUp;
        public String DealerDiv;
        public Integer CreateDate;
        public Integer EffDate;
        public Integer ExpDate;
        public String Status;
        public String IntCheck;
        public String AssignTo;
        public String CreateBy;
        public Decimal MinDSPMrg;
        public Decimal MinWHSMrg;
        public Decimal MinDisc;
        public Decimal MaxDisc;
        public Decimal MaxPropDisc;
        public List<CsrLineResponse> CsrLines;
    }
    
    public class CsrLineResponse {
        public Integer LineNbr;
        public String LineStat;
        public String Channel;
        public String PartType;
        public String PartTypeDesc;
        public String ItemClass;
        public String Itmid;
        public String ItemDesc;
        public Decimal Quantity;
        public Decimal PPDMRG;
        public Decimal CSRPrice;
        public Decimal LnDisc;
        public Decimal CompPrice;
        public String CompCode;
        public String CompName;
        public String CompPart;
        public String CompBrnd;
        public List<ExceptionComments> ExceptionComments;
        public List<PricingAlerts> PricingAlerts;
    }
    
    public class CancelUncancelResponse {
        @AuraEnabled public cancelUncancelData data;
        @AuraEnabled public ErrorResponseWrapperForASI errorResponse;
    }
    
    public class cancelUncancelData {
        @AuraEnabled public Integer csrNumber;
        @AuraEnabled public Integer phase;
        @AuraEnabled public List<cancelUncancelLine> csrLinesO;
    }
    
    public class cancelUncancelLine {
        @AuraEnabled public Integer lineNumber;
        @AuraEnabled public String partNumber;
        @AuraEnabled public String status;        // API status code (C = Cancelled, D = Development, etc.)
        @AuraEnabled public String cancelReason;
    }
    
}