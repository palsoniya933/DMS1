/*** 
* Name        :   EDealerActiveOrderDetailASI_V1
*  Description :   This is the apex class which is used for EDealerActiveOrderDetailASI component
*/ 
public class EDealerActiveOrderDetailASI_V1 {
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
        
        if(jsonRes != null)
            activeOrderData = (ActiveOrderWrapper)System.JSON.deserialize(jsonRes, ActiveOrderWrapper.class);
        
        // create response wrapper instance
        ResponseWrapper responseObj = new ResponseWrapper();
        responseObj.dsp = 'false';
        // commeted below line and moved at the end of method - 2 Dec 2021
        // responseObj.activeOrder = activeOrderData;
        
        Map<String,List<ActiveOrderWorkflowItemWrapper>> dynamicListMap = new Map<String,List<ActiveOrderWorkflowItemWrapper>>();
        
        // check if order_workflow_item_details is not null in response
        if(activeOrderData !=null && activeOrderData.order_workflow_item_details != null){
            
            Set<String> backOrderItemIds = new Set<String>();
            Set<String> allocatedItemIds = new Set<String>();
            Integer counter = 0;
            
            // iterate on order_workflow_item_details from response
            for(ActiveOrderWorkflowItemWrapper workflowItemDetail : activeOrderData.order_workflow_item_details){
                
                // check if the shipped_status of workflow item detail is one of the (SHIPPED, INVOICED/SHIPPED or INVOICED)
                // and assign qty_shipped to display_qty of workflow item detail
                if(String.isNotBlank(workflowItemDetail.shipped_status) 
                   && (workflowItemDetail.shipped_status.equalsIgnoreCase('SHIPPED')
                   || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED/SHIPPED')
                   || workflowItemDetail.shipped_status.equalsIgnoreCase('INVOICED')
                  )){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_shipped;
                }
                
                // check if the line_status of workflow item detail is CANCELLED
                // and assign qtycnl to display_qty of workflow item detail
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('CANCELLED')){
                    workflowItemDetail.display_qty = workflowItemDetail.qtycnl;
                }
                
                // check if the line_status of workflow item detail is BACKORDERED
                // and assign qtybo to display_qty of workflow item detail
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('BACKORDERED')){
                    workflowItemDetail.display_qty = workflowItemDetail.qtybo;
                }
                
