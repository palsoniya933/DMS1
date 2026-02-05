({
    doInitHelper : function(component, event, helper) {
        component.set("v.displayLoading", true);
        component.set("v.invData", undefined);
        component.set("v.totalOrderSelected", 0);
        helper.fetchAllSuggestedParts(component, event, helper);
        helper.generateReportColumns(component, event, helper);
    },
    
    
    generateReportColumns : function(component, event, helper){
        var currencyCode = component.get("v.currencyCode");
        component.set('v.columns', [
            {label: $A.get("$Label.c.Distribution_Channel"), fieldName: 'distributionChannel', type: 'text'},
            {label: $A.get("$Label.c.Suggested_Part"), fieldName: 'Part_Name', type: 'text'},
            {label: $A.get("$Label.c.Description"), fieldName: 'Part_Description', type: 'text'},
            {label: $A.get("$Label.c.Inventory"), fieldName: 'Dealer_Ineventory_Qty', type: 'text'},
            {label: $A.get("$Label.c.Suggested"), fieldName: 'Suggested_Qty', type: 'text'},
            {label: 'STK', fieldName: 'Stocking_list_Type', type: 'text'},
            {label: ($A.util.isEmpty(currencyCode) ? $A.get("$Label.c.PDC_price") : ($A.get("$Label.c.PDC_price")+' ('+currencyCode+')')), fieldName: 'pdcPricing', type: 'text'},
            {label: ($A.util.isEmpty(currencyCode) ? $A.get("$Label.c.DSP_price") : ($A.get("$Label.c.DSP_price")+' ('+currencyCode+')')), fieldName: 'dspPricing', type: 'text'},
            {label: $A.get("$Label.c.VEL_Code"), fieldName: 'velocity_code', type: 'text'},
            {label: 'SPQ', fieldName: 'spq', type: 'text'},
            {label: $A.get("$Label.c.Lead_Time"), fieldName: 'Lead_Time', type: 'text'},
            {label: $A.get("$Label.c.Specials"), fieldName: 'sofSpecials', type: 'text'},
            {label: $A.get("$Label.c.CNR_LIMIT_PER_DAY"), fieldName: 'sofSpecial_CNR', type: 'text'},
            {label: $A.get("$Label.c.RSV_Comment"), fieldName: 'sofSpecial_RSV_comment', type: 'text'},
            {label: $A.get("$Label.c.Comments"), fieldName: 'sof_comments', type: 'text'}
        ]);
    },
    
    
    fetchAllSuggestedParts : function(component, event, helper) {
        var locCode = component.get("v.dealerCode");
        
        //check selected  location/dealer code
        if($A.util.isUndefinedOrNull(locCode)){
            return;
        }
        
        var action = component.get("c.fetchDealerAllSuggestedPartsDetails");
        action.setParams({
            "dealerCode" : locCode,
            "isSpecialSOF" : component.get("v.isSpecialOrdersSOF")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.getReportDataFromPartsDetail(component, event, helper, response.getReturnValue());
                // component.set("v.invData", response.getReturnValue());
                // update sub-header details
                helper.callSubHeaderToUpdate(component, event, helper);
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
            //hide spinner
            component.set("v.displayLoading",false);
        });
        $A.enqueueAction(action);
    },
    
    getReportDataFromPartsDetail : function(component, event, helper, allPartsData) {
        if(!$A.util.isUndefinedOrNull(allPartsData) && allPartsData.length > 0){
            for(var i=0;i<allPartsData.length;i++){
                if(!$A.util.isUndefinedOrNull(allPartsData[i].PriceDetail)){
                    //get est price for pdc/dsp/dual/ENG
                    if(allPartsData[i].Part_category_Type == 'DSP'){
                        allPartsData[i].dspPricing = allPartsData[i].PriceDetail.DspFinalNet;
                        allPartsData[i].distributionChannel = 'DSP PARTS';
                    }else if(allPartsData[i].Part_category_Type == 'PDC'){
                        allPartsData[i].pdcPricing = allPartsData[i].PriceDetail.WhsFinalNet;
                        allPartsData[i].distributionChannel = 'PDC PARTS';
                    }else if(allPartsData[i].Part_category_Type == 'DUAL'){
                        allPartsData[i].pdcPricing = allPartsData[i].PriceDetail.WhsFinalNet;
                        allPartsData[i].dspPricing = allPartsData[i].PriceDetail.DspFinalNet;
                        allPartsData[i].distributionChannel = 'DUAL PARTS';
                    }else if(allPartsData[i].Part_category_Type == 'ENG'){
                        allPartsData[i].distributionChannel = 'NON-PACCAR PARTS';
                    }
                    
                    //get specials
                    if(allPartsData[i].Part_category_Type != 'ENG'){
                        var specialsList = [];
                        //Quantity Breakdown Options
                        if((!$A.util.isUndefinedOrNull(allPartsData[i].PriceDetail.WhsQtyBreak)
                            && (
                                (allPartsData[i].PriceDetail.WhsQtyBreak.length > 0 && allPartsData[i].PriceDetail.WhsQtyBreak.length != 1)
                                || (allPartsData[i].PriceDetail.WhsQtyBreak.length == 1 && allPartsData[i].PriceDetail.WhsQtyBreak[0].QtyDiscPerc > 0)
                            ))
                           || (!$A.util.isUndefinedOrNull(allPartsData[i].PriceDetail.DspQtyBreak)
                               &&(
                                   (allPartsData[i].PriceDetail.DspQtyBreak.length > 0 && allPartsData[i].PriceDetail.DspQtyBreak.length != 1)
                                   || (allPartsData[i].PriceDetail.DspQtyBreak.length == 1 && allPartsData[i].PriceDetail.DspQtyBreak[0].QtyDiscPerc > 0)
                               ))
                          ){
                            specialsList.push('Q');
                        }
                        
                        //PDC Discounts (Promos)
                        if(!$A.util.isEmpty(allPartsData[i].PriceDetail.WqtypromoCode)){
                            specialsList.push('W');
                        }
                        //DSP Discounts (Promos)
                        if(!$A.util.isEmpty(allPartsData[i].PriceDetail.DqtypromoCode)){
                            specialsList.push('D');
                        }
                        //CSR
                        if(!$A.util.isEmpty(allPartsData[i].PriceDetail.DspCsr)
                           || !$A.util.isEmpty(allPartsData[i].PriceDetail.WhsCsr)){
                            specialsList.push('CSR');
                        }
                        //CNR
                        if(allPartsData[i].PriceDetail.Saleableindicator == 'CNR'){
                            specialsList.push('CNR');
                            allPartsData[i].sofSpecial_CNR = allPartsData[i].PriceDetail.dealer_quantity_per_day;
                        }
                        //RSV
                        if(allPartsData[i].PriceDetail.Saleableindicator == 'RSV' ){
                            specialsList.push('RSV');
                            allPartsData[i].sofSpecial_RSV_comment = allPartsData[i].PriceDetail.RSV_Comment;
                        }
                        
                        allPartsData[i].sofSpecials = specialsList.join();
                    }
                }
            }
        }
        
        component.set("v.invData", allPartsData);
    },
    
    
    callSubHeaderToUpdate : function(component, event, helper) {
        var SubHeaderComp = component.find('SubHeaderComp');
        SubHeaderComp.callChild();
    },
    
    
    getAllPartsReportName : function(component, event, helper) {
        var sofInfo = component.get("v.sofInfo");
        if(!$A.util.isUndefinedOrNull(sofInfo) && !$A.util.isUndefinedOrNull(sofInfo.sofCreatedDate)){
            var sofCreatedDate = sofInfo.sofCreatedDate.replace("Z", "+00:00");
            var d = new Date(sofCreatedDate);
            
            sofCreatedDate = d.toLocaleString('en-US', { timeZone: 'America/Los_Angeles' });
            sofCreatedDate = sofCreatedDate.replace(",", "");
            var splitStrList = sofCreatedDate.split(" ");
            var dateSplitList = splitStrList[0].split("/");//1/24/2022, 1:10:41 PM
            var timeSplitList = splitStrList[1].split(":");
            timeSplitList[0] = (splitStrList[2] == 'PM' ? (parseInt(timeSplitList[0]) + 12) :  timeSplitList[0]);
            var isSpecialOrdersSOF= component.get("v.isSpecialOrdersSOF");
            var labelSugOrder = $A.get("$Label.c.Suggested_Orders");
            var labelSugPromo = $A.get("$Label.c.Suggested_Promo");
            var sofReport = isSpecialOrdersSOF ? labelSugPromo :labelSugOrder;
            sofReport = sofReport + ' ' + dateSplitList[0]+'-'+dateSplitList[1]+'-'+dateSplitList[2]+' '+timeSplitList[0]+'.'+timeSplitList[1]+'.'+timeSplitList[2];
            component.set("v.allPartsReportName", sofReport);
        }
    },
    
    
    showErrorToast : function(component, event, helper, ErrorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "message": ErrorMessage,
            "type": "error"
        });
        toastEvent.fire();
    },
    
})