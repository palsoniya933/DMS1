/****
 *  Name        :   EDealerOrderDeliveredController
***/
public without sharing class EDealerOrderDeliveredController {
     @AuraEnabled
    public static  OrdersDeliveredResponseWrapper getDeliveredOrdersDetail(String dealerCode){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        OrdersDeliveredResponseWrapper awsResultData = new OrdersDeliveredResponseWrapper(); 
        calloutDetails.put('endpoint','/tms-delivered-order/kpi/'+dealerCode+'/dealer?');        
        calloutDetails.put('method','GET'); 
        calloutDetails.put('classname','EDealerOrderDeliveredController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails); 

       // parsing the actual results
        if(jsonRes != null){
            awsResultData = (OrdersDeliveredResponseWrapper)System.JSON.deserialize(jsonRes, OrdersDeliveredResponseWrapper.class);
        }
            
        //RETURN
        return awsResultData;
    }
    
     public class OrdersDeliveredResponseWrapper{
        @AuraEnabled public List<OrdersDeliveredWrapper> response;
        @AuraEnabled public String error;
    }
    public class OrdersDeliveredWrapper{
        @AuraEnabled public String LOCNO;
        @AuraEnabled public OrdersDeliveredTotalWrapper OrdersDeliveredTotal;
        @AuraEnabled public String STATUS; 
    }
    
    public class OrdersDeliveredTotalWrapper {
        @AuraEnabled public Integer dayCount;
        @AuraEnabled public Integer weekCount;
        @AuraEnabled public Integer monthCount;
        @AuraEnabled public Integer quarterCount;
        @AuraEnabled public Integer yearCount;
    }
    
    @AuraEnabled 
    public static OrdersDeliveredReportResponseWrapper getTMSDeliveredOrdersReportDetail(String dealerCode, String timeFrame){
        // creating map for API Call
        map<string,object> calloutDetails = new map<string,object>();
        OrdersDeliveredReportResponseWrapper awsResultData = new OrdersDeliveredReportResponseWrapper();        
        
        calloutDetails.put('endpoint','/tms-Delivered-orderdetails/report/'+dealerCode+'/dealer?Timeframe='+timeFrame.toUpperCase());        
        calloutDetails.put('method','GET'); 
        calloutDetails.put('classname','EDealerOrderDeliveredController');
        String jsonRes = EDealerHttpHandler.callout(calloutDetails);
        
        // parsing the actual results
        if(jsonRes != null){
           awsResultData = (OrdersDeliveredReportResponseWrapper)System.JSON.deserialize(jsonRes, OrdersDeliveredReportResponseWrapper.class);
        }
            
        if(awsResultData != null && awsResultData.response != null
          && awsResultData.response.OrdersDeliveredTotal != null && !awsResultData.response.OrdersDeliveredTotal.isEmpty()){
              for(OrdersDeliveredTotalReportWrapper resWrap : awsResultData.response.OrdersDeliveredTotal){
                  if(String.isNotEmpty(resWrap.EST_ARRIVAL_PST)){
                      resWrap.EST_ARRIVAL_SF_DT = Datetime.valueOf(resWrap.EST_ARRIVAL_PST);
                  }
                  
                  if(String.isNotEmpty(resWrap.DELIVERED_DATE_PST)){
                      resWrap.EST_DELIVERED_DATE_PST_DT = Datetime.valueOf(resWrap.DELIVERED_DATE_PST);
                  }
              }
              awsResultData.response.OrdersDeliveredTotal.sort();
        }
        
        //RETURN
        return awsResultData;
		
    }

    public class OrdersDeliveredReportResponseWrapper{
        @AuraEnabled public OrdersDeliveredReportWrapper response;
        @AuraEnabled public String error;
    }
    
    public class OrdersDeliveredReportWrapper{
        @AuraEnabled public String LOCNO;
        @AuraEnabled public String STATUS;
        @AuraEnabled public String CRITERIA;
        @AuraEnabled public List<OrdersDeliveredTotalReportWrapper> OrdersDeliveredTotal;
    }
    
    public class OrdersDeliveredTotalReportWrapper implements Comparable{
        @AuraEnabled public String PPD_ORDER;
        @AuraEnabled public String PRO_NUM;
        @AuraEnabled public String EST_ARRIVAL;
        @AuraEnabled public String EST_ARRIVAL_PST;
        @AuraEnabled public DateTime EST_ARRIVAL_SF_DT;
        @AuraEnabled public DateTime EST_DELIVERED_DATE_PST_DT;
        @AuraEnabled public String DELIVERED_DATE_PST;
        @AuraEnabled public String DELIVERED_DATE;
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            OrdersDeliveredTotalReportWrapper compareToObj = (OrdersDeliveredTotalReportWrapper)compareTo;
            if (PPD_ORDER == compareToObj.PPD_ORDER) return 0;
            if (PPD_ORDER < compareToObj.PPD_ORDER) return 1;
            return -1;        
        }
        
    }
}