/******
 *  Name : EDealerHeaderController
 *  Description : This is the apex class which is used for eDealerHeader component 
 **/ 
public with sharing class EDealerHeaderController {
    
    // this method is used for pulling the all items count present in cart
    @AuraEnabled
    public static CartSummryWrapper fetchCartItemsDetails(String dealerCode){
        //getting the dealer locaion details
        //Account dealerLocation = EDealerAccountContactRelationshipUtils.getDealerLocationDetails(dealerCode);
        List<Account> accList;
        
        if(Schema.sObjectType.Account.fields.Id.isAccessible()
           && Schema.sObjectType.Account.fields.name.isAccessible()
           && Schema.sObjectType.Account.fields.Dealer_Code__c.isAccessible()
          ){
              accList = [SELECT Id, name, Dealer_Code__c FROM Account WHERE Dealer_Code__c =:dealerCode AND Dealer_Code__c != null LIMIT 1];
          }
        
        
        if(accList.isEmpty()){
            return new CartSummryWrapper(0,0,0,0);
        }
        
        // get list of carts
        List<EDealerCart__c> lstCartDetails = EDealerCartUtils.getCartDetails(accList[0].Id, 
                                                                              new set<String>{EDealerConstants.CART_ORDER_TYPE_EMERGENCY,EDealerConstants.CART_ORDER_TYPE_STOCK,EDealerConstants.CART_ORDER_TYPE_DSP,EDealerConstants.CART_ORDER_TYPE_DSP_EMERGENCY}, 
                                                                              new set<String>{EDealerConstants.CART_TYPE_CART}); 
        
        // this will save the different order Items
        Integer stockItem = 0;
        Integer EmergencyItem = 0;
        Integer DSPItem = 0;
        Integer DSPEmergencyItem = 0;
        
        // iterate for each record
        for(EDealerCart__c ecart : lstCartDetails){
            if(ecart.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_EMERGENCY){
                EmergencyItem++;
            }
            
            else if(ecart.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_STOCK){
                stockItem++;
            }
            
            else if(ecart.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_DSP){
                DSPItem++;
            }
            else if(ecart.Order_Type__c == EDealerConstants.CART_ORDER_TYPE_DSP_EMERGENCY){
                DSPEmergencyItem++;
            }
        }
        
        // return count
        return new CartSummryWrapper(EmergencyItem,stockItem,DSPItem, DSPEmergencyItem);
    }
     
    @AuraEnabled
    public static Boolean getCsrToggle(){
        return eDealerToggle.csrToggle();
    }
    
    // this is the wrapper class which will have size for stock / 
    public class CartSummryWrapper{
        @AuraEnabled public integer stoc ;
        @AuraEnabled public integer DSP ;
        @AuraEnabled public integer DSPEmergency ;
        @AuraEnabled public integer Emergency ;
        @AuraEnabled public integer total ;
        
        // constructor
        public CartSummryWrapper(integer stoc, integer DSP, integer Emergency, integer DSPEmergency){
            this.Emergency = Emergency;
            this.stoc = stoc;
            this.DSP = DSP;
            this.DSPEmergency = DSPEmergency;
            this.total = Emergency + stoc + DSP + DSPEmergency;
        }
        
            
    }

}