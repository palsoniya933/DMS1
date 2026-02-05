/**
 * This apex class is used in the cart component which will be used for
 * Stock order / emergency / DSP
 * if user wants to place order
 ***/
 
public without sharing class EDealerCartController { 
    
    // this method is used for pulling the data for emergency suggested orders which is in cart
    @AuraEnabled
    public static list<CartItemWrapper> fetchEMCartItemsDetails(String dealerCode){
        // this will save the casr items to be displayed
        list<CartItemWrapper> lstCartItems = new list<CartItemWrapper>();
        
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return lstCartItems;
        }
        
        // get list of carts
        List<EDealerCart__c> lstCartDetails = EDealerCartUtils.getCartDetails(accList[0].Id, new set<String>{EDealerConstants.CART_ORDER_TYPE_EMERGENCY}, new set<String>{EDealerConstants.CART_TYPE_CART});
       
        // for each cart item
        for(EDealerCart__c cartitem : lstCartDetails){
            lstCartItems.add( new CartItemWrapper(cartitem) );
        }        
        
        // return the cart items
        return lstCartItems;
    }
    
    // this method is used for pulling the data for emergency STOCK orders which is in cart
    @AuraEnabled
    public static list<CartItemWrapper> fetchSTOCKCartItemsDetails(String dealerCode){
        // this will save the casr items to be displayed
        list<CartItemWrapper> lstCartItems = new list<CartItemWrapper>();
        
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return lstCartItems;
        }
        
        // get list of carts
        List<EDealerCart__c> lstCartDetails = EDealerCartUtils.getCartDetails(accList[0].Id, new set<String>{EDealerConstants.CART_ORDER_TYPE_STOCK}, new set<String>{EDealerConstants.CART_TYPE_CART});
        
        // for each cart item
        for(EDealerCart__c cartitem : lstCartDetails){
            lstCartItems.add( new CartItemWrapper(cartitem) );
        }        
        
        // return the cart items
        return lstCartItems; 
    }
    
    // this method is used for pulling the data for DSP Order
    @AuraEnabled
    public static list<CartItemWrapper> fetchDSPCartItemsDetails(String dealerCode){
        // this will save the casr items to be displayed
        list<CartItemWrapper> lstCartItems = new list<CartItemWrapper>();
        
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return lstCartItems;
        }
        
        // get list of carts
        List<EDealerCart__c> lstCartDetails = EDealerCartUtils.getCartDetails(accList[0].Id, new set<String>{EDealerConstants.CART_ORDER_TYPE_DSP}, new set<String>{EDealerConstants.CART_TYPE_CART});
         
        // for each cart item
        for(EDealerCart__c cartitem : lstCartDetails){
            lstCartItems.add( new CartItemWrapper(cartitem) );
        }        
        
        // return the cart items
        return lstCartItems;
    }
    
    // this method is used for pulling the data for DSP Emeregency Order
    @AuraEnabled
    public static list<CartItemWrapper> fetchDSPEmeregencyCartItemsDetails(String dealerCode){        
        // this will save the casr items to be displayed
        list<CartItemWrapper> lstCartItems = new list<CartItemWrapper>();
        
        //getting the dealer locaion details
        List<Account> accList = EdealerAccountUtils.getDealersAccount(new Set<String> {dealerCode});
        
        if(accList.isEmpty()){
            return lstCartItems;
        }
        
        // get list of carts
        List<EDealerCart__c> lstCartDetails = EDealerCartUtils.getCartDetails(accList[0].Id, new set<String>{EDealerConstants.CART_ORDER_TYPE_DSP_EMERGENCY}, new set<String>{EDealerConstants.CART_TYPE_CART});
        
        // for each cart item
        for(EDealerCart__c cartitem : lstCartDetails){
            lstCartItems.add( new CartItemWrapper(cartitem) );
        }        
        
        // return the cart items
        return lstCartItems;
    }
    
    // this is the method which is called when user want to remove an items
    @AuraEnabled
    public static void removeCartItem(Id cartId){
        String errorMsg;
        //query carts
        List<EDealerCart__c> lstCart = EDealerCartUtils.getCartDetails(new Set<Id>{cartId}, EDealerConstants.CART_TYPE_CART); 
        //check items still exist in cart or not
        // if cartis empty or any cart item has already updated then show refresh message
        if(lstCart.isEmpty() || lstCart.size() != (new List<Id>{cartId}).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
        
        try{
            if(EDealerCart__c.sObjectType.getDescribe().isDeletable()){
                delete lstCart;
            }else{
                errorMsg = 'You don\'thave access to delete cart items';
            }
            
        }
        catch(Exception ex){
            system.debug('Error :: '+ex.getMessage());
            system.debug('Error line number :: '+ex.getLineNumber());
            errorMsg = ex.getMessage();
            if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                errorMsg = 'Your SOF data has been updated, please refresh your browser.';
            }
            
        } 
        
        if(String.isNotEmpty(errorMsg)){
            throw new AuraHandledException(errorMsg);
        }
        
    }
    
    // this method is used when user click on cancel order which will remove the items
    @AuraEnabled
    public static void removeAllCartItem(list<CartItemWrapper> cartItems){
        String errorMsg;
        Set<Id> cartItemsIds = new Set<Id>();
         // making list to be deleted
        for(CartItemWrapper wrap : cartItems){
            cartItemsIds.add(wrap.cartId);
        }
        
        //query carts
        List<EDealerCart__c> lstCart = EDealerCartUtils.getCartDetails(cartItemsIds, EDealerConstants.CART_TYPE_CART); 
        //check items still exist in cart or not
        // if cartis empty or any cart item has already updated then show refresh message 
        if(lstCart.isEmpty() || lstCart.size() != (new List<Id>(cartItemsIds)).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
        
        if(!lstCart.isEmpty()){
            try{
                if(EDealerCart__c.sObjectType.getDescribe().isDeletable()){
                    delete lstCart;
                }else{
                    errorMsg = 'You don\'t have access to delete cart items';
                }
            }
            catch(Exception ex){
                system.debug('Error :: '+ex.getMessage());
                system.debug('Error line number :: '+ex.getLineNumber());
                errorMsg = ex.getMessage();
                if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                    errorMsg = 'Your SOF data has been updated, please refresh your browser.';
                }
                
            }    
        }
        if(String.isNotBlank(errorMsg)){
            throw new AuraHandledException(errorMsg);
        }
        
    }
    
    // this method will be used to update EDealerCart__c quantiy field
    @AuraEnabled
    public static void updateEDealerRec(string recId,string qntyVal){
        String errorMsg;
        //query carts
        List<EDealerCart__c> lstCart = EDealerCartUtils.getCartDetails(new Set<Id>{recId}, EDealerConstants.CART_TYPE_CART); 
        //check items still exist in cart or not
        // if cart is empty or any cart item has already updated then show refresh message
        if(lstCart.isEmpty() || lstCart.size() != (new List<Id>{recId}).size()){
            throw new AuraHandledException('Your SOF data has been updated, please refresh your browser.');
        }
            //make the dealer cart record instance
            EDealerCart__c dealCart = new EDealerCart__c();
            //Set id and quantity value
            dealCart.Id = recId;
            if(qntyVal != null 
               && string.isNotBlank(qntyVal)){
                dealCart.Quantity__c = decimal.valueof(qntyVal);
            }else{
                dealCart.Quantity__c = 0;
            }
            
            try{
                // update the record
                System.debug('');
                if(Schema.sObjectType.EDealerCart__c.fields.Quantity__c.isUpdateable()){
                    update dealCart;
                  }else {
                      errorMsg = 'You don\'t have permission to update the cart';
                  }
            }
            catch(Exception ex){
                system.debug('Error :: '+ex.getMessage());
                system.debug('Error line number :: '+ex.getLineNumber());
                errorMsg = ex.getMessage();
                if(errorMsg.containsIgnoreCase('ENTITY_IS_DELETED')){
                    errorMsg = 'Your SOF data has been updated, please refresh your browser.';
                }
            } 
        
        if(String.isNotBlank(errorMsg)){
            throw new AuraHandledException(errorMsg); 
        }
        
    }
    
    // this is the Wrapper classes used to display Cart items data in the component
    public class CartItemWrapper{
        @AuraEnabled public Id cartId {get;set;}
        @AuraEnabled public Id suggestedOrderId {get;set;}
        @AuraEnabled public Integer Serial_Number {get;set;}
        @AuraEnabled public String Part_Name {get;set;}
        @AuraEnabled public String Part_Description {get;set;}
        @AuraEnabled public Integer qtyForOrder {get;set;}
        @AuraEnabled public String source {get;set;}
        @AuraEnabled public Boolean isDBSDSI {get;set;}
        @AuraEnabled public Boolean isPromo {get;set;}
        @AuraEnabled public String cartOrderType {get;set;}
        @AuraEnabled public EDealerSuggestedOrderUtils.SuggestedPartPriceWrapper PriceDetail {get;set;}
        
        // this is default contructor
        public CartItemWrapper(){}
        
        // this is parameterrized contructor to assign values
        public CartItemWrapper(EDealerCart__c cartItem){
			cartId = cartItem.Id;
            suggestedOrderId = cartItem.Suggested_Order__c;
            Serial_Number = (cartItem.Suggested_Order__r.Serial_Number__c == null) ? null : Integer.valueOf(cartItem.Suggested_Order__r.Serial_Number__c);
            Part_Name = cartItem.Suggested_Order__r.Part_Name__c;
            Part_Description = cartItem.Suggested_Order__r.Part_Description__c;
            qtyForOrder = ( cartItem.Quantity__c != null ? Integer.valueOf(cartItem.Quantity__c) : 0 );
            source = (cartItem.Suggested_Order__c == null) ? null : cartItem.Suggested_Order__r.Type__c;
            isDBSDSI = (cartItem.Suggested_Order__c == null) ? false : (cartItem.Suggested_Order__r.DBS_Type__c == EDealerConstants.DBS_DSI);
            isPromo = cartItem.Suggested_Order__r.Is_Special_Order_Part__c;
            
            //cartOrderType ::: used to know the items which in cart of PDC or DSP
            if(cartItem.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_EMERGENCY || cartItem.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_STOCK){
                cartOrderType = 'PDC';
            }else if(cartItem.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_DSP || cartItem.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_DSP_EMERGENCY){
                cartOrderType = 'DSP';
            }
            
            if(String.isNotBlank(cartItem.Suggested_Order__r.Pricing_Detail__c)){
               PriceDetail = (EDealerSuggestedOrderUtils.SuggestedPartPriceWrapper)System.JSON.deserialize(cartItem.Suggested_Order__r.Pricing_Detail__c, EDealerSuggestedOrderUtils.SuggestedPartPriceWrapper.class);
            }
        }
    }

    
}