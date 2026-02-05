({
    updateTotalCartCount : function(component, event, helper) {
        try{
        //event to update cart details (on Header)
        var menuEvent = $A.get("e.c:eDealerCartUpdateEvent");  
        menuEvent.fire();
        }catch(e){
            console.log("error : "+e.message);
        }    
    }
})