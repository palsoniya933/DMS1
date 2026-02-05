({
    fetchOnloadDetails : function(component, event, helper) {
        // method name i.e. fetchOnloadDetails should be same as defined in apex class
        var action = component.get('c.fetchOnloadDetails_apex'); 
        var pNumber = component.get("v.partNumber");
        //alert(pNumber);
        if(!pNumber){
            return ;
        }
        
        // remove &loc from 
        else{
             pNumber = pNumber.replace('&loc','');
        }
        //alert(pNumber);
        // params name i.e. partNum should be same as defined in getEntity method
        action.setParams({
            "partNum" : pNumber,
            "division": component.get('v.division')
        });    
        action.setBackground();
        
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state            
            if(state == 'SUCCESS') {
                var resultData = response.getReturnValue(); 
                if(!$A.util.isEmpty(resultData.error)){                    
                }else if(!$A.util.isUndefinedOrNull(resultData.response)){
                    component.set("v.imagelist", resultData.response.cdn_path);                   
                     
                    
                    // for each video link added embed work
                    for(var ele in resultData.response.video){
                        var lastIndex = resultData.response.video[ele].lastIndexOf('/');
                        var NewURL = ['https://www.youtube.com/embed', resultData.response.video[ele].slice(lastIndex)].join('');                        
                        resultData.response.video[ele] = NewURL;
                    }
                    component.set("v.videolist", resultData.response.video);                      
                    component.set("v.documentlist", resultData.response.document);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPartDetail : function(component, event, helper) {
        var action = component.get('c.PartDetailFromSnowFlake'); 
        var pNumber = component.get("v.partNumber");        
        if(!pNumber){
            return ;
        }
        // remove &loc from 
        else{
             pNumber = pNumber.replace('&loc','');
        }
        action.setParams({
            "partNum" : pNumber,
            "lan" : component.get('v.language'),
            "division" : component.get('v.division'),
            "dealecode" : component.get('v.dealerCode')
        });         
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
                var resultData = response.getReturnValue(); 
                if(!$A.util.isUndefinedOrNull(resultData.response)){                    
                    component.set('v.partDetail', resultData.response);
                    component.set('v.alternateDetail', resultData.response.alternate_parts);
                    component.set('v.partDetailObj', resultData.response.parts_details);
                    component.set('v.dealerDataDetail', resultData.response.dealers_data);
                    component.set("v.languageTranslation", resultData.languageTranslation);
                    console.log("languageTranslation1::"+JSON.stringify(resultData.languageTranslation));
                    if(!$A.util.isUndefinedOrNull(resultData.response.parts_pricing) && resultData.response.parts_pricing.length > 0){
                        component.set("v.pricingInfo",resultData.response.parts_pricing[0]);
                    }
                    
                    component.set("v.showPartDetails",true);
                    
                
                 helper.setGridColumns(component, event, helper);
                    
                }
            }
            //hide the spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    showErrorToast : function(message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type": "error",
            "mode": 'sticky',
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