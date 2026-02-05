({
    doInit : function(component, event, helper) {
        var activeOrderWorkflowRec = component.get("v.activeOrderWorkflowRec");
        var cls = component.get("v.firstProgressCls");
        var cls2 = component.get("v.secondProgressCls");
        
        if(activeOrderWorkflowRec != null && activeOrderWorkflowRec != undefined){
            if(activeOrderWorkflowRec.orderWorkflowTMS != null
               && activeOrderWorkflowRec.orderWorkflowTMS != undefined){
                // set the delivery status
                if(activeOrderWorkflowRec.orderWorkflowTMS.STAT == 'Shipment Delivered'){
                    component.set("v.statusTMSOrder", 'Delivered on');
                }
                else{
                    component.set("v.statusTMSOrder", 'Delivery ETA');
                }
                component.set("v.trackingNumber", activeOrderWorkflowRec.orderWorkflowTMS.TRACKING_ID);
                component.set("v.trackingUrl", activeOrderWorkflowRec.orderWorkflowTMS.ENCRYPTED_URL);
                component.set("v.showTracking", true);
            }
            else{
                if(activeOrderWorkflowRec.ENCRYPTED_URL != null
                   && activeOrderWorkflowRec.ENCRYPTED_URL != undefined
                   && activeOrderWorkflowRec.ENCRYPTED_URL != ''){
                    component.set("v.trackingNumber", activeOrderWorkflowRec.PRO_NUM);
                    component.set("v.trackingUrl", activeOrderWorkflowRec.ENCRYPTED_URL);
                    component.set("v.showTracking", true);
                    
                    if(component.get("v.isFirstOrderDetails")){
                        cls = cls +" first-row-level-third";
                    }
                    else{
                        cls2 = cls2 +" second-row-level-second";
                    }
                    component.set("v.firstProgressCls", cls);
                    component.set("v.secondProgressCls", cls2);
                }
                else{
                    if(component.get("v.isFirstOrderDetails")){
                        //cls = cls +" first-row-level-second";
                    }
                    else{
                        //cls2 = cls2 +" second-row-level-first";
                    }
                    
                    if(activeOrderWorkflowRec.PRO_NUM != null
                       && activeOrderWorkflowRec.PRO_NUM != undefined
                       && activeOrderWorkflowRec.PRO_NUM != ''){
                        component.set("v.trackingNumber", activeOrderWorkflowRec.PRO_NUM);
                        component.set("v.showTracking", true);
                        
                        if(component.get("v.isFirstOrderDetails")){
                            cls = component.get("v.firstProgressCls") +" first-row-level-third";
                        }
                        else{
                            cls2 = component.get("v.secondProgressCls") +" second-row-level-second";
                        }
                    }
                    
                    component.set("v.firstProgressCls", cls);
                    component.set("v.secondProgressCls", cls2);
                }
            }
            
            
            var isfirstOrder = component.get("v.isFirstOrderDetails");   
            component.set("v.firstrowgreenlinewidth",'100%');
            component.set("v.secondrowgreenlinewidth",'100%');
            
            if(isfirstOrder){
                
                if(activeOrderWorkflowRec.orderWorkflowTMS != null
                   && activeOrderWorkflowRec.orderWorkflowTMS != undefined){
                    
                    if(activeOrderWorkflowRec.orderWorkflowTMS.STAT != 'Shipment Delivered'){
                        component.set("v.firstrowgreenlinewidth",'74%');
                    }
                }
                else{
                    component.set("v.firstrowgreenlinewidth",'74%');
                }            
            }
            else{
                if(activeOrderWorkflowRec.orderWorkflowTMS != null
                   && activeOrderWorkflowRec.orderWorkflowTMS != undefined){
                    
                    if(activeOrderWorkflowRec.orderWorkflowTMS.STAT != 'Shipment Delivered'){
                        component.set("v.secondrowgreenlinewidth",'65%');
                    }
                }
                else{
                    component.set("v.secondrowgreenlinewidth",'65%');
                }
            }
        }
        
        // set the tracking status
        if(component.get("v.totalRecords") > 1){
            component.set("v.trackingStatus", "PARTS SHIPPED");
            component.set("v.showTracking", true);
        }
        else{
            component.set("v.trackingStatus", "SHIPMENT TRACKING");
        }
        
        
    }
})