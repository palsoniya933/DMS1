public class EDealerDelieveryMetricsController {
    
    @AuraEnabled 
    public static  DelieveryMetricsResponseWrapper getDelieveryMetricsDetail(String dealerCode){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        DelieveryMetricsResponseWrapper awsResultData = new DelieveryMetricsResponseWrapper();        
        
        calloutDetails.put('endpoint','/tms-delievery-metrics/kpi/'+dealerCode+'/dealer?');        
        calloutDetails.put('method','GET'); 
        calloutDetails.put('classname','EDealerDelieveryMetricsController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);  

       // parsing the actual results
       if(jsonRes != null)
            awsResultData = (DelieveryMetricsResponseWrapper)System.JSON.deserialize(jsonRes, DelieveryMetricsResponseWrapper.class);
        
        
        //RETURN
        return awsResultData;
    }
    
     public class DelieveryMetricsResponseWrapper{
        @AuraEnabled public List<DelieveryMetricsWrapper> response;
        @AuraEnabled public String error;
    }
    public class DelieveryMetricsWrapper{
        @AuraEnabled public String LOCNO;
        @AuraEnabled public List<DelieveryMetricsTotalWrapper> DeliveredMetrics;
    }
    
    public class DelieveryMetricsTotalWrapper {
        @AuraEnabled public List<String> delayOrders;
        @AuraEnabled public List<String> onTimeOrders;
        @AuraEnabled public Double dayDelay;
        @AuraEnabled public Double dayOntime;
        @AuraEnabled public Double weekDelay;
        @AuraEnabled public Double weekOntime;
        @AuraEnabled public Double monthDelay;
        @AuraEnabled public Double monthOntime;
        @AuraEnabled public Double quarterDelay;
        @AuraEnabled public Double quarterOntime;
        @AuraEnabled public Double yearDelay;
        @AuraEnabled public Double yearOntime;
    }

    
    @AuraEnabled 
    public static OrdersDeliveredMetricsReportResponseWrapper getTMSDelieveryMetricsOrdersReportDetail(String dealerCode, String timeFrame){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        OrdersDeliveredMetricsReportResponseWrapper awsResultData = new OrdersDeliveredMetricsReportResponseWrapper();        
        
        calloutDetails.put('endpoint','/tms-deliveryMetrics-orderdetails/report/'+dealerCode+'/dealer?Timeframe='+timeFrame.toUpperCase());        
        calloutDetails.put('method','GET'); 
        calloutDetails.put('classname','EDealerDelieveryMetricsController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        // parsing the actual results
       if(jsonRes != null)
            awsResultData = (OrdersDeliveredMetricsReportResponseWrapper)System.JSON.deserialize(jsonRes, OrdersDeliveredMetricsReportResponseWrapper.class);
                
        
        if(awsResultData != null && awsResultData.response != null && !awsResultData.response.isEmpty()
          && awsResultData.response[0].DeliveredMetrics != null){
              if(awsResultData.response[0].DeliveredMetrics.delayOrders != null && !awsResultData.response[0].DeliveredMetrics.delayOrders.isEmpty()){
                  for(OrdersDeliveredMetricsTotalReportWrapper resWrap : awsResultData.response[0].DeliveredMetrics.delayOrders){
                      if(String.isNotEmpty(resWrap.EST_ARRIVAL_PST)){
                          resWrap.EST_ARRIVAL_SF_DT = Datetime.valueOf(resWrap.EST_ARRIVAL_PST);
                      }
                      if(String.isNotEmpty(resWrap.DELIVERED_DATE_PST)){
                          resWrap.DELIVERED_DATE_SF_DT = Datetime.valueOf(resWrap.DELIVERED_DATE_PST);
                      }
                  }
              }
              if(awsResultData.response[0].DeliveredMetrics.onTimeOrders != null && !awsResultData.response[0].DeliveredMetrics.onTimeOrders.isEmpty()){
                  for(OrdersDeliveredMetricsTotalReportWrapper resWrap : awsResultData.response[0].DeliveredMetrics.onTimeOrders){
                      if(String.isNotEmpty(resWrap.EST_ARRIVAL_PST)){
                          resWrap.EST_ARRIVAL_SF_DT = Datetime.valueOf(resWrap.EST_ARRIVAL_PST);
                      }
                      if(String.isNotEmpty(resWrap.DELIVERED_DATE_PST)){
                          resWrap.DELIVERED_DATE_SF_DT = Datetime.valueOf(resWrap.DELIVERED_DATE_PST);
                      }
                  }
              }
              
        }
        
        
        //RETURN
        return awsResultData;
		
    }
    
    public class OrdersDeliveredMetricsReportResponseWrapper{
        @AuraEnabled public List<OrdersDeliveredMetricsReportWrapper> response;
        @AuraEnabled public String error;
    }
    
    public class OrdersDeliveredMetricsReportWrapper{
        @AuraEnabled public String LOCNO;
        @AuraEnabled public String CRITERIA;
        @AuraEnabled public OrdersDelayOnTimeWrapper DeliveredMetrics;
    }
    
    public class OrdersDelayOnTimeWrapper {
        @AuraEnabled public List<OrdersDeliveredMetricsTotalReportWrapper> delayOrders;
        @AuraEnabled public List<OrdersDeliveredMetricsTotalReportWrapper> onTimeOrders;
    }
    
    public class OrdersDeliveredMetricsTotalReportWrapper {
        @AuraEnabled public String PPD_ORDER;
        @AuraEnabled public String PRO_NUM;
        @AuraEnabled public String EST_ARRIVAL;
        @AuraEnabled public String DELIVERED_DATE;
        @AuraEnabled public String EST_ARRIVAL_PST;
        @AuraEnabled public DateTime EST_ARRIVAL_SF_DT;
        @AuraEnabled public String DELIVERED_DATE_PST;
        @AuraEnabled public DateTime DELIVERED_DATE_SF_DT;
    }

}