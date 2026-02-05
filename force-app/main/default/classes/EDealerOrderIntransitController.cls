public class EDealerOrderIntransitController {
    
    @AuraEnabled 
    public static  OrdersIntransitResponseWrapper getIntransitOrdersDetail(String dealerCode){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        OrdersIntransitResponseWrapper awsResultData = new OrdersIntransitResponseWrapper();        
        
        calloutDetails.put('endpoint','/tms-intransit-order/kpi/'+dealerCode+'/dealer?');        
        calloutDetails.put('method','GET'); 
        calloutDetails.put('classname','EDealerOrderIntransitController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);

       // parsing the actual results
       if(jsonRes != null)
            awsResultData = (OrdersIntransitResponseWrapper)System.JSON.deserialize(jsonRes, OrdersIntransitResponseWrapper.class);
        
        //RETURN
        return awsResultData;
    }
    
     public class OrdersIntransitResponseWrapper{
        @AuraEnabled public List<OrdersIntransitWrapper> response;
        @AuraEnabled public String error;
    }
    public class OrdersIntransitWrapper{
        @AuraEnabled public String LOCNO;
        @AuraEnabled public OrdersIntransitTotalWrapper OrdersTransitTotal;
        @AuraEnabled public String STATUS;
    }
    
    public class OrdersIntransitTotalWrapper {
        @AuraEnabled public Integer dayCount;
        @AuraEnabled public Integer weekCount;
        @AuraEnabled public Integer monthCount;
        @AuraEnabled public Integer quarterCount;
        @AuraEnabled public Integer yearCount;
    }
    
    
    @AuraEnabled 
    public static OrdersInTransitReportResponseWrapper getTMSInTransitOrdersReportDetail(String dealerCode, String timeFrame){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        OrdersInTransitReportResponseWrapper awsResultData = new OrdersInTransitReportResponseWrapper();        
        
        calloutDetails.put('endpoint','/tms-transit-orderdetails/report/'+dealerCode+'/dealer?Timeframe='+timeFrame.toUpperCase());        
        calloutDetails.put('method','GET'); 
        calloutDetails.put('classname','EDealerOrderInTransitController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);   
        
        // parsing the actual results
       if(jsonRes != null)
            awsResultData = (OrdersInTransitReportResponseWrapper)System.JSON.deserialize(jsonRes, OrdersInTransitReportResponseWrapper.class);
        
        
        if(awsResultData != null && awsResultData.response != null && !awsResultData.response.isEmpty()
          && awsResultData.response[0].OrdersTransitTotal != null && !awsResultData.response[0].OrdersTransitTotal.isEmpty()){
              for(OrdersInTransitTotalReportWrapper resWrap : awsResultData.response[0].OrdersTransitTotal){
                  if(String.isNotEmpty(resWrap.EST_ARRIVAL_PST)){
                      resWrap.EST_ARRIVAL_SF_DT = Datetime.valueOf(resWrap.EST_ARRIVAL_PST);
                  }
                  
                  if(String.isNotEmpty(resWrap.PICKED_UP_DATE_PST)){
                      resWrap.EST_PICKED_UP_DATE_PST = Datetime.valueOf(resWrap.PICKED_UP_DATE_PST);
                  }
              }
              
              awsResultData.response[0].OrdersTransitTotal.sort();
        }
        
        //RETURN
        return awsResultData;
		
    }

    public class OrdersInTransitReportResponseWrapper{
        @AuraEnabled public List<OrdersInTransitReportWrapper> response;
        @AuraEnabled public String error;
    }
    
    public class OrdersInTransitReportWrapper{
        @AuraEnabled public String LOCNO;
        @AuraEnabled public String STATUS;
        @AuraEnabled public String CRITERIA;
        @AuraEnabled public List<OrdersInTransitTotalReportWrapper> OrdersTransitTotal;
    }
    
    public class OrdersInTransitTotalReportWrapper implements Comparable {
        @AuraEnabled public String PPD_ORDER;
        @AuraEnabled public String PRO_NUM;
        @AuraEnabled public String EST_ARRIVAL;
        @AuraEnabled public String EST_ARRIVAL_PST;
        @AuraEnabled public String PICKED_UP_DATE_PST;
        @AuraEnabled public DateTime EST_ARRIVAL_SF_DT;
        @AuraEnabled public DateTime EST_PICKED_UP_DATE_PST;
        @AuraEnabled public String PICKED_UP_DATE;
        
        // Implement the compareTo() method
    public Integer compareTo(Object compareTo) {
        OrdersInTransitTotalReportWrapper compareToObj = (OrdersInTransitTotalReportWrapper)compareTo;
        if (PPD_ORDER == compareToObj.PPD_ORDER) return 0;
        if (PPD_ORDER < compareToObj.PPD_ORDER) return 1;
        return -1;        
    }
    }

}