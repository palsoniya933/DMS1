/**
* @description This Batch will use to get the Suggested Orders Details for each Dealer.
* Dealer codes are availble on Account Object.
* This Batch will run every Day.
* Run this batch with Batch Size 1.
*/ 
public with sharing class EDealerSuggestedOrderBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful, Schedulable {
    
    /**
     * @description this method will call by scheduler
     */ 
    public void execute(SchedulableContext SC) {
        EDealerSuggestedOrderBatch batch = new EDealerSuggestedOrderBatch();
        //Execute Batch
        database.executeBatch(batch, 1);        
    }
    
    /**
     * @description this start menthod run by batch on load
     */ 
    public Database.QueryLocator start(Database.BatchableContext BC){        
        //TO get and save SOF Summary in salesforce
        Set<Id> sofSummaryIds = callToGetSOFSummary();
        system.debug('sofSummaryIds'+sofSummaryIds);
        String query = 'SELECT Id,Name,Dealer_Code__c,Dealer_Divison__c, SOF_Api__c, SOF_Date_Time__c, IsFailed__c, IsCalledAgain__c';
        query += ' FROM EDealer_SOF_Summary__c';
        query += ' WHERE (Id IN :sofSummaryIds OR (IsFailed__c = true AND IsCalledAgain__c = false)) AND CreatedDate = Today  ORDER BY SOF_Date_Time__c ASC';
        
        return Database.getQueryLocator(query);
    }
    
    /**
     * @description this execute menthod run by batch multiple times (depend on no. of batch chunks)
     */ 
    public void execute(Database.BatchableContext BC, List<EDealer_SOF_Summary__c> lstSummary){
        //Sof parts details
        List<EDealer_Suggested_Order__c> lstSuggestedOrders = new List<EDealer_Suggested_Order__c>();
        
        //Map<dealercode, summary>
        Map<String, EDealer_SOF_Summary__c> mapDealercodeSummary = new Map<String, EDealer_SOF_Summary__c>();
        
        //Dealer Accounts details
        List<Account> accList = new List<Account>();
        
        //Map<DealerCode, Account>
        Map<String,Account> mapDealerAccount = new Map<String,Account>();
        
        //SOF summary rec ids
        Set<Id> summaryIds = new Set<Id>();
        
        for(EDealer_SOF_Summary__c sum : lstSummary){
            summaryIds.add(sum.Id);
        }
        
        for(EDealer_SOF_Summary__c sum : lstSummary){
            if(String.isNotBlank(sum.Dealer_Code__c)){
                mapDealercodeSummary.put(sum.Dealer_Code__c, sum);
            }
        }
        
        
        //get the dealers details (accounts)
        if(!mapDealercodeSummary.isEmpty()){
            accList =EdealerAccountUtils.getDealersAccount(mapDealercodeSummary.keySet());
        }
        
        for(Account acc : accList){
            mapDealerAccount.put(acc.Dealer_Code__c, acc);
        }
        
        
        //Dealer code - used in case of apex error
        String dealerLocCodeForErrorMsg;
        
        //call the sof api
        try{
            for(String dealerCode : mapDealercodeSummary.keySet()){
                dealerLocCodeForErrorMsg = dealerCode;
                //check dealer code Account exist 
                if(mapDealerAccount.containsKey(dealerCode)){
                    //Call the SOF API to get the suggested order details for dealer (without promo)
                    EDealerSuggestedOrderUtils.SuggestedOrderFileWrapper  sOforDealer = EDealerSuggestedOrderUtils.callSuggestedOrdersApi(new List<String>{dealerCode}, mapDealerAccount.get(dealerCode).PACCARDivision__c, false); 
                  			System.debug('sOforDealer'+sOforDealer);
                    if(sOforDealer != null && sOforDealer.response != null && !sOforDealer.response.isEmpty()){
                        String sofType;
                        List<String> tempList = sOforDealer.sof_file_time.split(' ');
                        String tempDTString = tempList[0] + 'T' + tempList[1] + '-0800';
                        //Convert to GMT Time Zone
                        DateTime date1 = (DateTime)JSON.deserialize('"' + tempDTString + '"', DateTime.class);
                        //check the sof of MDI 360 0r overnight
                        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                        DateTime pstDT =DateTime.newInstance(date1.getTime() + tz.getOffset(date1));
                        if(pstDT.hourGmt() >= 20 || pstDT.hourGmt() <= 5){
                            sofType = 'Overnight';
                        }else if(pstDT.hourGmt() >= 8 && pstDT.hourGmt() <= 15){
                            sofType = 'MDI 360';
                        }else{
                            sofType = 'Adhoc';
                        }
                        
                        for(EDealerSuggestedOrderUtils.OrderWrapper oWrap : sOforDealer.response){ 
                            EDealer_Suggested_Order__c sofRecData = EDealerSuggestedOrderBatch.createSuggestedInstance(oWrap, mapDealerAccount.get(dealerCode), sOforDealer.sof_file_time, sOforDealer.Dbs, sofType);
                            if(sofRecData != null){
                                lstSuggestedOrders.add(sofRecData);
                            }
                        } 
                    }else if(sOforDealer != null && (String.isNotBlank(sOforDealer.error) || String.isNotBlank(sOforDealer.message)) ){
                        mapDealercodeSummary.get(dealerCode).Error_Message__c = String.isNotBlank(sOforDealer.error) ? sOforDealer.error : sOforDealer.message;
                        mapDealercodeSummary.get(dealerCode).IsFailed__c = true;
                    }else{
                        mapDealercodeSummary.get(dealerCode).IsFailed__c = true;
                        mapDealercodeSummary.get(dealerCode).Error_Message__c = 'Check the api response status in edealer log if api failed.';
                    }  
                }
                //When Account with dealer code not exist then add an error mesage on Summary Record
                else{
                    mapDealercodeSummary.get(dealerCode).Error_Message__c = dealerCode+' dealer code not found on Account';
                }
                
                //update the Summary Api call detail
                if(mapDealercodeSummary.get(dealerCode).SOF_Api__c == true){ 
                    mapDealercodeSummary.get(dealerCode).IsCalledAgain__c = true;
                }else{
                    mapDealercodeSummary.get(dealerCode).SOF_Api__c = true;
                }
                
            }
            
            //get list of Existing/old suggested Orders for dealer (for delete)
            List<EDealer_Suggested_Order__c> existingSuggestedParts = new List<EDealer_Suggested_Order__c>();
            if(!mapDealercodeSummary.isEmpty()){
                existingSuggestedParts = EDealerSuggestedOrderUtils.getSuggestedOrdersByDealerLocs(mapDealercodeSummary.keySet(), false, false);
            } 
            
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
                  }
                
            }
            
            
            //Third: update SOF Summary Details
            if(!mapDealercodeSummary.isEmpty()){
                update mapDealercodeSummary.values();
            }
        }catch(Exception ex){
            //Exception
            EDealerLogUtils.createExceptionLog(ex, 'EDealerSuggestedOrderBatch');
            //update summary detail
            if(String.isNotBlank(dealerLocCodeForErrorMsg)){
                EDealer_SOF_Summary__c summaryObj = mapDealercodeSummary.get(dealerLocCodeForErrorMsg);
                if(summaryObj != null){
                    summaryObj.IsFailed__c = true;
                    summaryObj.Error_Message__c = ex.getMessage();
                    if(Schema.sObjectType.EDealer_SOF_Summary__c.fields.IsFailed__c.isUpdateable()
                       && Schema.sObjectType.EDealer_SOF_Summary__c.fields.Error_Message__c.isUpdateable()
                      ){
                          update summaryObj;
                      }
                }
            }
            
        }
        
    }
    
    /**
     * @description this finish menthod execute after batch completed
     */ 
    public void finish(Database.BatchableContext BC){
        System.debug('batch finish method called');
    }
    
    /**
     * @description This method will use to map the SOF api result for each suggested part
     * @return instance of Suggested Order object instance
     */
    public static EDealer_Suggested_Order__c createSuggestedInstance(EDealerSuggestedOrderUtils.OrderWrapper oWrap, Account acc, String fileDate, String dbsType, String sofType){
        
        EDealer_Suggested_Order__c order = new EDealer_Suggested_Order__c();
        //order.SOF_File_Date__c = fileDate;
        order.SOF_Created_DT__c = fileDate;
        order.SOF_Type__c = sofType;
        order.Dealer_Location__c = acc.Id;
        order.DBS_Type__c = dbsType;
        Integer Ineventory_Qty = 0;
        try {
            Ineventory_Qty = (oWrap.inventory_on_hand != null) ? Integer.valueOf(oWrap.inventory_on_hand) : 0;
        }catch(Exception ex){}
        order.Dealer_Ineventory_Qty__c = Ineventory_Qty;
        order.Dealer_Supplier_Code__c = oWrap.dealer_supplier_code;
        
        if(oWrap.Part_category_Type.containsIgnoreCase('PDC')){ 
            order.Part_Category_Type__c = 'PDC';
        }else if(oWrap.Part_category_Type.containsIgnoreCase('DSP')){
            order.Part_Category_Type__c = 'DSP';
        }else if(oWrap.Part_category_Type.containsIgnoreCase('ENG')){
            order.Part_Category_Type__c = 'ENG';
        }else{
            //Return null when part is not  DSP or PDC or ENG
            return null;
        }
        
        order.Original_Part_Type__c  = order.Part_Category_Type__c; 
        
        order.Part_Description__c = oWrap.decription;
        order.Part_Name__c = oWrap.Part_Name;
        order.Qty_on_Order__c = (oWrap.Qty_on_Order != null) ? Integer.valueOf(oWrap.Qty_on_Order) : 0;
        order.Serial_Number__c = (oWrap.Serial_Number != null) ? Integer.valueOf(oWrap.Qty_on_Order) : null;
        order.Stocking_List_Type__c = oWrap.Stocking_list_Type;
        order.Suggested_Qty__c = (oWrap.Suggested_Qty != null) ? Integer.valueOf(oWrap.Suggested_Qty) : 0;
        order.Velocity_Code__c = oWrap.velocity_code;
        order.Stocking_Class__c =oWrap.Stocking_Class;
        
        order.Lead_Time__c = oWrap.Lead_Time;
        order.Emergency_Indicator__c = (oWrap.Emergency_Indicator == 'Y' ? true : false);
        //Pricing details
        if(oWrap.PriceDetail != null){
            //change SOF to DUAL part type
            if((order.Part_Category_Type__c == 'PDC' || order.Part_Category_Type__c == 'DSP')
               && oWrap.PriceDetail.WhsFinalNet != null && oWrap.PriceDetail.DspFinalNet != null
               && oWrap.PriceDetail.WhsFinalNet > 0 && oWrap.PriceDetail.DspFinalNet > 0){
                   order.Part_Category_Type__c = EDealerConstants.SO_PART_CATEGORY_TYPE_DUAL;
               }
            order.Pricing_Detail__c = Json.serialize(oWrap.PriceDetail);
        }
        
        order.SPQ__c = oWrap.spq;
		order.SOF_Comments__c = oWrap.sof_comments;  
        
        if(String.isNotBlank(order.SOF_Comments__c) &&  order.SOF_Comments__c.toLowerCase().contains('special order')){
            order.Is_Special_Order_Part__c = true;
        }
        
        return order;
    } 
    
    /**
     * @description Fetch the SOF Summary details from snowflake 
     * and save that summary table details in salesforce 
     * @return and then return the summary records's id
     */
    public static Set<Id> callToGetSOFSummary(){
        Set<Id> sofSummaryIds = new Set<Id>();
        String dtStr = '';
        //1. get the DT for today from Summary object
        List<EDealer_SOF_Summary__c> sofSummary;
        if(Schema.sObjectType.EDealer_SOF_Summary__c.fields.Id.isAccessible()
           && Schema.sObjectType.EDealer_SOF_Summary__c.fields.Name.isAccessible()
           && Schema.sObjectType.EDealer_SOF_Summary__c.fields.SOF_Date_Time__c.isAccessible()
           && Schema.sObjectType.EDealer_SOF_Summary__c.fields.createdDate.isAccessible()
          ){
              sofSummary = [SELECT Id, Name, SOF_Date_Time__c FROM EDealer_SOF_Summary__c
                            WHERE createdDate = Today AND SOF_Date_Time__c != null Order BY SOF_Date_Time__c desc];
              System.debug(' in query sofSummary ==>> '+sofSummary.size());
          }
        
        if(!sofSummary.isEmpty()){
            dtStr = String.valueOf(sofSummary[0].SOF_Date_Time__c);
        }
        System.debug('dtStr ==>> '+dtStr);
        if(!Test.isRunningTest()){
            //2. call to get sof summary 
            EDealerSOFSummary.SOFSummaryResponseWrapper  resWrap =  EDealerSOFSummary.fetchSOFSummary(dtStr);
            System.debug('resWrap'+resWrap);
            //3. Parse the sof summary response
            List<EDealer_SOF_Summary__c>  lstSummary = EDealerSOFSummary.sofSummaryParse(resWrap.response);
            System.debug(' size of  lstSummary ==>> '+lstSummary.size());
            //4. Save the sof summary details in salesforce 
            if(!lstSummary.isEmpty()){
                if(Schema.sObjectType.EDealer_SOF_Summary__c.fields.Dealer_Code__c.isCreateable()
                   && Schema.sObjectType.EDealer_SOF_Summary__c.fields.Dealer_Divison__c.isCreateable()
                   && Schema.sObjectType.EDealer_SOF_Summary__c.fields.SOF_Count__c.isCreateable()
                   && Schema.sObjectType.EDealer_SOF_Summary__c.fields.SOF_Date_Time__c.isCreateable()
                   && Schema.sObjectType.EDealer_SOF_Summary__c.fields.Time_of_Day__c.isCreateable()
                  ){
                      System.debug(' in query insert  lstSummary ==>> '+lstSummary.size());
                      insert lstSummary;
                      /////fetch the new Summary records id
                      for(EDealer_SOF_Summary__c summary : lstSummary){
                          sofSummaryIds.add(summary.Id);
                      }
                  }else{
                      System.debug('You do not have the sufficient Permission. Please contact with your Administrator');
                  }
                
            }
            return sofSummaryIds;
        }
        else{
            //when test running then return the list of soql ids
            return new Set<Id>{sofSummary[0].Id};
        }
        
    } 
    
}