({
    doInit: function(component,event,helper){
        debugger;
        
        var preSearchedVal = component.get("v.preSearchVal");
        
        if(!$A.util.isEmpty(preSearchedVal)){
            // call the apex class method 
            var action = component.get("c.fetchLookUpValues");
            // set param to method  
            action.setParams({
                'searchKeyWord': preSearchedVal,
                'ObjectName' : component.get("v.objectAPIName")
            });
            // set a callBack    
            action.setCallback(this, function(response) {
                $A.util.removeClass(component.find("mySpinner"), "slds-show");
                var state = response.getState();
                if (state === "SUCCESS") {
                    var listOfSearchRecords = response.getReturnValue();
                    if(!$A.util.isUndefinedOrNull(listOfSearchRecords) && listOfSearchRecords.length > 0){
                        for(var i=0;i<listOfSearchRecords.length;i++){
                            if(listOfSearchRecords[i].Carrier_Code__c  == preSearchedVal){
                                component.set("v.selectedRecord" , listOfSearchRecords[i]);
                                component.set("v.disabled", true);
                                var forclose = component.find("lookup-pill");
                                $A.util.addClass(forclose, 'slds-show');
                                $A.util.removeClass(forclose, 'slds-hide');
                                
                                var forclose = component.find("searchRes");
                                $A.util.addClass(forclose, 'slds-is-close');
                                $A.util.removeClass(forclose, 'slds-is-open');
                                
                                var lookUpTarget = component.find("lookupField");
                                $A.util.addClass(lookUpTarget, 'slds-hide');
                                $A.util.removeClass(lookUpTarget, 'slds-show');
                                return;
                            }                
                        }
                    }
                }
                
            });
            // enqueue the Action  
            $A.enqueueAction(action); 
        }
        
    },
     
	onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );   
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
	},
})