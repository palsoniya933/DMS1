/**
 * @description EDealerSuggestedOrdersController used for SOF pages
 */
public without sharing class EDealerSuggestedOrdersController {
    /**
     * @description Check Is promo sof available for selected dealer location
     * @return is promo or not promo (true/false)
     */
    @AuraEnabled
    public static Boolean IsPromoAvailableForDealerLocation(String dealerCode){
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        System.debug('accList++'+accList);
        if(accList.isEmpty()){
            return false;
        }
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_TYPE_SOF, true);
        System.debug('EDealer_Suggested_Order__c'+lstSuggestedOrders);
        if(!lstSuggestedOrders.isEmpty()){
            return true;
        }
        return false;
    }
     /**
     * @description for All Parts tab on sof page
     * @return the all part data in wrapper list
     */
    @AuraEnabled
    public static List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> fetchDealerAllSuggestedPartsDetails(String dealerCode, Boolean isSpecialSOF){
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowList = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
         List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowPDCList = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
         List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowDSPList = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
         List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowDUALList = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
         List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowNONPACCARList = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
        
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
        } 
        //get List of suggested Orders
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_TYPE_SOF, isSpecialSOF);
        
        for(EDealer_Suggested_Order__c so : lstSuggestedOrders){
            if(so.Part_Category_Type__c == EDealerConstants.SO_PART_CATEGORY_TYPE_PDC){
                sowPDCList.add(new EDealerSuggestedOrderUtils.SuggestedOrderWrapper(so));
            }else if(so.Part_Category_Type__c == EDealerConstants.SO_PART_CATEGORY_TYPE_DSP){
                sowDSPList.add(new EDealerSuggestedOrderUtils.SuggestedOrderWrapper(so));
            } else if(so.Part_Category_Type__c == EDealerConstants.SO_PART_CATEGORY_TYPE_DUAL){
                sowDUALList.add(new EDealerSuggestedOrderUtils.SuggestedOrderWrapper(so));
            }else if(so.Part_Category_Type__c == EDealerConstants.SO_PART_CATEGORY_TYPE_NONPACCAR){
                sowNONPACCARList.add(new EDealerSuggestedOrderUtils.SuggestedOrderWrapper(so));
            }
        }
        sowList.addAll(sowPDCList);
        sowList.addAll(sowDSPList);
        sowList.addAll(sowDUALList);
        sowList.addAll(sowNONPACCARList);
        
        return sowList; 
    }
    /**
     * @description This will use to get the PDC suggested Order Details from salesforce (order type like EM, PDC etc..)
     * @return the pdc part data in wrapper list
     */
    @AuraEnabled
    public static List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> fetchDealerPDCSuggestedOrdersDetails(String dealerCode, Boolean isSpecialSOF){
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
        }
        //get List of suggested Orders
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowList = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_PART_CATEGORY_TYPE_PDC, EDealerConstants.SO_TYPE_SOF, isSpecialSOF);
        return sowList;
    }
    /**
     * @description This will use to get the DSP suggested Order Details from salesforce
     * @return the dsp part data in wrapper list
     */
    @AuraEnabled
    public static List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> fetchDealerDSPSuggestedOrdersDetails(String dealerCode, Boolean isSpecialSOF){
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
        }
        //get List of suggested Orders
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowList = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_PART_CATEGORY_TYPE_DSP, EDealerConstants.SO_TYPE_SOF, isSpecialSOF);
        return sowList;
    }
    /**
     * @description This will use to get the NON-PACCAR PARTS suggested Order Details from salesforce
     * @return the non-paccar part data in wrapper list
     */
    @AuraEnabled
    public static List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> fetchDealerNonPaccarSuggestedOrdersDetails(String dealerCode, Boolean isSpecialSOF){
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
        }
        //get List of suggested Orders
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowList = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_PART_CATEGORY_TYPE_NONPACCAR, EDealerConstants.SO_TYPE_SOF, isSpecialSOF);
        return sowList;
    }
    
    /**
     * @description This will use to get the DUAL suggested Order Details from salesforce
     * @return the dual part data in wrapper list
     */
    @AuraEnabled 
    public static List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> fetchDealerDUALSuggestedOrdersDetails(String dealerCode, Boolean isSpecialSOF){
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
        }
        //get List of suggested Orders
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> sowList = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_PART_CATEGORY_TYPE_DUAL, EDealerConstants.SO_TYPE_SOF, isSpecialSOF);
        return sowList;
    }
    /**
     * @description used to get sof additional created like created sof date etc..
     * @return the additional details in wrapper
     */
    @AuraEnabled
    public static sofAdditonalInformation sofDealerLocAdditionDetails(String dealerCode, Boolean isPromo){
        sofAdditonalInformation sofInfo = new sofAdditonalInformation();
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            throw new AuraHandledException('No Dealer location found in salesforce.');
        }
        
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_TYPE_SOF, isPromo);
        
        //no of sof generated for the dealer location
        sofInfo.sofCount = lstSuggestedOrders.size();
        
        for(EDealer_Suggested_Order__c suggestedOrder : lstSuggestedOrders){
            if(String.isNotBlank(suggestedOrder.SOF_Created_DT__c)){
                sofInfo.isDSI = (suggestedOrder.DBS_Type__c == EDealerConstants.DBS_DSI);
               /*
                List<String> tempList = suggestedOrder.SOF_Created_DT__c.split(' ');
                String tempDTString = tempList[0] + 'T' + tempList[1] + '-0800';
                System.debug('tempList   '+tempList);
                System.debug('tempDTString   '+tempDTString);
                //Convert to GMT Time Zone
                DateTime date1 = (DateTime)JSON.deserialize('"' + tempDTString + '"', DateTime.class);
                System.debug('date1  '+date1);
               */
                
                String dateTimeAPI= suggestedOrder.SOF_Created_DT__c;
                DateTime dt = DateTime.valueOfGmt(dateTimeAPI);
				String format = dt.formatGMT('MMMMM dd, yyyy hh:mm:ss a');
                
                //send GMT time to UI which will show as PST by lighting datetime 
                sofInfo.sofCreatedDate = format;
                //check the sof of MDI 360 0r overnight
                //Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
               // DateTime pstDT =DateTime.newInstance(date1.getTime() + tz.getOffset(date1));
                sofInfo.sofType = suggestedOrder.SOF_Type__c;
                break;
            }
        }
        return sofInfo;
    }
    
    /**
     * @description to handle addition detail and this detail send back to sof page
     */
    public class sofAdditonalInformation {
        @AuraEnabled
        public String sofCreatedDate;
        @AuraEnabled
        public String sofType;
        @AuraEnabled 
        public Boolean isDSI;
        @AuraEnabled 
        public Integer sofCount;
        /**
         * @description default Constructor
         */
        public sofAdditonalInformation(){
            isDSI = false;
            sofCount = 0;
        }
    }
    
    /**
     * @description fetch the sof created file dat time 
     * @return the DT of sof file based on dealercode
     */
    @AuraEnabled
    public static DateTime fetchSOFFileCreatedDate(String dealerCode){
        DateTime dt;
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return null;
        }
        
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_TYPE_SOF);
        
        for(EDealer_Suggested_Order__c suggestedOrder : lstSuggestedOrders){
            if(suggestedOrder.SOF_File_Date__c != null){
                dt = suggestedOrder.SOF_File_Date__c;
                break;
            }
        }
        
        return dt;
    }
    /**
     * @description This method will use to get the info about non paccar suggested parts available or not for dealer
     * @return return non paccar part availble or not for dealer 
     */
    @AuraEnabled
    public static Boolean fetchNonPaccarSuggestionInfoAvailability(String dealerCode){
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return false;
        }
        
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> lstSuggestedOrders = EDealerSuggestedOrderUtils.getSuggestedOrdersForToday(accList[0].Id, EDealerConstants.SO_PART_CATEGORY_TYPE_NONPACCAR, EDealerConstants.SO_TYPE_SOF);
        if(lstSuggestedOrders.size() > 0){
            return true;
        }
        return false;
    }
   
    /**
     * @description Add/update (upsert) selected Emergency Suggested orders in Cart
     */
    @AuraEnabled
    public static void upsertItemsInEmergencyCart(List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> suggestedOrders){        
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> pdcEmergencySuggestedOrders = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
		List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> dspEmergencySuggestedOrders = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();        
        
        String cartType = EDealerConstants.CART_TYPE_CART;
        String orderTypePDCEmergency = EDealerConstants.CART_ORDER_TYPE_EMERGENCY;
        String orderTypeDSPEmergency = EDealerConstants.CART_ORDER_TYPE_DSP_EMERGENCY;
        
        //suggested parts id
        Set<Id> partsIdSet = new Set<Id>();
        for(EDealerSuggestedOrderUtils.SuggestedOrderWrapper soWrap : suggestedOrders){
            if(soWrap.DualPartSelectedPriceType == 'DSP' && soWrap.checked == true){
                partsIdSet.add(soWrap.suggestedOrderId);
                dspEmergencySuggestedOrders.add(soWrap);
            }else if(soWrap.DualPartSelectedPriceType == 'PDC' && soWrap.checked == true){
                partsIdSet.add(soWrap.suggestedOrderId);
                pdcEmergencySuggestedOrders.add(soWrap);
            }
        }
        
        //query suggested parts
        List<EDealer_Suggested_Order__c> suggestedParts = EDealerSuggestedOrderUtils.getSuggestedOrdersForTodayByIds(partsIdSet); 
        //if suggested parts list empty if no part detail found in salesforce
        // or if suggested part list size not matched with the no. of parts which selected to create cart 
        if(suggestedParts.isEmpty() || suggestedParts.size() != (new List<Id>(partsIdSet)).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
        
        //check cart object update permission
        checkCartUpdateObjectPermissions();
        
        try{
            // call the method to insert/update the selected cart items (PDC Orders)
            if(!pdcEmergencySuggestedOrders.isEmpty()){
                upsertSelectedItemsInCart(pdcEmergencySuggestedOrders, cartType, orderTypePDCEmergency);
            }
            // call the method to insert/update the selected cart items (DSP Orders)
            if(!dspEmergencySuggestedOrders.isEmpty()){
                upsertSelectedItemsInCart(dspEmergencySuggestedOrders, cartType, orderTypeDSPEmergency);
            }
        }
        catch(Exception ex){
            system.debug('Error :: '+ex.getMessage());
            system.debug('Error line number :: '+ex.getLineNumber());
            String errorMsg = ex.getMessage();
            if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                errorMsg = 'Your SOF data has been updated, please refresh your browser.';
            }
            throw new AuraHandledException(errorMsg);
        }
    }
    
    Public static void checkCartUpdateObjectPermissions(){    
        if(Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isUpdateable() == false
           || Schema.sObjectType.EDealerCart__c.fields.Suggested_Order__c.isUpdateable() == false
           || Schema.sObjectType.EDealerCart__c.fields.Dealer_Location__c.isUpdateable() == false
           || Schema.sObjectType.EDealerCart__c.fields.Order_Type__c.isUpdateable() == false
           || Schema.sObjectType.EDealerCart__c.fields.Type__c.isUpdateable() == false
          ){
              throw new AuraHandledException('You don not have the permission to update Cart. Please contact your Administrator');
          }    
    }
    
    /**
     * @description Add/update (upsert) selected Stock Suggested orders in Cart
     */
    @AuraEnabled
    public static void upsertItemsInStockCart(List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> suggestedOrders){
        String cartType = EDealerConstants.CART_TYPE_CART;
        String orderType = EDealerConstants.CART_ORDER_TYPE_STOCK;
        
        //suggested parts id
        Set<Id> partsIdSet = new Set<Id>();
        
        for(EDealerSuggestedOrderUtils.SuggestedOrderWrapper soWrap : suggestedOrders){
            if(soWrap.checked == true){
                partsIdSet.add(soWrap.suggestedOrderId);
            }
        }
        
        //query suggested parts
        List<EDealer_Suggested_Order__c> suggestedParts = EDealerSuggestedOrderUtils.getSuggestedOrdersForTodayByIds(partsIdSet); 
        //if suggested parts list empty if no part detail found in salesforce
        // or if suggested part list size not matched with the no. of parts which selected to create cart 
        if(suggestedParts.isEmpty() || suggestedParts.size() != (new List<Id>(partsIdSet)).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
        
        //check cart object update permission
        checkCartUpdateObjectPermissions();
        
        try{
            // call the method to insert/update the selected cart items
            upsertSelectedItemsInCart(suggestedOrders, cartType, orderType);
        }
        catch(Exception ex){
            system.debug('Error :: '+ex.getMessage());
            system.debug('Error line number :: '+ex.getLineNumber());
            String errorMsg = ex.getMessage();
            if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                errorMsg = 'Your SOF data has been updated, please refresh your browser.';
            }
            throw new AuraHandledException(errorMsg);
        }
        
    }
    
    /**
     * @description Add/update (upsert) selected DSP Emergency Suggested orders in Cart
     */
    @AuraEnabled
    public static void upsertItemsInDSPEmergencyCart(List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> suggestedOrders){
        String cartType = EDealerConstants.CART_TYPE_CART;
        String orderType = EDealerConstants.CART_ORDER_TYPE_DSP_EMERGENCY;
        
        //suggested parts id
        Set<Id> partsIdSet = new Set<Id>();
        
        for(EDealerSuggestedOrderUtils.SuggestedOrderWrapper soWrap : suggestedOrders){
            if(soWrap.checked == true){
                partsIdSet.add(soWrap.suggestedOrderId);
            }
        }
        
        //query suggested parts
        List<EDealer_Suggested_Order__c> suggestedParts = EDealerSuggestedOrderUtils.getSuggestedOrdersForTodayByIds(partsIdSet); 
        //if suggested parts list empty if no part detail found in salesforce
        // or if suggested part list size not matched with the no. of parts which selected to create cart 
        if(suggestedParts.isEmpty() || suggestedParts.size() != (new List<Id>(partsIdSet)).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
        
        //check cart object update permission
        checkCartUpdateObjectPermissions();
        
        try{
            // call the method to insert/update the selected cart items
        	upsertSelectedItemsInCart(suggestedOrders, cartType, orderType);
        }
        catch(Exception ex){
            system.debug('Error :: '+ex.getMessage());
            system.debug('Error line number :: '+ex.getLineNumber());
            String errorMsg = ex.getMessage();
            if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                errorMsg = 'Your SOF data has been updated, please refresh your browser.';
            }
            throw new AuraHandledException(errorMsg);
        }
        
    }
    /**
     * @description Add/update (upsert) selected DSP stock Suggested orders in Cart
     */
    @AuraEnabled
    public static void upsertItemsInDSPCart(List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> suggestedOrders){
        String cartType = EDealerConstants.CART_TYPE_CART;
        String orderType = EDealerConstants.CART_ORDER_TYPE_DSP;
        //suggested parts id
        Set<Id> partsIdSet = new Set<Id>();
        
        for(EDealerSuggestedOrderUtils.SuggestedOrderWrapper soWrap : suggestedOrders){
            if(soWrap.checked == true){
                partsIdSet.add(soWrap.suggestedOrderId);
            }
        }
        
        //query suggested parts
        List<EDealer_Suggested_Order__c> suggestedParts = EDealerSuggestedOrderUtils.getSuggestedOrdersForTodayByIds(partsIdSet); 
        //if suggested parts list empty if no part detail found in salesforce
        // or if suggested part list size not matched with the no. of parts which selected to create cart 
        if(suggestedParts.isEmpty() || suggestedParts.size() != (new List<Id>(partsIdSet)).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
        
        //check cart object update permission
        checkCartUpdateObjectPermissions();
        
        try{
            // call the method to insert/update the selected cart items
            upsertSelectedItemsInCart(suggestedOrders, cartType, orderType);
        }
        catch(Exception ex){
            system.debug('Error :: '+ex.getMessage());
            system.debug('Error line number :: '+ex.getLineNumber());
            String errorMsg = ex.getMessage();
            if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                errorMsg = 'Your SOF data has been updated, please refresh your browser.';
            }
            throw new AuraHandledException(errorMsg);
        }
        
    }
    /**
     * @description Add/update (upsert) selected DUA Suggested orders in Cart
     */
    @AuraEnabled
    public static void upsertItemsInDSPAndPPDCStockCart(List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> suggestedOrders){
        List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> pdcStockSuggestedOrders = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();
		List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> dspStockSuggestedOrders = new List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper>();        
        
        String cartType = EDealerConstants.CART_TYPE_CART;
        String orderTypePDCStock = EDealerConstants.CART_ORDER_TYPE_STOCK;
        String orderTypeDSP = EDealerConstants.CART_ORDER_TYPE_DSP;
        
        //suggested parts id
        Set<Id> partsIdSet = new Set<Id>();
        
        for(EDealerSuggestedOrderUtils.SuggestedOrderWrapper soWrap : suggestedOrders){
            if(soWrap.DualPartSelectedPriceType == 'DSP' && soWrap.checked == true){
                partsIdSet.add(soWrap.suggestedOrderId);
                dspStockSuggestedOrders.add(soWrap);
            }else if(soWrap.DualPartSelectedPriceType == 'PDC' && soWrap.checked == true){
                partsIdSet.add(soWrap.suggestedOrderId);
                pdcStockSuggestedOrders.add(soWrap);
            }
        }
        
        //query suggested parts
        List<EDealer_Suggested_Order__c> suggestedParts = EDealerSuggestedOrderUtils.getSuggestedOrdersForTodayByIds(partsIdSet); 
        //if suggested parts list empty if no part detail found in salesforce
        // or if suggested part list size not matched with the no. of parts which selected to create cart 
        if(suggestedParts.isEmpty() || suggestedParts.size() != (new List<Id>(partsIdSet)).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
        
        //check cart object update permission
        checkCartUpdateObjectPermissions();
        
        try{
            // call the method to insert/update the selected cart items (PDC Orders)
            if(!pdcStockSuggestedOrders.isEmpty()){
                upsertSelectedItemsInCart(pdcStockSuggestedOrders, cartType, orderTypePDCStock);
            }
            // call the method to insert/update the selected cart items (DSP Orders)
            if(!dspStockSuggestedOrders.isEmpty()){
                upsertSelectedItemsInCart(dspStockSuggestedOrders, cartType, orderTypeDSP);
            }
        }
        catch(Exception ex){
            system.debug('Error :: '+ex.getMessage());
            system.debug('Error line number :: '+ex.getLineNumber());
            String errorMsg = ex.getMessage();
            if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                errorMsg = 'Your SOF data has been updated, please refresh your browser.';
            }
            throw new AuraHandledException(errorMsg);
        }
        
    }
    
    /**
     * @description This method upsert the Selected Suggested orders from Suggested Order U.I.
     */
    public static void upsertSelectedItemsInCart(List<EDealerSuggestedOrderUtils.SuggestedOrderWrapper> suggestedOrders, String cartType, String orderType){
		//get the Suggested Order IDs
        Set<Id> soIDs = new Set<Id>();
        
        for(EDealerSuggestedOrderUtils.SuggestedOrderWrapper sow : suggestedOrders){
            if(sow.checked){
                soIDs.add(sow.suggestedOrderId);
            }
        }
        
        Map<Id, EDealerCart__c> existingCartItemMap = new Map<Id, EDealerCart__c>();
        
        //get the already Cart-In Items for suggested orders
        List<EDealerCart__c> lstCartItems = EDealerCartUtils.getCartDetails(soIDs, new Set<String>{orderType}, cartType);
        for(EDealerCart__c	cItem : lstCartItems){
            existingCartItemMap.put(cItem.Suggested_Order__c, cItem);
        }
        //Upsert cart Items
        List<EDealerCart__c> lstUpsertCartItems = new List<EDealerCart__c>();
        for(EDealerSuggestedOrderUtils.SuggestedOrderWrapper sow : suggestedOrders){
            if(sow.checked){
                EDealerCart__c cartItem = new EDealerCart__c();
                //check SO in cart exist if yes then update quantity
                if(existingCartItemMap.containsKey(sow.suggestedOrderId)){
                    cartItem.Id = existingCartItemMap.get(sow.suggestedOrderId).Id;
                    cartItem.Quantity__c = ((existingCartItemMap.get(sow.suggestedOrderId).Quantity__c != null ? Integer.valueOf(existingCartItemMap.get(sow.suggestedOrderId).Quantity__c) : 0) + sow.qtyForOrder);
                }else{
                    cartItem.Suggested_Order__c = sow.suggestedOrderId;
                    cartItem.Dealer_Location__c = sow.dealerLocationId;
                    cartItem.Order_Type__c = orderType;
                    cartItem.Quantity__c = sow.qtyForOrder;
                    cartItem.Type__c = cartType;
                }
                lstUpsertCartItems.add(cartItem);
            }
        }
                
           if(Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isCreateable()
           && Schema.sObjectType.EDealerCart__c.fields.Suggested_Order__c.isCreateable()
           && Schema.sObjectType.EDealerCart__c.fields.Dealer_Location__c.isCreateable()
           && Schema.sObjectType.EDealerCart__c.fields.Order_Type__c.isCreateable()
           && Schema.sObjectType.EDealerCart__c.fields.Type__c.isCreateable()
           //For update
           && Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isUpdateable()
           && Schema.sObjectType.EDealerCart__c.fields.Suggested_Order__c.isUpdateable()
           && Schema.sObjectType.EDealerCart__c.fields.Dealer_Location__c.isUpdateable()
           && Schema.sObjectType.EDealerCart__c.fields.Order_Type__c.isUpdateable()
           && Schema.sObjectType.EDealerCart__c.fields.Type__c.isUpdateable()
          ){
              upsert lstUpsertCartItems;
          }
        
    } 
    
	/**
     * @description this method is called from a "GET SOF" button which is on sof screen 
     */    
    @AuraEnabled
    public static Integer generateSofonDemand(String dealerCode, String dealerDivision, Boolean isPromo){
        //Sof parts details
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = new List<EDealer_Suggested_Order__c>();
        
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        if(accList.isEmpty()){
            throw new AuraHandledException('No Dealer location found in salesforce.');
        }     
        //Call the SOF API to get the suggested order details for dealer
        EDealerSuggestedOrderUtils.SuggestedOrderFileWrapper  sOforDealer = EDealerSuggestedOrderUtils.callSuggestedOrdersApi(new List<String>{dealerCode}, dealerDivision, isPromo);
       System.debug('sOforDealer    '+sOforDealer);
        if(sOforDealer != null && sOforDealer.response != null){            
            for(EDealerSuggestedOrderUtils.OrderWrapper oWrap : sOforDealer.response){
                EDealer_Suggested_Order__c sofRecData = EDealerSuggestedOrderBatch.createSuggestedInstance(oWrap, accList[0], sOforDealer.sof_file_time, sOforDealer.Dbs, 'Adhoc');
                if(sofRecData != null){
                    lstSuggestedOrders.add(sofRecData);
                }
            }  
        }else if(sOforDealer != null && (String.isNotBlank(sOforDealer.error) || String.isNotBlank(sOforDealer.message)) ){
            throw new AuraHandledException('Error : '+(String.isNotBlank(sOforDealer.error) ? sOforDealer.error : sOforDealer.message));
        }
        
            //get list of Existing/old suggested Orders for dealer (for delete)
            List<EDealer_Suggested_Order__c> existingSuggestedParts = new List<EDealer_Suggested_Order__c>();
        	//get existing suggested orders 
        	existingSuggestedParts = EDealerSuggestedOrderUtils.getSuggestedOrdersByDealerLocs(new Set<String> {dealerCode}, isPromo, false);
            
            //First: delete old suggested parts details
            if(!existingSuggestedParts.isEmpty()){
                if(EDealer_Suggested_Order__c.sObjectType.getDescribe().isDeletable()){
                    delete existingSuggestedParts;
                }
            }
        
            //Second: insert new Suggested parts details
            if(!lstSuggestedOrders.isEmpty()){
                if(Schema.sObjectType.EDealer_Suggested_Order__c.fields.SOF_Type__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Dealer_Location__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.DBS_Type__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Dealer_Ineventory_Qty__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Dealer_Supplier_Code__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Category_Type__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Original_Part_Type__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Description__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Part_Name__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Qty_on_Order__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Serial_Number__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Stocking_List_Type__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Suggested_Qty__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Velocity_Code__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Lead_Time__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Emergency_Indicator__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Pricing_Detail__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.SPQ__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.SOF_Comments__c.isCreateable()
                   && Schema.sObjectType.EDealer_Suggested_Order__c.fields.Is_Special_Order_Part__c.isCreateable()
                  ){
                      insert lstSuggestedOrders;
                  }else{
                      throw new AuraHandledException('You do not have the sufficient permission. Please contact with your administrator');
                  }
                
            }
        
        // retun the sof count
        return lstSuggestedOrders.size();
    }
    
    /**
     * @description to call the special comment api
     * @return the special comment response in form of wrapper data
     */ 
    @AuraEnabled
    public static SpecialCommentResponse getSpecialCommentInDetail(String dealerCode, String dealerDivision,String partNumber, String sofComment){
       SpecialCommentResponse awsSOFResult = new SpecialCommentResponse();
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint', '/sof-comments/dealership/'+dealerCode+'?dealer_division='+dealerDivision+'&sofcomments='+EncodingUtil.urlEncode(sofComment, 'UTF-8')+'&item='+EncodingUtil.urlEncode(partNumber, 'UTF-8'));            
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerSuggestedOrdersController');
        System.debug('calloutDetails'+calloutDetails);
        calloutDetails.put('methodname','callSuggestedOrdersApi');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        System.debug('jsonRes'+jsonRes);
        // parsing the actual results
        if(jsonRes != null){
        	awsSOFResult = (SpecialCommentResponse)System.JSON.deserialize(jsonRes, SpecialCommentResponse.class);
        }
         
        return awsSOFResult; 
        
    }
    /**
     * @description wrapper to handle special comments api response body
     */
    public class SpecialCommentResponse {
        @AuraEnabled
        public List<SpecialCommentData>  response;
        @AuraEnabled
        public String  error;
    }
    /**
     * @description wrapper to handle special comments
     */
    public class SpecialCommentData {
        @AuraEnabled
        public String comments;
    }

}