                // check if the line_status of workflow item detail is ALLOCATED
                // and assign qtyalc to display_qty of workflow item detail
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('ALLOCATED')){
                    workflowItemDetail.display_qty = workflowItemDetail.qtyalc;
                }
                
                // check if the line_status of workflow item detail is Future or SCHEDULED
                // and assign qty_future to display_qty of workflow item detail
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && (workflowItemDetail.line_status.equalsIgnoreCase('Future')
                        || workflowItemDetail.line_status.equalsIgnoreCase('SCHEDULED'))){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_future;
                }
                
                // check if the line_status of workflow item detail is Pick Printed
                // and assign qty_pickprinted to display_qty of workflow item detail
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('Pick Printed')){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_pickprinted;
                }
                
                // check if the line_status of workflow item detail is Pick Verified or PICKED
                // and assign qty_pickverified to display_qty of workflow item detail
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && (workflowItemDetail.line_status.equalsIgnoreCase('Pick Verified')
                       	 || workflowItemDetail.line_status.equalsIgnoreCase('PICKED'))){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_pickverified;
                }
                
                // check if the line_status of workflow item detail is Packed
                // and assign qty_packed to display_qty of workflow item detail
                else if(String.isNotBlank(workflowItemDetail.line_status) 
                        && workflowItemDetail.line_status.equalsIgnoreCase('Packed')){
                    workflowItemDetail.display_qty = workflowItemDetail.qty_packed;
                }
                
                // else assign totalqty to display_qty of workflow item detail
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
                if(String.isNotBlank(workflowItemDetail.line_status) && workflowItemDetail.line_status.equalsIgnoreCase('CANCELLED')
                  ||(workflowItemDetail.qtycnl != null && workflowItemDetail.qtycnl > 0)){
                        responseObj.cancelledList.add(workflowItemDetail);
                        itemProcessed = true;
                }
                
                // check if line_status is BACKORDERED and check for qtybo in workflow item and qtybo is greater than 0 then it will go in BACKORDER tab
                if((String.isNotBlank(workflowItemDetail.line_status) && workflowItemDetail.line_status.equalsIgnoreCase('BACKORDERED'))
                    || (workflowItemDetail.qtybo != null && workflowItemDetail.qtybo > 0)){
                    if(!backOrderItemIds.contains(workflowItemDetail.itmid)){
                        backOrderItemIds.add(workflowItemDetail.itmid);
                        responseObj.backOrderedList.add(workflowItemDetail);
                        itemProcessed = true;
                    }
                }
                
                // check if line_status is ALLOCATED and check for qtyalc in workflow item and qtyalc is greater than 0 then it will go in PROCESSING tab
                if((String.isNotBlank(workflowItemDetail.line_status) && workflowItemDetail.line_status.equalsIgnoreCase('ALLOCATED'))
                   || (workflowItemDetail.qtyalc != null && workflowItemDetail.qtyalc > 0)){
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
        
        // added below code for TMS data - 2 Dec 2021
        Map<String,ActiveOrderWorkflowWrapper> mapProBolVsworkflowTMS = new Map<String,ActiveOrderWorkflowWrapper>();
        if(activeOrderData !=null && activeOrderData.order_workflow_TMS != null){
            for(ActiveOrderWorkflowWrapper workflowTMS : activeOrderData.order_workflow_TMS){
                if(workflowTMS.PRO_NUM != null)
                	mapProBolVsworkflowTMS.put(workflowTMS.PRO_NUM, workflowTMS);
                else if(workflowTMS.BOL_NUM != null)
                	mapProBolVsworkflowTMS.put(workflowTMS.BOL_NUM, workflowTMS);
            }
        }
        
        // removed - && !dynamicListMap.isEmpty() condition from if. - 2 Dec 2021
        if(activeOrderData !=null && activeOrderData.order_workflow != null){
               // commented below map as it is not used anywhere - 2 Dec 2021
               // Map<String,ActiveOrderWorkflowWrapper> mapProVsworkflow = new Map<String,ActiveOrderWorkflowWrapper>();
               
               // map the shipmet tabs in correct order that workflow is having
               for(ActiveOrderWorkflowWrapper workflow : activeOrderData.order_workflow){
                   // added - !dynamicListMap.isEmpty() condition. - 2 Dec 2021
                   if(!dynamicListMap.isEmpty()){
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
                   
                   // added below code for TMS data - 2 Dec 2021
                   if(workflow.PRO_NUM != null && mapProBolVsworkflowTMS.containsKey(workflow.PRO_NUM)){
                       workflow.orderWorkflowTMS = mapProBolVsworkflowTMS.get(workflow.PRO_NUM);
                   }
                   else if(workflow.BOL_NUM != null && mapProBolVsworkflowTMS.containsKey(workflow.BOL_NUM)){
                       workflow.orderWorkflowTMS = mapProBolVsworkflowTMS.get(workflow.BOL_NUM);
                   }
               }            
            
            // added - !dynamicListMap.isEmpty() condition. - 2 Dec 2021
            if(!dynamicListMap.isEmpty()){
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
        }         
        system.debug('responseObj.dynamicTabList: '+responseObj.dynamicTabList);
        
        // sorting
        if(!responseObj.backOrderedList.isEmpty()){
            responseObj.backOrderedList.sort();
            responseObj.hasBackOrder = true;
        }
        if(!responseObj.cancelledList.isEmpty()){
            responseObj.cancelledList.sort();
            responseObj.hasCancelOrder = true;
        }
        if(!responseObj.processingList.isEmpty()){
            responseObj.processingList.sort();
            responseObj.hasProcessingOrder = true;
        }
        if(!responseObj.dynamicTabList.isEmpty()){
            for(DynamicWrapper dyWrap : responseObj.dynamicTabList){
                dyWrap.dynamicList.sort();
            }
        }
        
        responseObj.languageTranslationBO =  new map<string,object>(EDealerMetadataUtility.translateColumnHeadersVersion2('Back Ordered Tracking'));
        responseObj.languageTranslationProcessing =  new map<string,object>(EDealerMetadataUtility.translateColumnHeadersVersion2('Processing Tracking'));
        responseObj.languageTranslationCO =  new map<string,object>(EDealerMetadataUtility.translateColumnHeadersVersion2('Cancelled Ordered Tracking'));
        responseObj.languageTranslationPO =  new map<string,object>(EDealerMetadataUtility.translateColumnHeadersVersion2('Parts Ordered Tracking'));
        
        
         // added below line - 2 Dec 2021	
        responseObj.activeOrder = activeOrderData;
         
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
        @AuraEnabled public Boolean hasBackOrder;
        @AuraEnabled public Boolean hasCancelOrder;
        @AuraEnabled public Boolean hasProcessingOrder;
        @AuraEnabled public map<string,object>languageTranslationBO;
        @AuraEnabled public map<string,object>languageTranslationProcessing;
        @AuraEnabled public map<string,object>languageTranslationCO;
        @AuraEnabled public map<string,object>languageTranslationPO;        
        public ResponseWrapper(){
            backOrderedList = new List<ActiveOrderWorkflowItemWrapper>();
            cancelledList = new List<ActiveOrderWorkflowItemWrapper>();
            processingList = new List<ActiveOrderWorkflowItemWrapper>();            
            dynamicTabList = new List<DynamicWrapper>();
            hasBackOrder = false;
            hasCancelOrder = false;
            hasProcessingOrder = false;
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
        @AuraEnabled public List<ActiveOrderWorkflowWrapper> order_workflow_TMS;
        @AuraEnabled public List<ActiveOrderWorkflowItemWrapper> order_workflow_item_details;
    }
    
    class ActiveOrderResponseWrapper {
        @AuraEnabled public String customer; 
        @AuraEnabled public String paccer_order; 
        @AuraEnabled public String customername;   
        @AuraEnabled public String dealerpo;   
        @AuraEnabled public String order_date;  
        //@AuraEnabled public String shipping_method; 
        @AuraEnabled public String comp;   
        @AuraEnabled public String div;
        @AuraEnabled public String order_currency;  
        @AuraEnabled public String deliver_to; 
        @AuraEnabled public Double order_value;
        @AuraEnabled public Decimal tax_amount; 
        @AuraEnabled public Decimal header_miss_charges; 
        @AuraEnabled public Decimal detail_misc_charges; 
        @AuraEnabled public Double order_weight; 
        @AuraEnabled public Decimal order_volume;
        @AuraEnabled public Decimal number_of_cartons;
        @AuraEnabled public String order_status;  
        @AuraEnabled public Decimal parts_ordered;  
        @AuraEnabled public Decimal parts_backorder;
        @AuraEnabled public Decimal parts_allocated; 
        @AuraEnabled public Decimal parts_shipped;
        @AuraEnabled public Decimal cancel;
        @AuraEnabled public String uom;
        @AuraEnabled public Double merchandiseamount; 
        @AuraEnabled public Double openmerchandiseamount;
        @AuraEnabled public Decimal splitorder;
        @AuraEnabled public cls_comment[] comment;
    }
    
    public class cls_comment {
        @AuraEnabled public String crgtyp;  
        @AuraEnabled public String unitprcd;    
        @AuraEnabled public Decimal qty;    //0
        @AuraEnabled public String comm;    
        @AuraEnabled public Decimal prc;    
        @AuraEnabled public Decimal pcdisc; //0
        @AuraEnabled public Decimal invoice;    //0
        @AuraEnabled public Decimal ordln;  //0
    }
    
    class ActiveOrderWorkflowWrapper {
        @AuraEnabled public String PRO_NUM; 
        @AuraEnabled public String BOL_NUM; 
        @AuraEnabled public String PRO_BOL_NO; 
        @AuraEnabled public String SOURCE_LOCATION; //LAN
        @AuraEnabled public String DESTINATION_LOCATION; 
        @AuraEnabled public String TMS_ORDER;   //
        @AuraEnabled public String EVENT_STATUS;    
        @AuraEnabled public String EVENT_DATE;  //
        @AuraEnabled public String EVENT_TIME;  
        @AuraEnabled public String TIME_ZONE;   //UTC
        @AuraEnabled public String EST_ARRIVAL; 
        @AuraEnabled public String TRACKING_ID; 
        @AuraEnabled public String ENCRYPTED_URL;  
        @AuraEnabled public String COMMENT; 
        @AuraEnabled public String PICKED_UP_DATE_PST;  
        @AuraEnabled public String EST_ARRIVAL_PST;
        @AuraEnabled public String DELIVERED_ON_PST; 
        @AuraEnabled public String STAT;   
        @AuraEnabled public String shipping_method;
        // added new attribute to show TMS data - 2 Dec 2021
        @AuraEnabled public ActiveOrderWorkflowWrapper orderWorkflowTMS;
        //@AuraEnabled public String order_status; 
    }
    
    public class ActiveOrderWorkflowItemWrapper implements comparable{
        @AuraEnabled public String itmid; 
        //@AuraEnabled public String order_status;
        @AuraEnabled public String line_status;
        @AuraEnabled public String shipped_status;
        @AuraEnabled public String itmdesc; 
       // @AuraEnabled public decimal qty;  
        @AuraEnabled public String bolno; 
        @AuraEnabled public String prono; 
       // @AuraEnabled public String line_comment;
        @AuraEnabled public decimal ordln;   
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
        @AuraEnabled public decimal qty_invoice;
        
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