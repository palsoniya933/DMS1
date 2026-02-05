/**
* @description This is the apex class which will be used to send Suggested Orders to ASI System.
*/
public without sharing class EDealerPlaceOrderController {
    /**
    * @description to validate the cart parts already ordered or not
    */
    @AuraEnabled
    public static void validateCartParts( List<EDealerCartController.CartItemWrapper> cartOrders){
            Set<Id> cartIds = new Set<Id>();
            for(EDealerCartController.CartItemWrapper wrap : cartOrders){
                cartIds.add(wrap.cartId);
            }
            //query carts
            List<EDealerCart__c> lstCart = EDealerCartUtils.getCartDetails(cartIds, EDealerConstants.CART_TYPE_CART); 
            //check items still exist in cart or not
            // if cart is empty or any cart item has already updated then show refresh message
            if(lstCart.isEmpty() || lstCart.size() != (new List<Id>(cartIds)).size()){
                throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
            }
    }
    
    /*
    * @description This method used to create an order on ASI
    * @return order information
    */
    @AuraEnabled
    public static ConfirmedOrderNumberWrapper placeOrderToASI(String dealerCode, String orderType, String poNumber, String carrier, Date shipmentDate, String comments, List<EDealerCartController.CartItemWrapper> cartOrders){
        //validate cart items
        validateCartParts(cartOrders);
        
        //validate current user update permission
        if(Schema.sObjectType.EDealerCart__c.fields.Type__c.isUpdateable() == false
           || Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isUpdateable() == false
          ){
              throw new AuraHandledException('You don\'t have permission to update the cart.');
          }
        
        try{
            Set<Id> cartItemIDs = new Set<Id>();
            //List of cart items which ordered on ASI
            List<EDealerCart__c> lstCartOrdered = new List<EDealerCart__c>();
            //Map/List of cart items which Not ordered on ASI
            Map<Id, EDealerCart__c> mapCartNotOrdered = new Map<Id, EDealerCart__c>();
            //Map of Cart Order by Part Number
            Map<String,List<EDealerCartController.CartItemWrapper>> mapOrderPart = new Map<String, List<EDealerCartController.CartItemWrapper>>();
            for(EDealerCartController.CartItemWrapper cartPart : cartOrders){
                cartItemIDs.add(cartPart.cartId);//cart ids set
                if(mapOrderPart.containsKey(cartPart.Part_Name)){
                    mapOrderPart.get(cartPart.Part_Name).add(cartPart);
                }else{
                    List<EDealerCartController.CartItemWrapper> tempCartlist = new List<EDealerCartController.CartItemWrapper>();
                    tempCartlist.add(cartPart);
                    mapOrderPart.put(cartPart.Part_Name, tempCartlist);
                }
                
            }
            //List of cart items for asi order
            List<EDealerCart__c> cartItemsList = EDealerCartUtils.getCartDetails(cartItemIDs);
            
            //Map<part number, isPromo>
            Set<String> setPartWithPromo = new Set<String>();
            for(EDealerCart__c cartItem : cartItemsList){
                if(cartItem.Suggested_Order__r.Is_Special_Order_Part__c == true){
                    setPartWithPromo.add(cartItem.Suggested_Order__r.Part_Name__c);
                }
            }
            
            // create request body
            String reqBody = createOrderCreationRequest(dealerCode, orderType, poNumber, carrier, shipmentDate, comments, mapOrderPart);
            
            // Create Order (call AWS server for order creation)
            ConfirmedOrderNumberWrapper createdOrderWrap = callAWSOrderCreationAPI(reqBody);
            
            //if order created
            //upate the orders with quatity based on API Response
            //make a list of submitted orders
            //If Order Number present that means order created and need to update same on Salesforce
            if(createdOrderWrap != null && createdOrderWrap.Data != null && String.isNotBlank(createdOrderWrap.Data.OrderNumber)){
                for(OrderPartDetailWrapper opdWrap : createdOrderWrap.Data.OrderPartDetails){
                    String orderedPartNum = (String.isBlank(opdWrap.CustomerSKU)) ? opdWrap.ItemID : opdWrap.CustomerSKU;
                    if(mapOrderPart.containskey(orderedPartNum)){
                        List<EDealerCartController.CartItemWrapper> tempCartlist = mapOrderPart.get(orderedPartNum);
                        for(Integer i=0;i<tempCartlist.size();i++){
                            EDealerCart__c c = new EDealerCart__c();
                            c.Id = tempCartlist[i].cartId;
                            c.Type__c = EDealerConstants.CART_TYPE_PLACED;
                            if(setPartWithPromo.contains(tempCartlist[i].Part_Name)){
                                c.Quantity__c = (tempCartlist[i].isPromo == true) ? opdWrap.PartQuantity : 0;
                            }else{
                                c.Quantity__c = (i==0) ? opdWrap.PartQuantity : 0 ;
                            }
                            lstCartOrdered.add(c);  
                        }  
                    }
                }
            }
            //Update cart in salesforce for Created Parts on ASI
            if(!lstCartOrdered.isEmpty()){
                if(Schema.sObjectType.EDealerCart__c.fields.Id.isUpdateable()
                  && Schema.sObjectType.EDealerCart__c.fields.Type__c.isUpdateable()
                   && Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isUpdateable()
                  ){
                    update lstCartOrdered;
                  }
            }
            //RETURN THE API RESPONSE
            return createdOrderWrap;
            
        }catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EDealerPlaceOrderController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            
            system.debug('Error :: '+ex.getMessage());
            system.debug('Error line number :: '+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }  
    }
    
    /****
    * Description : This method use to get the automated PO Number From ASI by calling snowflake api
    */ 
    @AuraEnabled
    public static PlaceOrderNumberWrapper fetchPlaceOrderNumber(String dealerCode){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        PlaceOrderNumberWrapper awsReportResultData = new PlaceOrderNumberWrapper();
        HttpRequest req = new HttpRequest();
        calloutDetails.put('endpoint','/purchase_order_creation/'+dealerCode+'/orders');
        calloutDetails.put('method','POST'); 
        calloutDetails.put('body','{"Action": "ReservePO","DealerCode": "'+dealerCode+'"}');
        calloutDetails.put('classname','EDealerPlaceOrderController');
        calloutDetails.put('methodname','fetchPlaceOrderNumber');
        
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        //Call EDealerLogUtils class based on response status code.
        // parsing the actual results
        if(jsonRes != null){
            awsReportResultData = (PlaceOrderNumberWrapper)System.JSON.deserialize(jsonRes, PlaceOrderNumberWrapper.class);
        }
        
        return awsReportResultData;
    }
    
    /***
    * Description : This Method will use to send the Purchased/Confirmed Order details to DSI
    */ 
    @AuraEnabled
    public static OrderUpdateWrapper updatePurchaseOrderDetailsOnDSI(String dealerCode, String purchasedOrderNumber, List<EDealerCartController.CartItemWrapper> cartOrders){
        //Set of CartItems Ids
        Set<Id> cartIds = new Set<Id>();
        //Cart Items which we need to update on DSI
        List<EDealerCart__c> cartItems = new List<EDealerCart__c>();
        
        for(EDealerCartController.CartItemWrapper cartWrap : cartOrders){
            cartIds.add(cartWrap.cartId);
        }
        
        if(!cartIds.isEmpty()){
            cartItems = EDealerCartUtils.getCartDetails(cartIds, EDealerConstants.CART_TYPE_PLACED);  
        }
        
        if(cartItems.isEmpty()){
            throw new AuraHandledException('No Part Available to Update on DSI.');
        }
        
        // create request body for DSI
        String reqBody = createDSIConfirmedOrderRequest(dealerCode, purchasedOrderNumber, cartItems);
        // Create Order (call AWS server for order creation)
        OrderUpdateWrapper wrap = callDSIUpdateOrderAPI(reqBody);
        
        return wrap;
    }
    
    /**
    * @description to crate Order Creation Request body
    * @return the body of order creation request
    */
    public static String createOrderCreationRequest(String dealerCode, String orderType, String poNumber, String carrier, Date shipmentDate, String comments, Map<String,List<EDealerCartController.CartItemWrapper>> mapOrderPart){
        JSONGenerator gen = JSON.createGenerator(true);
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('DealerID', dealerCode);
        gen.writeStringField('OrderType', orderType);
        gen.writeStringField('CustomerPO', poNumber);
        gen.writeStringField('FreightCarrier', carrier);
        gen.writeNumberField('RequestShipDate', Integer.valueOf(String.valueOf(shipmentDate.month())+String.valueOf(shipmentDate.day())+ string.valueof(shipmentDate.year()).right(2)));
        if(String.isNotBlank(comments)){
            gen.writeStringField('HeaderComments', comments);
        }
        gen.writeFieldName('DetailInfo');
        gen.writeStartArray();
        
        Integer lineNumber = 0;
        for(String partNumber : mapOrderPart.keySet()){
            lineNumber++;
            Integer totalQty = 0;
            List<EDealerCartController.CartItemWrapper> cartOrders = mapOrderPart.get(partNumber);
            //cart items
            gen.writeStartObject();
            gen.writeNumberField('LineNumber', lineNumber);
            gen.writeStringField('PartNumber', cartOrders[0].Part_Name);
            //get total ordered quantity for a single part
            for(Integer i=0;i<cartOrders.size();i++){
                totalQty += cartOrders[i].qtyForOrder;
            }
            gen.writeNumberField('QuantityOrdered', totalQty);
            gen.writeEndObject();
        }
        
        gen.writeEndArray();// end of array
        gen.writeEndObject();//end of json
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        
        return pretty;
    }
    
    /***
    * This method use to call to create Order on AWS/ASI
    */ 
    @AuraEnabled
    public static ConfirmedOrderNumberWrapper callAWSOrderCreationAPI(String JSONReq){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        ConfirmedOrderNumberWrapper awsReportResultData = new ConfirmedOrderNumberWrapper();
        calloutDetails.put('endpoint','/asi-order-creation/order');
        calloutDetails.put('method','POST');   
        calloutDetails.put('body',JSONReq);
        calloutDetails.put('classname','EDealerPlaceOrderController');
        calloutDetails.put('methodname','callAWSOrderCreationAPI');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
       
        // parsing the actual results
        if(jsonRes != null){
            awsReportResultData = (ConfirmedOrderNumberWrapper)System.JSON.deserialize(jsonRes, ConfirmedOrderNumberWrapper.class);
        }   
        return awsReportResultData;
    }
    
    
    /**
    * @description This method use to send the confirm order details to DSI
    */ 
    @AuraEnabled
    public static OrderUpdateWrapper callDSIUpdateOrderAPI(String JSONReq){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        OrderUpdateWrapper awsReportResultData = new OrderUpdateWrapper();
        calloutDetails.put('endpoint','/dsi_purchase_order_update/dealer/order-update');
        calloutDetails.put('method','POST');    
        calloutDetails.put('body',JSONReq);
        calloutDetails.put('classname','EDealerPlaceOrderController');
        calloutDetails.put('methodname','callDSIUpdateOrderAPI');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        // parsing the actual results
        if(jsonRes != null){
            awsReportResultData = (OrderUpdateWrapper)System.JSON.deserialize(jsonRes, OrderUpdateWrapper.class);
        }       
        return awsReportResultData;
    }
    
    /**
    * @description Creating the Request which we will send to DSI
    * @return the  request body
    */
    public static String createDSIConfirmedOrderRequest(String dealerCode, String confirmedOrderNumber, List<EDealerCart__c> cartItems){
        JSONGenerator gen = JSON.createGenerator(true);
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('Action', 'CreatePO');
        gen.writeStringField('DealerCode', dealerCode);
        gen.writeStringField('PurchaseOrder', confirmedOrderNumber);
        gen.writeFieldName('Parts');
        gen.writeStartArray();
        //cart items
        for(Integer i=0;i<cartItems.size();i++){
            gen.writeStartObject();
            gen.writeStringField('PartNumber', cartItems[i].Suggested_Order__r.Part_Name__c);
            gen.writeNumberField('Quantity', cartItems[i].Quantity__c);
            gen.writeEndObject();
        }
        gen.writeEndArray();// end of array
        gen.writeEndObject();//end of json
        
        // Get the JSON string.
        String pretty = gen.getAsString();
        return pretty;
    }
    
    /**
    * @description hadle the Place order number api response
    */
    public class PlaceOrderNumberWrapper {
        @AuraEnabled
        public String purchaseOrderNumber {get;set;}
        @AuraEnabled
        public String error {get;set;}
    }
    /**
    * @description hadle the confirmed order number after the order createtion
    */
    public class ConfirmedOrderNumberWrapper {
        @AuraEnabled public OrderDetailWrapper Data;
        @AuraEnabled public MsgResponseWrapper MsgResponse;
    }
    
    /**
    * @description to check the order details api response after order api called
    */
    public class OrderDetailWrapper {
        @AuraEnabled public String OrderNumber;
        @AuraEnabled public String DealerID;
        @AuraEnabled public String Status;
        @AuraEnabled public List<OrderPartDetailWrapper> OrderPartDetails;
    }
    /**
    * @description to check each ordered part detail
    */
    public class OrderPartDetailWrapper {
        @AuraEnabled public String ItemID;
        @AuraEnabled public Double PartQuantity;
        @AuraEnabled public String LineStatus;
        @AuraEnabled public String CustomerSKU;
    }
    /**
    * @description to check success|error message 
    */
    public class MsgResponseWrapper {
        @AuraEnabled public String IsSuccess;
        @AuraEnabled public Integer MessagesCount;
        @AuraEnabled public List<OrderMessageWrapper> Messages;
    }
    /**
    * @description to check warning message
    */
    public class OrderMessageWrapper {
        @AuraEnabled
        public String MsgIdentifier {get;set;}
        @AuraEnabled
        public Integer MsgLine {get;set;}
        @AuraEnabled
        public String MsgItmid {get;set;}
        @AuraEnabled
        public String Description {get;set;}
    }
    /**
    * @description to handle Order update api response
    */
    public class OrderUpdateWrapper {
        @AuraEnabled
        public OrderUpdateStatusWrapper OrderUpdateStatus {get;set;}
        @AuraEnabled
        public String error {get;set;}
    }
    /**
    * @description to handle the satus of update order api response
    */
    public class OrderUpdateStatusWrapper {
        @AuraEnabled
        public String result {get;set;}
        @AuraEnabled
        public String message {get;set;}
        @AuraEnabled
        public String errorMessage {get;set;}
        @AuraEnabled
        public String recordCount {get;set;}
        @AuraEnabled
        public List<String> acceptedPartsNumbers {get;set;}
        @AuraEnabled
        public List<String> nonacceptedPartsNumbers {get;set;}
    }
    
}