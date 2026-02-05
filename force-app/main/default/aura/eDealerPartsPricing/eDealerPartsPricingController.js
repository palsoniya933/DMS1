({
    doInit : function(component, event, helper) {
       /* // for each row seq quantity
        var allPrice = component.get("v.pricingInfo");
        
        if(!$A.util.isUndefinedOrNull(allPrice) 
           && !$A.util.isUndefinedOrNull(allPrice.PriceDetail)){
            if(!$A.util.isUndefinedOrNull(allPrice.PriceDetail.WhsQtyBreak)){
                for(var ele in allPrice.PriceDetail.WhsQtyBreak){
                    // set default quanity
                    allPrice.PriceDetail.WhsQtyBreak[ele].quant = 1;		            
                    allPrice.PriceDetail.WhsQtyBreak[ele].disAmount = 0;
                    // calc the discount price
                    if(allPrice.PriceDetail.WhsQtyBreak[ele].QtyDiscPerc){
                        var discount = (allPrice.PriceDetail.WhsQtyBreak[ele].QtyPrice * allPrice.PriceDetail.WhsQtyBreak[ele].QtyDiscPerc) / 100;
                        var disAmount = allPrice.PriceDetail.WhsQtyBreak[ele].QtyPrice - discount;
                        allPrice.PriceDetail.WhsQtyBreak[ele].disAmount = disAmount;
                    }
                }
            }
            
            if(!$A.util.isUndefinedOrNull(allPrice.PriceDetail.DspQtyBreak)){
                for(var ele in allPrice.PriceDetail.DspQtyBreak){
                    
                    // set default quanity
                    allPrice.PriceDetail.DspQtyBreak[ele].quant = 1;		            
                    allPrice.PriceDetail.DspQtyBreak[ele].disAmount = 0;
                    // calc the discount price
                    if(allPrice.PriceDetail.DspQtyBreak[ele].QtyDiscPerc){
                        var discount = (allPrice.PriceDetail.DspQtyBreak[ele].QtyPrice * allPrice.PriceDetail.DspQtyBreak[ele].QtyDiscPerc) / 100;
                        var disAmount = allPrice.PriceDetail.DspQtyBreak[ele].QtyPrice - discount;
                        allPrice.PriceDetail.DspQtyBreak[ele].disAmount = disAmount;
                    }
                }
            }
            
        }
               
        
        component.set("v.pricingInfo",allPrice);*/
    }
})