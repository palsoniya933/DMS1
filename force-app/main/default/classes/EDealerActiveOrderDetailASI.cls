/*** 
* Name        :   EDealerActiveOrderDetailASI
*  Description :   This is the apex class which is used for EDealerActiveOrderDetailASI component
*/ 
public class EDealerActiveOrderDetailASI {
    /****
    * Created on 29-07-2021
    * To call Active Order Detail API
    */ 
    @AuraEnabled
    public static ResponseWrapper fetchActiveOrderData(String dealerCode,String orderNumber){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        ActiveOrderWrapper activeOrderData = new ActiveOrderWrapper();
        
        calloutDetails.put('endpoint','/order-workflow-asi/kpi/'+dealerCode+'/dealer?order_no='+orderNumber);
        calloutDetails.put('method','GET');
        calloutDetails.put('classname','EDealerActiveOrderDetail');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        system.debug('\n--jsonRes--'+jsonRes);
        
        
        if(jsonRes != null)
            activeOrderData = (ActiveOrderWrapper)System.JSON.deserialize(jsonRes, ActiveOrderWrapper.class);
        
        // create response wrapper instance
        ResponseWrapper responseObj = new ResponseWrapper();
        responseObj.dsp = 'false';
        responseObj.activeOrder = activeOrderData;
        
        Map<String,List<ActiveOrderWorkflowItemWrapper>> dynamicListMap = new Map<String,List<ActiveOrderWorkflowItemWrapper>>();
        
        // check if order_workflow_item_details is not null in response
        if(activeOrderData !=null && activeOrderData.order_workflow_item_details != null){
            
            Set<String> backOrderItemIds = new Set<String>();
            Set<String> allocatedItemIds = new Set<String>();
            Integer counter = 0;
            for(ActiveOrderWorkflowItemWrapper workflowItemDetail : activeOrderData.order_workflow_item_details){
                
                if(String.isNotBlank(workflowItemDetail.shipped_status) 
                   && (workflowItemDetail.shipped_status.equalsIgnoreCase('SHIPPED')
                   || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED/SHIPPED')
                   || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED')
                  )){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_shipped;
                }
                
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('CANCELLED')){
                    workflowItemDetail.display_qty = workflowItemDetail.qtycnl;
                }
                
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('BACKORDERED')){
                    workflowItemDetail.display_qty = workflowItemDetail.qtybo;
                }
                
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('ALLOCATED')){
                    workflowItemDetail.display_qty = workflowItemDetail.qtyalc;
                }
                
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && (workflowItemDetail.line_status.equalsIgnoreCase('Future')
                        || workflowItemDetail.line_status.equalsIgnoreCase('SCHEDULED'))){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_future;
                }
                
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('Pick Printed')){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_pickprinted;
                }
                
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && (workflowItemDetail.line_status.equalsIgnoreCase('Pick Verified')
                       	 || workflowItemDetail.line_status.equalsIgnoreCase('PICKED'))){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_pickverified;
                }
                
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('Packed')){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_packed;
                }
                else{
                     workflowItemDetail.display_qty = workflowItemDetail.totalqty;
                }
                
                Boolean itemProcessed = false;
                system.debug('\n--workflowItemDetail.dsp--'+workflowItemDetail.dsp);
                if(workflowItemDetail.dsp == 'true'){
                    responseObj.dsp = 'true';
                }
                
                // check if either prono is not blank or bolno is not blank
                if ((String.isNotBlank(workflowItemDetail.bolno) || String.isNotBlank(workflowItemDetail.prono))
                   && (String.isNotBlank(workflowItemDetail.shipped_status) 
                   && (workflowItemDetail.shipped_status.equalsIgnoreCase('SHIPPED')
                   || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED/SHIPPED')
                   || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED') ) ) ){
                    
                    String key;
                    
                    // check if prono is not blank and qty_shipped is not null and qty_shipped is greater than 0
                    if(!String.isBlank(workflowItemDetail.prono) 
                       && workflowItemDetail.qty_shipped != null
                       && workflowItemDetail.qty_shipped > 0){
                        key = workflowItemDetail.prono;
                    }
                    else if(!String.isBlank(workflowItemDetail.bolno) 
                            && workflowItemDetail.qty_shipped != null
                            && workflowItemDetail.qty_shipped > 0) {
                        key = workflowItemDetail.bolno;
                    }
                    
                    // check if dynamic map has the key 
                    if(dynamicListMap.containsKey(key)){
                        dynamicListMap.get(key).add(workflowItemDetail);
                        itemProcessed = true;
                    }
                    else{
                        dynamicListMap.put(key, new List<ActiveOrderWorkflowItemWrapper> {workflowItemDetail} );
                        itemProcessed = true;
                    }                        
                }
                
                if(workflowItemDetail.dsp == 'true'
                   && (String.isNotBlank(workflowItemDetail.shipped_status) 
                       && (workflowItemDetail.shipped_status.equalsIgnoreCase('SHIPPED')
                           || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED/SHIPPED')
                           || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED') ) ) ){
                               dynamicListMap.put(string.valueOf(counter), new List<ActiveOrderWorkflowItemWrapper> {workflowItemDetail} );
                               itemProcessed = true;
                               counter++;
                }
                
                // check for CANCELLED status workflow item then it will go in CANCELLED tab
                if(String.isNotBlank(workflowItemDetail.line_status) 
                    && workflowItemDetail.line_status.equalsIgnoreCase('CANCELLED')){
                        responseObj.cancelledList.add(workflowItemDetail);
                        itemProcessed = true;
                }
                
                // check if line_status is BACKORDERED and check for qtybo in workflow item and qtybo is greater than 0 then it will go in BACKORDER tab
                if((String.isNotBlank(workflowItemDetail.line_status) && workflowItemDetail.line_status.equalsIgnoreCase('BACKORDERED'))
                    && (workflowItemDetail.qtybo != null && workflowItemDetail.qtybo > 0)){
                    if(!backOrderItemIds.contains(workflowItemDetail.itmid)){
                        backOrderItemIds.add(workflowItemDetail.itmid);
                        responseObj.backOrderedList.add(workflowItemDetail);
                        itemProcessed = true;
                    }
                }
                
                // check if line_status is ALLOCATED and check for qtyalc in workflow item and qtyalc is greater than 0 then it will go in PROCESSING tab
                if((String.isNotBlank(workflowItemDetail.line_status) && workflowItemDetail.line_status.equalsIgnoreCase('ALLOCATED'))
                   && (workflowItemDetail.qtyalc != null && workflowItemDetail.qtyalc > 0)){
                       if(!allocatedItemIds.contains(workflowItemDetail.itmid)){
                           allocatedItemIds.add(workflowItemDetail.itmid);
                           responseObj.processingList.add(workflowItemDetail);
                           itemProcessed = true;
                       }
                }
                
                // check if bolno and prono are blank in workflow item and add it to processing list
                if(String.isBlank(workflowItemDetail.bolno) 
                       && String.isBlank(workflowItemDetail.prono) && !itemProcessed){
                           responseObj.processingList.add(workflowItemDetail);
                           itemProcessed = true;
                }
                
                // move all others to PROCESSING tab
                if(!itemProcessed) {
                    responseObj.processingList.add(workflowItemDetail);
                }
            }
        }
        
        
        if(activeOrderData !=null && activeOrderData.order_workflow != null 
           && !dynamicListMap.isEmpty()){
               
               Map<String,ActiveOrderWorkflowWrapper> mapProVsworkflow = new Map<String,ActiveOrderWorkflowWrapper>();
               
               // map the shipmet tabs in correct order that workflow is having
               for(ActiveOrderWorkflowWrapper workflow : activeOrderData.order_workflow){
                   
                   DynamicWrapper dynamicWrapper = new DynamicWrapper();                
                   system.debug('workflow.PRO_NUM : '+workflow.PRO_NUM);
                   if(dynamicListMap.containsKey(workflow.PRO_NUM)){
                       system.debug('workflow.PRO_NUM inside dynamicListMap : '+workflow.PRO_NUM);                    
                       dynamicWrapper.dynamicKey = workflow.PRO_NUM;
                       dynamicWrapper.dynamicList = dynamicListMap.get(workflow.PRO_NUM);
                   }
                   
                   else if(dynamicListMap.containsKey(workflow.BOL_NUM)){
                       system.debug('in else');                    
                       dynamicWrapper.dynamicKey = workflow.BOL_NUM;
                       dynamicWrapper.dynamicList = dynamicListMap.get(workflow.BOL_NUM);
                   }         
                   responseObj.dynamicTabList.add(dynamicWrapper);
               }            
               
               if(activeOrderData.order_workflow.isEmpty()
                    && responseObj.dsp == 'true'){
                   DynamicWrapper dynamicWrapper = new DynamicWrapper(); 
                   dynamicWrapper.dynamicKey = 'DSP';
                        for(List<ActiveOrderWorkflowItemWrapper> orders : dynamicListMap.values()){
                            dynamicWrapper.dynamicList.addAll(orders);
                        }
                   
                   responseObj.dynamicTabList.add(dynamicWrapper);
               }
           }         
        system.debug('responseObj.dynamicTabList: '+responseObj.dynamicTabList);
        
        // sorting
        if(!responseObj.backOrderedList.isEmpty()){
            responseObj.backOrderedList.sort();
        }
        if(!responseObj.cancelledList.isEmpty()){
            responseObj.cancelledList.sort();
        }
        if(!responseObj.processingList.isEmpty()){
            responseObj.processingList.sort();
        }
        if(!responseObj.dynamicTabList.isEmpty()){
            for(DynamicWrapper dyWrap : responseObj.dynamicTabList){
                dyWrap.dynamicList.sort();
            }
        }
        
        // RETURN
        return responseObj;
    }
    
    public class ResponseWrapper{
        @AuraEnabled public string dsp;
        @AuraEnabled public ActiveOrderWrapper activeOrder;
        @AuraEnabled public List<ActiveOrderWorkflowItemWrapper> backOrderedList;
        @AuraEnabled public List<ActiveOrderWorkflowItemWrapper> cancelledList;
        @AuraEnabled public List<ActiveOrderWorkflowItemWrapper> processingList;
        //@AuraEnabled public Map<String,List<ActiveOrderWorkflowItemWrapper>> dynamicListMap;
        @AuraEnabled public List<DynamicWrapper> dynamicTabList;
        
        public ResponseWrapper(){
            backOrderedList = new List<ActiveOrderWorkflowItemWrapper>();
            cancelledList = new List<ActiveOrderWorkflowItemWrapper>();
            processingList = new List<ActiveOrderWorkflowItemWrapper>();            
            dynamicTabList = new List<DynamicWrapper>();
        }
    }
    
    public class DynamicWrapper{
        @AuraEnabled public String dynamicKey;
        @AuraEnabled public List<ActiveOrderWorkflowItemWrapper> dynamicList;
        
        public DynamicWrapper(){
            dynamicList = new List<ActiveOrderWorkflowItemWrapper>(); 
        }
    }
    
    public class ActiveOrderWrapper{
        @AuraEnabled public List<ActiveOrderResponseWrapper> response;
        @AuraEnabled public List<ActiveOrderWorkflowWrapper> order_workflow;
        @AuraEnabled public List<ActiveOrderWorkflowItemWrapper> order_workflow_item_details;
    }
    
    class ActiveOrderResponseWrapper {
        @AuraEnabled public String customer;    //I080
        @AuraEnabled public String paccer_order;    //STZM109
        @AuraEnabled public String customername;    //KENWORTH OF INDIANAPOLIS-WEST
        @AuraEnabled public String dealerpo;    //M071221
        @AuraEnabled public String order_date;  //2021-07-12
        //@AuraEnabled public String shipping_method; //BWG                                 ---->30-21
        @AuraEnabled public String comp;    //119
        @AuraEnabled public String div; //
        @AuraEnabled public String order_currency;  //US
        @AuraEnabled public String deliver_to;  //2929 S. HOLT RD
        @AuraEnabled public Double order_value; //33220.504808
        @AuraEnabled public Decimal tax_amount; //0
        @AuraEnabled public Decimal header_miss_charges;    //0
        @AuraEnabled public Decimal detail_misc_charges;    //1800
        @AuraEnabled public Double order_weight;    //1341.6187
        @AuraEnabled public Decimal order_volume;   //0
        @AuraEnabled public Decimal number_of_cartons;  //0
        @AuraEnabled public String order_status;    //BACKORDERED
        @AuraEnabled public Decimal parts_ordered;  //141
        @AuraEnabled public Decimal parts_backorder;    //10
        @AuraEnabled public Decimal parts_allocated;    //0
        @AuraEnabled public Decimal parts_shipped;  //130
        @AuraEnabled public Decimal cancel; //1
        @AuraEnabled public String uom; //EA,
        @AuraEnabled public Double merchandiseamount;   //31420.504808
        @AuraEnabled public Double openmerchandiseamount;   //1649.766399
        @AuraEnabled public Decimal splitorder; //131
        @AuraEnabled public cls_comment[] comment;
    }
    
    public class cls_comment {
        @AuraEnabled public String crgtyp;  //
        @AuraEnabled public String unitprcd;    //C
        @AuraEnabled public Decimal qty;    //0
        @AuraEnabled public String comm;    //PRO #: 5493879484           - L1G27K1924
        @AuraEnabled public Decimal prc;    //0
        @AuraEnabled public Decimal pcdisc; //0
        @AuraEnabled public Decimal invoice;    //0
        @AuraEnabled public Decimal ordln;  //0
    }
    
    class ActiveOrderWorkflowWrapper {
        @AuraEnabled public String PRO_NUM; //5493872952
        @AuraEnabled public String BOL_NUM; //L21-020764
        @AuraEnabled public String PRO_BOL_NO;  //5493872952_L21-020764
        @AuraEnabled public String SOURCE_LOCATION; //LAN
        @AuraEnabled public String DESTINATION_LOCATION;    //2929 S. HOLT RDINDIANAPOLIS, IN 46241, 
        @AuraEnabled public String TMS_ORDER;   //
        @AuraEnabled public String EVENT_STATUS;    //
        @AuraEnabled public String EVENT_DATE;  //
        @AuraEnabled public String EVENT_TIME;  //
        @AuraEnabled public String TIME_ZONE;   //UTC
        @AuraEnabled public String EST_ARRIVAL; //
        @AuraEnabled public String TRACKING_ID; //
        @AuraEnabled public String ENCRYPTED_URL;   //
        @AuraEnabled public String COMMENT; //
        @AuraEnabled public String PICKED_UP_DATE_PST;  //2021-07-13 19:22:20
        @AuraEnabled public String EST_ARRIVAL_PST; //
        @AuraEnabled public String STAT;    //
        @AuraEnabled public String shipping_method;
        //@AuraEnabled public String order_status;                   ---->30-21
    }
    
    public class ActiveOrderWorkflowItemWrapper implements comparable{
        @AuraEnabled public String itmid;   //11-03942-0500
        //@AuraEnabled public String order_status;    //INVOICED
        @AuraEnabled public String line_status; //INVOICED
        @AuraEnabled public String shipped_status;  //INVOICED
        @AuraEnabled public String itmdesc; //STEP-FUEL TANK ALUM 500MM
       // @AuraEnabled public decimal qty;    //1                            ---->30-21
        @AuraEnabled public String bolno;   //
        @AuraEnabled public String prono;   //1Z10F23X0112997013
       // @AuraEnabled public String line_comment;                         ---->30-21
        @AuraEnabled public decimal ordln;  //94   
        @AuraEnabled public List<LineComment> lineComm;
        @AuraEnabled public decimal totalqty;
        @AuraEnabled public decimal qtybo;
        @AuraEnabled public decimal qty_shipped;
        @AuraEnabled public decimal qtyalc;
        @AuraEnabled public decimal qtycnl;
        @AuraEnabled public decimal qty_future;
        @AuraEnabled public decimal qty_pickverified;
        @AuraEnabled public decimal qty_pickprinted;
        @AuraEnabled public decimal qty_packed;
        
        @AuraEnabled public decimal display_qty;
            
        @AuraEnabled public string dsp;
        
        public Integer compareTo (Object compareTo) {
            ActiveOrderWorkflowItemWrapper wrapper = (ActiveOrderWorkflowItemWrapper)compareTo;
            Integer returnValue = 0;
            If (ordln > wrapper.ordln) {
                returnValue = 1;
            } else if (ordln < wrapper.ordln) {
                returnValue = -1;
            }
            Return returnValue; 
        }
    }
    
    class LineComment {
        @AuraEnabled public String crgtyp;
        @AuraEnabled public String unitprcd;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public String comm;
        @AuraEnabled public Decimal prc;
        @AuraEnabled public Decimal pcdisc;
        @AuraEnabled public Integer invoice;
        @AuraEnabled public Integer ordln;
    }
}