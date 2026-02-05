({
      checkPage : function(component, event, helper) {
        debugger;
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        
        // start index calc
        var startindex = pageNumber * pageSize;
        var endIndex = startindex + parseInt(pageSize);
        
        // getting total data
        var allRecs = component.get("v.totalRecords");
          
          if(endIndex>allRecs.length){
               helper.fetchMasterInventoryPartsDetails(component, event, helper);
          }else{
               helper.handleNext2(component, event, helper);
          }
    },
         
	 fetchMasterInventoryPartsDetails : function(component, event, helper) {
        debugger;
      //   console.log("current value: " + event.getParam("value"));
        var searchText = '';// event.getParam("value");
        var locCode = component.get("v.dealerCode");
        var division = component.get("v.currentDealerDivision");
    //  var recordLimit = component.get("v.recordLimit");
        var offset = component.get("v.offset_value");
        offset=offset+1;
          component.set("v.offset_value",offset);
         console.log('Log = '+locCode);
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
       var action = component.get("c.getMasterInvParts");
        action.setParams({
            "dealerCode" : locCode,
            "division" : division,
            "offSet" : offset,
            "searchText":searchText
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("MI P parts ==>> "+JSON.stringify(response.getReturnValue()));
                var allRecs = component.get("v.totalRecords");
                 var currentPageRecs = [];
               for(var i = 0; i< allRecs.length; i++){
            		currentPageRecs.push(allRecs[i]);
        		}
               var secondLength =allRecs.length; 
              	allRecs='';
               allRecs = response.getReturnValue();
              for(var i = 0; i< allRecs.length; i++){
              		currentPageRecs.push(allRecs[i]);
                	//secondLength++;
              }
               
                component.set("v.totalRecords", currentPageRecs);
                helper.handleNext2(component, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            //hide spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
     handleNext2: function(component, event, helper) {
        debugger;
        // this will svae the current page records
        var currentPageRecs = [];
        
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        
        // start index calc
        var startindex = pageNumber * pageSize;
        var endIndex = startindex + parseInt(pageSize);
        
        // getting total data
        var allRecs = component.get("v.totalRecords");
          console.log('startindex ='+startindex);
        console.log('endIndex ='+endIndex);
        console.log('allRecs.length ='+allRecs.length);
        if(endIndex > allRecs.length){
            endIndex = allRecs.length;
        }
        
        // getting first page data
        for(var i = startindex; i< endIndex; i++){
            console.log('allRecs[i]='+allRecs[i]);
            	currentPageRecs.push(allRecs[i]);
        }
        
        component.set("v.PaginationList", currentPageRecs);
      //  var totalPage =  component.get("v.TotalPages");
        // console.log('Total Page = '+totalPage);
          //console.log('str = '+str);
         //if(str){
           //pageNumber = totalPage; 
         //}else{
        	pageNumber++;
         //}
        component.set("v.PageNumber", pageNumber);    
        
        if( pageNumber == 1){
            component.set("v.disabledprevious",true);
        }
        else{
            component.set("v.disabledprevious",false);
        }
        
        // disable next button
       /* if( pageNumber == component.get("v.TotalPages")){
             component.set("v.disablednext",true);
        }
        else{
            component.set("v.disablednext",false);
        }*/
        
        component.set("v.RecordStart", pageSize * (pageNumber -1 ));
        component.set("v.RecordEnd", pageSize * pageNumber);
         component.set("v.displayLoading",false);
    },
})