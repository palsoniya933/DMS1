@isTest
public class EDealerMSL_CSL_RSL_cntrlTest {
    @isTest
    private static void validateFetchAWSMSL_CSL_RSLReport(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"dealer_code":"A875","part_number":"4309439CUM","program":"CUMMINS_500_CSL","type":"CSL","initialdate":"2021-03-31 00:00:00","enddate":"2022-03-31 00:00:00","minss":1,"oh":1.0,"abc":"E","dlrsplrcode":"00001","dlrnet":"642.93","inventory":643,"p_12monthhitcount":0,"twelve_month_demand_qty":0,"manual_parameter":0,"sunset_date":"2022-03-31"},{"dealer_code":"A875","part_number":"5579293RXCUM","program":"CUMMINS_500_CSL","type":"CSL","initialdate":"2021-03-31 00:00:00","enddate":"2022-03-31 00:00:00","minss":1,"oh":1.0,"abc":"E","dlrsplrcode":"00001","dlrnet":"1089.34","inventory":1089,"p_12monthhitcount":1,"twelve_month_demand_qty":1,"manual_parameter":0,"sunset_date":"2022-03-31"},{"dealer_code":"A875","part_number":"4299124CUM","program":"CUMMINS_500_CSL","type":"CSL","initialdate":"2021-03-31 00:00:00","enddate":"2022-03-31 00:00:00","minss":1,"oh":9.0,"abc":"A","dlrsplrcode":"00001","dlrnet":"8.22","inventory":74,"p_12monthhitcount":54,"twelve_month_demand_qty":58,"manual_parameter":0,"sunset_date":"2022-03-31"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerMSL_CSL_RSL_cntrl.CSLRSLReportWrapper obj = new EDealerMSL_CSL_RSL_cntrl.CSLRSLReportWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        
        // calling apex class method
        EDealerMSL_CSL_RSL_cntrl.fetchAWSMSL_CSL_RSLReport(strObj);
    }
    
    @isTest
    private static void validateFetchAWSMSL_CSL_RSLReport1(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"dealer_code":"A875","part_number":"4309439CUM","program":"CUMMINS_500_CSL","type":"CSL","initialdate":"2021-03-31 00:00:00","enddate":"2022-03-31 00:00:00","minss":1,"oh":1.0,"abc":"E","dlrsplrcode":"00001","dlrnet":"642.93","inventory":643,"p_12monthhitcount":0,"twelve_month_demand_qty":0,"manual_parameter":0,"sunset_date":"2022-03-31"},{"dealer_code":"A875","part_number":"5579293RXCUM","program":"CUMMINS_500_CSL","type":"CSL","initialdate":"2021-03-31 00:00:00","enddate":"2022-03-31 00:00:00","minss":1,"oh":1.0,"abc":"E","dlrsplrcode":"00001","dlrnet":"1089.34","inventory":1089,"p_12monthhitcount":1,"twelve_month_demand_qty":1,"manual_parameter":0,"sunset_date":"2022-03-31"},{"dealer_code":"A875","part_number":"4299124CUM","program":"CUMMINS_500_CSL","type":"CSL","initialdate":"2021-03-31 00:00:00","enddate":"2022-03-31 00:00:00","minss":1,"oh":9.0,"abc":"A","dlrsplrcode":"00001","dlrnet":"8.22","inventory":74,"p_12monthhitcount":54,"twelve_month_demand_qty":58,"manual_parameter":0,"sunset_date":"2022-03-31"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerMSL_CSL_RSL_cntrl.CSLRSLReportWrapper obj = new EDealerMSL_CSL_RSL_cntrl.CSLRSLReportWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        
        // calling apex class method
        EDealerMSL_CSL_RSL_cntrl.fetchAWSMSL_CSL_RSLReport(strObj);
        
    }
    
    @isTest
    private static void validateFetchAWSMSL_CSL_RSLReport2(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        List<String> lstDealerCode=new List<String>();        
        lstDealerCode.add('I080');
        
        EDealerMSL_CSL_RSL_cntrl.CSLRSLReportWrapper obj = new EDealerMSL_CSL_RSL_cntrl.CSLRSLReportWrapper();
        
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        obj.field='ITEM';
        obj.operator='equal to';
        obj.value='M015376';
        string strObj = JSON.serialize(obj);
        
        // calling apex class method
        try{
            EDealerMSL_CSL_RSL_cntrl.fetchAWSMSL_CSL_RSLReport(strObj); 
        }
       catch(Exception ex){
           system.debug('Line Number::'+ex.getMessage());
       }
        Test.stopTest();
    }
}