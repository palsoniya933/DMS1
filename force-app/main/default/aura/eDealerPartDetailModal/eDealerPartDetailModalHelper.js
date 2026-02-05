({
    fetchOnloadDetails : function(component, event, helper) {
        // method name i.e. fetchOnloadDetails should be same as defined in apex class
        var action = component.get('c.fetchOnloadDetails_apex'); 
        
        // params name i.e. partNum should be same as defined in getEntity method
        action.setParams({
            "partNum" : component.get("v.partNumber"),
            "division": component.get('v.division')			
        });    
        action.setBackground();
        
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            
            if(state == 'SUCCESS') {
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else if(!$A.util.isUndefinedOrNull(resultData.response)){
                    component.set("v.imagelist", resultData.response.cdn_path);                   
                    component.set("v.videolist", resultData.response.video);                    
                    component.set("v.documentlist", resultData.response.document);
                }                    
            }            
            
        });
        $A.enqueueAction(action);
    },
    
    fetchPartDetail : function(component, event, helper) {
        var action = component.get('c.PartDetailFromSnowFlake'); 
        var aa = component.get('v.dealerCode');
        action.setParams({
            "partNum" : component.get("v.partNumber"),
            "lan" : component.get('v.language'),
            "division" : component.get('v.division'),			
            "dealecode" : component.get('v.dealerCode')
        });
        action.setBackground();        
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state      
            component.set("v.displayLoading",false);
            if(state == 'SUCCESS') {
                var resultData = response.getReturnValue(); 
                //console.log('resultData');
                //console.log(resultData);
                //console.log('resultData str : '+JSON.stringify(resultData));
               // console.log(resultData.error);
                if(!$A.util.isUndefinedOrNull(resultData.response)){
                    //console.log("partDetail ==>> "+JSON.stringify(resultData.response));
                    //console.log("partDetail ==>> "+JSON.stringify(resultData.response.alternate_parts));
                    component.set('v.partDetail', resultData.response);
                    component.set('v.alternateDetail', resultData.response.alternate_parts);
                    component.set('v.partDetailObj', resultData.response.parts_details);
                    component.set('v.dealerDataDetail', resultData.response.dealers_data);
                    component.set("v.showPartDetails",true);
                    
                }
            }
        });
        $A.enqueueAction(action);
    }
})