({
    
	fetchDelieveryMetricsData : function(component, event, helper) {
        //selected loc/dealer code
         var locCode = component.get("v.dealerLoc");
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        //show spinner
        component.set("v.displayLoading", true);
        
        var action = component.get("c.getDelieveryMetricsDetail");
        action.setParams({
            "dealerCode" : locCode
        });
        action.setBackground();
        action.setCallback(this, function(response) {
            //Hide spinner
            component.set("v.displayLoading", false);           
            var state = response.getState();
            if (state === "SUCCESS") { 
                var resultData = response.getReturnValue();
                
                if(!$A.util.isEmpty(resultData.error)){
                    //show error message
                    //helper.showErrorToast(component, event, helper, resultData.error);
                }else if(!$A.util.isUndefinedOrNull(resultData.response) && resultData.response.length > 0){
                    component.set("v.delieveryMetricsData", resultData.response);
                    //update U.I.
                    helper.updateUI(component, event, helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }            
        });
        $A.enqueueAction(action);
		
	},
    
    updateUI : function(component, event, helper) {
        var delieveryMetricsData =  component.get("v.delieveryMetricsData");
        var selectedoption = component.get("v.selectedoption");
        var delayDelieveryMetrics = 0;
        var ontimeDelieveryMetrics = 0;
        if(!$A.util.isUndefinedOrNull(delieveryMetricsData) && delieveryMetricsData.length > 0 
          && !$A.util.isUndefinedOrNull(delieveryMetricsData[0].DeliveredMetrics) && delieveryMetricsData[0].DeliveredMetrics.length > 0){
            for(var i=0;i<delieveryMetricsData[0].DeliveredMetrics.length;i++){
                //FOR DELAY
                if(selectedoption == 'Daily' && delieveryMetricsData[0].DeliveredMetrics[i].dayDelay > 0){
                    delayDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].dayDelay;
                }else if(selectedoption == 'Weekly' && delieveryMetricsData[0].DeliveredMetrics[i].weekDelay > 0){
                    delayDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].weekDelay;
                }else if(selectedoption == 'Monthly' && delieveryMetricsData[0].DeliveredMetrics[i].monthDelay > 0){
                    delayDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].monthDelay;
                }else if(selectedoption == 'Quarterly' && delieveryMetricsData[0].DeliveredMetrics[i].quarterDelay > 0){
                    delayDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].quarterDelay;
                }else if(selectedoption == 'Annually' && delieveryMetricsData[0].DeliveredMetrics[i].yearDelay > 0){
                    delayDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].yearDelay;
                }
                
                 //FOR ON-TIME
                if(selectedoption == 'Daily' && delieveryMetricsData[0].DeliveredMetrics[i].dayOntime > 0){
                    ontimeDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].dayOntime;
                }else if(selectedoption == 'Weekly' && delieveryMetricsData[0].DeliveredMetrics[i].weekOntime > 0){
                    ontimeDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].weekOntime;
                }else if(selectedoption == 'Monthly' && delieveryMetricsData[0].DeliveredMetrics[i].monthOntime > 0){
                    ontimeDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].monthOntime;
                }else if(selectedoption == 'Quarterly' && delieveryMetricsData[0].DeliveredMetrics[i].quarterOntime > 0){
                    ontimeDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].quarterOntime;
                }else if(selectedoption == 'Annually' && delieveryMetricsData[0].DeliveredMetrics[i].yearOntime > 0){
                    ontimeDelieveryMetrics = delieveryMetricsData[0].DeliveredMetrics[i].yearOntime;
                }
            }
        }
        
        delayDelieveryMetrics = (delayDelieveryMetrics % 1 != 0) ? delayDelieveryMetrics.toFixed(1) : delayDelieveryMetrics;
        ontimeDelieveryMetrics = (ontimeDelieveryMetrics % 1 != 0) ? ontimeDelieveryMetrics.toFixed(1) : ontimeDelieveryMetrics;
        
        component.set("v.refresh", false);
        component.set("v.delayP", delayDelieveryMetrics.toString());
        component.set("v.ontimeP", ontimeDelieveryMetrics.toString());
        component.set("v.refresh", true);
        helper.myActionHelper(component, event, helper);
        
        
    },
    
    myActionHelper: function(component, event, helper) {
		  jQuery("document").ready(function(){
           /*$('#demo-pie-1').pieChart({
                barColor: '#68b828',
                trackColor: '#eee',
                lineCap: 'round',
                lineWidth: 8,
                onStep: function (from, to, percent) {
                    $(this.element).find('.pie-value').text(Math.round(percent) + '%');
                }
            });

            $('#demo-pie-2').pieChart({
                barColor: '#8465d4',
                trackColor: '#eee',
                lineCap: 'round',
                lineWidth: 8,
                onStep: function (from, to, percent) {
                    $(this.element).find('.pie-value').text(Math.round(percent) + '%');
                }
            });*/

            $('#demo-pie-3').pieChart({
                barColor: '#3AC835',
                trackColor: '#eee',
                lineCap: 'round',
                lineWidth: 8,
                size:95,
                onStep: function (from, to, percent) {
                    $(this.element).find('.pie-value').text(to + '%');
                }
            });

            $('#demo-pie-4').pieChart({
                barColor: '#FF6200',
                trackColor: '#eee',
                lineCap: 'round',
                
                lineWidth: 8,
                size:95,
                onStep: function (from, to, percent) {
                    $(this.element).find('.pie-value').text(to + '%');
                }
            });
        });
	}
    
    
    
})