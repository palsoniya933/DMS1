({
    fetchOrdersData : function(component, event, helper) {
        var action;
        var selectedMenu = component.get("v.selectedMenu");
        var dealerCode = component.get("v.dealerCode");
        var frequency = component.get("v.selectedoption");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(dealerCode)){
            return;
        }
        if(selectedMenu == 'intransitorders'){
            action = component.get("c.getInTransitOrders");
            action.setParams({ 
                dealerCode : dealerCode,
                frequency : frequency
            });
        }
        else if(selectedMenu == 'deliveredorders'){
            action = component.get("c.getDeleveredOrders");
            action.setParams({ 
                dealerCode : dealerCode,
                frequency : frequency
            });
        }
            else if(selectedMenu == 'partsdeliverymetrics'){
                action = component.get("c.getDelieveryMetricsOrders");
                action.setParams({ 
                    dealerCode : dealerCode,
                    frequency : frequency
                });
            }
        
        if($A.util.isUndefinedOrNull(action)){
            return;
        }
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            component.set("v.APICalled",true);
            var state = response.getState();
            component.set("v.displayLoading",false);
            if (state === "SUCCESS") {
                try{
                    // from the server
                    var result = response.getReturnValue();
                    if(!$A.util.isUndefinedOrNull(result) 
                       && !$A.util.isUndefinedOrNull(result.response)
                      ){
                        
                        if(selectedMenu == 'intransitorders' && result.response.length > 0  && !$A.util.isUndefinedOrNull(result.response[0].OrdersTransitTotal)){
                            var intransitordersList = result.response[0].OrdersTransitTotal;
                            var finalOrdersList = [];
                            if(!$A.util.isUndefinedOrNull(intransitordersList)){
                                for(var i=0;i<intransitordersList.length;i++){
                                    intransitordersList[i].status = result.response[0].STATUS;
                                    finalOrdersList.push(intransitordersList[i]);
                                }
                            }
                            component.set("v.totalOrders", finalOrdersList.length);
                            component.set("v.invData",finalOrdersList);
                            
                            
                        }
                        else if(selectedMenu == 'deliveredorders'  && !$A.util.isUndefinedOrNull(result.response.OrdersDeliveredTotal)){
                            var deliveredordersList = result.response.OrdersDeliveredTotal;
                            var finalOrdersList = [];
                            if(!$A.util.isUndefinedOrNull(deliveredordersList)){
                                for(var i=0;i<deliveredordersList.length;i++){
                                    deliveredordersList[i].status = result.response.STATUS;
                                    finalOrdersList.push(deliveredordersList[i]);
                                }
                            }
                            
                            component.set("v.totalOrders", finalOrdersList.length);
                            component.set("v.invData",finalOrdersList);
                        }
                            else if(selectedMenu == 'partsdeliverymetrics' && result.response.length > 0  && !$A.util.isUndefinedOrNull(result.response[0].DeliveredMetrics)){
                                var delayList = result.response[0].DeliveredMetrics.delayOrders;
                                var onTimeList = result.response[0].DeliveredMetrics.onTimeOrders;
                                
                                var finalOrdersList = [];
                                
                                if(!$A.util.isUndefinedOrNull(delayList)){
                                    for(var i=0;i<delayList.length;i++){
                                        delayList[i].status = 'Delay';
                                        finalOrdersList.push(delayList[i]);
                                    }
                                }
                                if(!$A.util.isUndefinedOrNull(onTimeList)){
                                    for(var i=0;i<onTimeList.length;i++){
                                        onTimeList[i].status = 'On Time';
                                        finalOrdersList.push(onTimeList[i]);
                                    }
                                }
                                
                                component.set("v.totalOrders", finalOrdersList.length);
                                component.set("v.invData",finalOrdersList);
                            }
                        
                    }
                }catch(e){
                    console.log('error :::'+e.message);
                }
                
            }
            else if (state === "INCOMPLETE") {
                // do something
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
        helper.setFrequecy(component, event, helper);
    },
    
    setFrequecy : function(component, event, helper){
        var frequency = component.get("v.selectedoption");
        if(frequency == "Day"){
            component.set("v.selectedoption", "Daily");
        }else if(frequency == "Week"){
            component.set("v.selectedoption", "Weekly");
        }else if(frequency == "Month"){
            component.set("v.selectedoption", "Monthly");
        }else if(frequency == "Quarter"){
            component.set("v.selectedoption", "Quarterly");
        }else if(frequency == "Year"){
            component.set("v.selectedoption", "Annually");
        }else if(frequency == "All"){
            component.set("v.selectedoption", "All");
        }
    }
})