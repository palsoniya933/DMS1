public class EDealerOrderListingController {  
    
    @AuraEnabled
    public static EDealerConfirmedListing.ResponseWrapper getConfirmedOrders(List<String> dealerCode, String orderType, String timeFrame,Integer offset_value,Integer reclimit){
      return EDealerConfirmedListing.confirmOrdersData(dealerCode, orderType, timeFrame,offset_value,reclimit);
    }
    
    @AuraEnabled
    public static EDealerPendingListing.ResponseWrapper getPendingOrders(List<String> dealerCode, String orderType, String timeFrame,Integer offset_value,Integer reclimit){
        return EDealerPendingListing.fetchListingData(dealerCode, orderType,timeFrame,offset_value,reclimit);
    }
    
    @AuraEnabled
    public static EDealerActiveListing.ResponseWrapper getActiveOrders(List<String> dealerCode, String orderType,String timeFrame,Integer offset_value,Integer reclimit){
      return EDealerActiveListing.fetchListingData(dealerCode, orderType, timeFrame,offset_value,reclimit); 
    }
    
    @AuraEnabled
    public static EDealerUnconfirmedListing.ResponseWrapper getUnConfirmedOrders(List<String> dealerCode, String orderType,String timeFrame,Integer offset_value,Integer reclimit){
        return EDealerUnconfirmedListing.unConfirmOrdersListingData(dealerCode, orderType,timeFrame,offset_value,reclimit); 
    }
    
    @AuraEnabled
    public static EDealerOrderIntransitController.OrdersInTransitReportResponseWrapper getInTransitOrders(String dealerCode, String frequency){
        return EDealerOrderIntransitController.getTMSInTransitOrdersReportDetail(dealerCode, frequency); 
    }
    
    @AuraEnabled
    public static EDealerOrderDeliveredController.OrdersDeliveredReportResponseWrapper getDeleveredOrders(String dealerCode, String frequency){
        return EDealerOrderDeliveredController.getTMSDeliveredOrdersReportDetail(dealerCode, frequency); 
    }
    
    @AuraEnabled
    public static EDealerDelieveryMetricsController.OrdersDeliveredMetricsReportResponseWrapper getDelieveryMetricsOrders(String dealerCode, String frequency){
        return EDealerDelieveryMetricsController.getTMSDelieveryMetricsOrdersReportDetail(dealerCode, frequency); 
    }
    
    @AuraEnabled
    public static EDealerManualLockdownController.ManualLockDownListingResponseWrapper getManualLockdownOrders(List<String> dealerCodes){
        return EDealerManualLockdownController.manualLockdownListingApi(dealerCodes); 
    }
    
   @AuraEnabled
    public static EDealerReturnComplianceListingCtrl.ReturnsComplianceResponseWrapper getReturnComplianceData(List<String> dealerCode, String division, String month, String quarter, 
                                                                                                   String year, Integer offSet, Integer recLimit, Date monthDate, Date quarterDate){
                                                                                                   
        return EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(dealerCode, division, month, quarter, year, offSet, recLimit, monthDate, quarterDate); 
    }
     @AuraEnabled
    public static Map<String,Object> getColumnHeaders(String reportName){
        return EDealerMetadataUtility.translateColumnHeadersVersion2(reportName);
    }
    
      @AuraEnabled
    public static List<Map<String, String>> getFrequencyTranslations(){
        return eDealerDashboard.getFrequency();
    }

    
}