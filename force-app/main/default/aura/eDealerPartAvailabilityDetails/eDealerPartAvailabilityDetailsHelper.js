({
    partAvailabilityDetails : function(component, event, helper) {
        var dealerLoc = component.get('v.dealerCode');
        var partNumber = component.get('v.partNumber');
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(dealerLoc)){
            return;
        }
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(partNumber)){
            return;
        }
        
        //show Spinner
        component.set("v.displayLoading", true);
        var action = component.get('c.fetchPartAvailabilityDetails'); 
        // params name i.e. partNum should be same as defined in getEntity method
        action.setParams({
            "dealerCode" : dealerLoc,
            "partNum" : partNumber,
            "userName" : component.get("v.dealerUserName")
        });
        action.setBackground();
        action.setCallback(this, function(a){
            //Hide Spinner
            component.set("v.displayLoading", false);
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var availablechk =  a.getReturnValue().PartAvl;
                console.log('availablechk:::'+JSON.stringify(a.getReturnValue().languageTranslation));
                var qtyflag = false;
                for(var i=0; i< availablechk.length; i++){
                    if(!$A.util.isEmpty(availablechk[i].AvailQty))
                    availablechk[i].AvailQty = (helper.getStringToNumber(availablechk[i].AvailQty) == undefined) ? availablechk[i].AvailQty : (helper.getStringToNumber(availablechk[i].AvailQty)).toString();
                	if(!$A.util.isEmpty(availablechk[i].IntranQty))
                        availablechk[i].IntranQty = (helper.getStringToNumber(availablechk[i].IntranQty) == undefined) ? availablechk[i].IntranQty : (helper.getStringToNumber(availablechk[i].IntranQty)).toString();
                    if(!$A.util.isEmpty(availablechk[i].OrderQty))
                        availablechk[i].OrderQty = (helper.getStringToNumber(availablechk[i].OrderQty) == undefined) ? availablechk[i].OrderQty : (helper.getStringToNumber(availablechk[i].OrderQty)).toString();
                    
                    availablechk[i].PdcLeadTm =  $A.util.isEmpty(availablechk[i].PdcLeadTm) ? '-'  : availablechk[i].PdcLeadTm;
                	
                    if(qtyflag != true && !$A.util.isEmpty(availablechk[i].AvailQty) && helper.getStringToNumber(availablechk[i].AvailQty) > 0){
                        qtyflag = true;
                    }
                }
                 console.log('PartAvl:::'+JSON.stringify(a.getReturnValue()));

                component.set('v.partAvailabilityObj', a.getReturnValue());
                component.set('v.partAvalibleFlag', qtyflag); 
                component.set("v.languageTranslation", a.getReturnValue().languageTranslation);
                
                 helper.setGridColumns(component, event, helper);
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
                //Hide Spinner
                component.set("v.displayLoading", false);
            }
        });
        $A.enqueueAction(action);
    },
                           
       getStringToNumber : function(strNum){
            try{
                if(isNaN(parseInt(strNum))){
                    return undefined;
                }else{
                    return parseInt(strNum);
                }
            }catch(e){
                return undefined;
            }
        },                      
    
    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": "Error!",
            "type": "error",
            "message": message
        });
        toastEvent.fire();
    },
     setGridColumns : function(component, event, helper) {
        //APi Data COlumns
        //var tableData = component.get("v.tableData");
        
        var languageTranslation = component.get("v.languageTranslation");
        console.log('.languageTranslation:::'+JSON.stringify(languageTranslation));
        const columns =[];
        for (let [key, value] of Object.entries(languageTranslation)) {
            columns.push({key:key,value:value.label});
            
        }
       component.set("v.columnLabelByApiName",columns);
    }
    
})