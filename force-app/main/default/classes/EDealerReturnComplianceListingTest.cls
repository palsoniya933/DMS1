@isTest
public class EDealerReturnComplianceListingTest {
    @isTest
    private static void testfetchAWSReturns(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"grp_num":"I080","dlrcode":"I080","rmatype":"RM","po_number":"MDISTKRETURN-Aug2021","item":"03-08712","suggested_date":"2021-08-10","suggested_qty":1,"suggested_extnet":"109.97","returned_date":"2021-10-06","returned_qty":"1.00000","returned_extnet":"109.97","avg_return_compliance":"100.00","order_status":"INVOICED","return_status":"RETURN ACCEPTED"},{"grp_num":"I080","dlrcode":"I080","rmatype":"RM","po_number":"MDISTKRETURN-Aug2021","item":"10537417","suggested_date":"2021-08-10","suggested_qty":1,"suggested_extnet":"66.56","returned_date":null,"returned_qty":null,"returned_extnet":null,"avg_return_compliance":null,"order_status":"SUGGESTED","return_status":"No Return"}],"RowCount":2}');
        // setting mock apex class
        
        HttpResponse mockResponse1 = new HttpResponse();
        mockResponse1.setStatus('OK');
        mockResponse1.setStatusCode(200); 
        mockResponse1.setHeader('Content-Type', 'application/json');
        mockResponse1.setBody('{"response":{"previous_year_data":[{"dealer_code":"I080","suggested_year":"2020","suggested_returns":1583,"sum_suggested_returns":"131642.61","returned_quantity":345,"sum_return_amount":"33312.05","suggested_compliance":"21.79"}],"quarter_data":[{"dealer_code":"I080","suggested_quarter_create_date":"2021-07-01","suggested_year":2021,"suggested_quarter":7,"suggested_returns":210,"sum_suggested_returns":"22531.80","returned_quantity":79,"sum_return_amount":"12681.82","suggested_compliance":"37.62","suggested_items_percentage_change":"-55.900","suggested_items_amount_percentage_change":"-27.200","return_items_percentage_change":"-69.500","return_items_amount_percentage_change":"-25.800","compliance_percentage_change":"-30.900"},{"dealer_code":"I080","suggested_quarter_create_date":"2021-04-01","suggested_year":2021,"suggested_quarter":4,"suggested_returns":476,"sum_suggested_returns":"30932.29","returned_quantity":259,"sum_return_amount":"17084.50","suggested_compliance":"54.41","suggested_items_percentage_change":"-9.300","suggested_items_amount_percentage_change":"-45.100","return_items_percentage_change":"10.700","return_items_amount_percentage_change":"-56.800","compliance_percentage_change":"22.100"},{"dealer_code":"I080","suggested_quarter_create_date":"2021-01-01","suggested_year":2021,"suggested_quarter":1,"suggested_returns":525,"sum_suggested_returns":"56361.81","returned_quantity":234,"sum_return_amount":"39534.83","suggested_compliance":"44.57","suggested_items_percentage_change":"105.900","suggested_items_amount_percentage_change":"131.400","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_quarter_create_date":"2020-10-01","suggested_year":2020,"suggested_quarter":10,"suggested_returns":255,"sum_suggested_returns":"24355.57","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"0.000","suggested_items_amount_percentage_change":"0.000","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"}],"month_data":[{"dealer_code":"I080","suggested_month_create_date":"2021-08-01","suggested_year":2021,"suggested_month":8,"suggested_returns":210,"sum_suggested_returns":"22531.80","returned_quantity":79,"sum_return_amount":"12681.82","suggested_compliance":"37.62","suggested_items_percentage_change":"1.400","suggested_items_amount_percentage_change":"90.700","return_items_percentage_change":"-24.800","return_items_amount_percentage_change":"72.600","compliance_percentage_change":"-25.800"},{"dealer_code":"I080","suggested_month_create_date":"2021-06-01","suggested_year":2021,"suggested_month":6,"suggested_returns":207,"sum_suggested_returns":"11818.04","returned_quantity":105,"sum_return_amount":"7346.01","suggested_compliance":"50.72","suggested_items_percentage_change":"-23.000","suggested_items_amount_percentage_change":"-38.200","return_items_percentage_change":"-31.800","return_items_amount_percentage_change":"-24.600","compliance_percentage_change":"-11.400"},{"dealer_code":"I080","suggested_month_create_date":"2021-05-01","suggested_year":2021,"suggested_month":5,"suggested_returns":269,"sum_suggested_returns":"19114.25","returned_quantity":154,"sum_return_amount":"9738.49","suggested_compliance":"57.25","suggested_items_percentage_change":"-14.300","suggested_items_amount_percentage_change":"-43.200","return_items_percentage_change":"-6.100","return_items_amount_percentage_change":"-62.800","compliance_percentage_change":"9.600"},{"dealer_code":"I080","suggested_month_create_date":"2021-03-01","suggested_year":2021,"suggested_month":3,"suggested_returns":314,"sum_suggested_returns":"33681.48","returned_quantity":164,"sum_return_amount":"26211.60","suggested_compliance":"52.23","suggested_items_percentage_change":"48.800","suggested_items_amount_percentage_change":"48.500","return_items_percentage_change":"134.300","return_items_amount_percentage_change":"96.700","compliance_percentage_change":"57.400"},{"dealer_code":"I080","suggested_month_create_date":"2021-02-01","suggested_year":2021,"suggested_month":2,"suggested_returns":211,"sum_suggested_returns":"22680.33","returned_quantity":70,"sum_return_amount":"13323.23","suggested_compliance":"33.18","suggested_items_percentage_change":"-17.300","suggested_items_amount_percentage_change":"-6.900","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_month_create_date":"2020-11-01","suggested_year":2020,"suggested_month":11,"suggested_returns":255,"sum_suggested_returns":"24355.57","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"11.800","suggested_items_amount_percentage_change":"-0.700","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_month_create_date":"2020-09-01","suggested_year":2020,"suggested_month":9,"suggested_returns":228,"sum_suggested_returns":"24517.16","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"0.000","suggested_items_amount_percentage_change":"0.000","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"}]}}}');
        EDealerHTTPMockResponseTest returnComplianceListingContr = new EDealerHTTPMockResponseTest(mockResponse);
        EDealerHTTPMockResponseTest returnComplianceContr = new EDealerHTTPMockResponseTest(mockResponse1);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:AWS_EDealer'+'/return-compliance-report/dealer',returnComplianceListingContr);
        endpoint2TestResp.put('callout:AWS_EDealer'+'/return-compliance-kpi/dealers',returnComplianceContr);
        EdealerHttpCalloutServiceMultiMockTest multiCalloutMock = new EdealerHttpCalloutServiceMultiMockTest(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.startTest();
        // calling apex class method
        list<string> listDealerCode = new list<string>();
        listDealerCode.add('I080');
         
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','oct 2021','q4 2021','2020',4,2000,system.today(),system.today().addDays(3));        
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','jan 2021','q1 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','feb 2021','q1 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','mar 2021','q1 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','apr 2021','q2 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','may 2021','q2 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','jun 2021','q2 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','jul 2021','q3 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','aug 2021','q3 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','sep 2021','q4 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','nov 2021','q4 2021','2020',4,2000,system.today(),system.today().addDays(3));
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k','dec 2021','q4 2021','2020',4,2000,system.today(),system.today().addDays(3));
        Test.stopTest();    
        
    }
    
    @isTest
    private static void testfetchAWSReturnsMonthNull(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"grp_num":"I080","dlrcode":"I080","rmatype":"RM","po_number":"MDISTKRETURN-Aug2021","item":"03-08712","suggested_date":"2021-08-10","suggested_qty":1,"suggested_extnet":"109.97","returned_date":"2021-10-06","returned_qty":"1.00000","returned_extnet":"109.97","avg_return_compliance":"100.00","order_status":"INVOICED","return_status":"RETURN ACCEPTED"},{"grp_num":"I080","dlrcode":"I080","rmatype":"RM","po_number":"MDISTKRETURN-Aug2021","item":"10537417","suggested_date":"2021-08-10","suggested_qty":1,"suggested_extnet":"66.56","returned_date":null,"returned_qty":null,"returned_extnet":null,"avg_return_compliance":null,"order_status":"SUGGESTED","return_status":"No Return"}],"RowCount":2}');
        // setting mock apex class
        
        HttpResponse mockResponse1 = new HttpResponse();
        mockResponse1.setStatus('OK');
        mockResponse1.setStatusCode(200); 
        mockResponse1.setHeader('Content-Type', 'application/json');
        mockResponse1.setBody('{"response":{"year_data":[{"dealer_code":"I080","suggested_year":"2020","suggested_returns":1583,"sum_suggested_returns":"131642.61","returned_quantity":345,"sum_return_amount":"33312.05","suggested_compliance":"21.79"}],"quarter_data":[{"dealer_code":"I080","suggested_quarter_create_date":"2021-07-01","suggested_year":2021,"suggested_quarter":7,"suggested_returns":210,"sum_suggested_returns":"22531.80","returned_quantity":79,"sum_return_amount":"12681.82","suggested_compliance":"37.62","suggested_items_percentage_change":"-55.900","suggested_items_amount_percentage_change":"-27.200","return_items_percentage_change":"-69.500","return_items_amount_percentage_change":"-25.800","compliance_percentage_change":"-30.900"},{"dealer_code":"I080","suggested_quarter_create_date":"2021-04-01","suggested_year":2021,"suggested_quarter":4,"suggested_returns":476,"sum_suggested_returns":"30932.29","returned_quantity":259,"sum_return_amount":"17084.50","suggested_compliance":"54.41","suggested_items_percentage_change":"-9.300","suggested_items_amount_percentage_change":"-45.100","return_items_percentage_change":"10.700","return_items_amount_percentage_change":"-56.800","compliance_percentage_change":"22.100"},{"dealer_code":"I080","suggested_quarter_create_date":"2021-01-01","suggested_year":2021,"suggested_quarter":1,"suggested_returns":525,"sum_suggested_returns":"56361.81","returned_quantity":234,"sum_return_amount":"39534.83","suggested_compliance":"44.57","suggested_items_percentage_change":"105.900","suggested_items_amount_percentage_change":"131.400","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_quarter_create_date":"2020-10-01","suggested_year":2020,"suggested_quarter":10,"suggested_returns":255,"sum_suggested_returns":"24355.57","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"0.000","suggested_items_amount_percentage_change":"0.000","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"}],"month_data":[{"dealer_code":"I080","suggested_month_create_date":"2021-08-01","suggested_year":2021,"suggested_month":8,"suggested_returns":210,"sum_suggested_returns":"22531.80","returned_quantity":79,"sum_return_amount":"12681.82","suggested_compliance":"37.62","suggested_items_percentage_change":"1.400","suggested_items_amount_percentage_change":"90.700","return_items_percentage_change":"-24.800","return_items_amount_percentage_change":"72.600","compliance_percentage_change":"-25.800"},{"dealer_code":"I080","suggested_month_create_date":"2021-06-01","suggested_year":2021,"suggested_month":6,"suggested_returns":207,"sum_suggested_returns":"11818.04","returned_quantity":105,"sum_return_amount":"7346.01","suggested_compliance":"50.72","suggested_items_percentage_change":"-23.000","suggested_items_amount_percentage_change":"-38.200","return_items_percentage_change":"-31.800","return_items_amount_percentage_change":"-24.600","compliance_percentage_change":"-11.400"},{"dealer_code":"I080","suggested_month_create_date":"2021-05-01","suggested_year":2021,"suggested_month":5,"suggested_returns":269,"sum_suggested_returns":"19114.25","returned_quantity":154,"sum_return_amount":"9738.49","suggested_compliance":"57.25","suggested_items_percentage_change":"-14.300","suggested_items_amount_percentage_change":"-43.200","return_items_percentage_change":"-6.100","return_items_amount_percentage_change":"-62.800","compliance_percentage_change":"9.600"},{"dealer_code":"I080","suggested_month_create_date":"2021-03-01","suggested_year":2021,"suggested_month":3,"suggested_returns":314,"sum_suggested_returns":"33681.48","returned_quantity":164,"sum_return_amount":"26211.60","suggested_compliance":"52.23","suggested_items_percentage_change":"48.800","suggested_items_amount_percentage_change":"48.500","return_items_percentage_change":"134.300","return_items_amount_percentage_change":"96.700","compliance_percentage_change":"57.400"},{"dealer_code":"I080","suggested_month_create_date":"2021-02-01","suggested_year":2021,"suggested_month":2,"suggested_returns":211,"sum_suggested_returns":"22680.33","returned_quantity":70,"sum_return_amount":"13323.23","suggested_compliance":"33.18","suggested_items_percentage_change":"-17.300","suggested_items_amount_percentage_change":"-6.900","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_month_create_date":"2020-11-01","suggested_year":2020,"suggested_month":11,"suggested_returns":255,"sum_suggested_returns":"24355.57","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"11.800","suggested_items_amount_percentage_change":"-0.700","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_month_create_date":"2020-09-01","suggested_year":2020,"suggested_month":9,"suggested_returns":228,"sum_suggested_returns":"24517.16","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"0.000","suggested_items_amount_percentage_change":"0.000","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"}]}}}');
        EDealerHTTPMockResponseTest returnComplianceListingContr = new EDealerHTTPMockResponseTest(mockResponse);
        EDealerHTTPMockResponseTest returnComplianceContr = new EDealerHTTPMockResponseTest(mockResponse1);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:AWS_EDealer'+'/return-compliance-report/dealer',returnComplianceListingContr);
        endpoint2TestResp.put('callout:AWS_EDealer'+'/return-compliance-kpi/dealers',returnComplianceContr);
        EdealerHttpCalloutServiceMultiMockTest multiCalloutMock = new EdealerHttpCalloutServiceMultiMockTest(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.startTest();
        // calling apex class method
        list<string> listDealerCode = new list<string>();
        listDealerCode.add('I080');
        
        EDealerReturnComplianceListingCtrl.ReturnsComplianceResponseWrapper resWrrap = EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k',null,'q4 2021','2021',4,2000,system.today(),system.today().addDays(3));
        system.assertEquals('I080', resWrrap.response[0].dlrcode);
        Test.stopTest();    
        
    }
    
    @isTest
    private static void testfetchAWSReturnsQuarterNull(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response":[{"grp_num":"I080","dlrcode":"I080","rmatype":"RM","po_number":"MDISTKRETURN-Aug2021","item":"03-08712","suggested_date":"2021-08-10","suggested_qty":1,"suggested_extnet":"109.97","returned_date":"2021-10-06","returned_qty":"1.00000","returned_extnet":"109.97","avg_return_compliance":"100.00","order_status":"INVOICED","return_status":"RETURN ACCEPTED"},{"grp_num":"I080","dlrcode":"I080","rmatype":"RM","po_number":"MDISTKRETURN-Aug2021","item":"10537417","suggested_date":"2021-08-10","suggested_qty":1,"suggested_extnet":"66.56","returned_date":null,"returned_qty":null,"returned_extnet":null,"avg_return_compliance":null,"order_status":"SUGGESTED","return_status":"No Return"}],"RowCount":2}');
        // setting mock apex class
        
        HttpResponse mockResponse1 = new HttpResponse();
        mockResponse1.setStatus('OK');
        mockResponse1.setStatusCode(200); 
        mockResponse1.setHeader('Content-Type', 'application/json');
        mockResponse1.setBody('{"response":{"previous_year_data":[{"dealer_code":"I080","suggested_year":"2020","suggested_returns":1583,"sum_suggested_returns":"131642.61","returned_quantity":345,"sum_return_amount":"33312.05","suggested_compliance":"21.79"}],"quarter_data":[{"dealer_code":"I080","suggested_quarter_create_date":"2021-07-01","suggested_year":2021,"suggested_quarter":7,"suggested_returns":210,"sum_suggested_returns":"22531.80","returned_quantity":79,"sum_return_amount":"12681.82","suggested_compliance":"37.62","suggested_items_percentage_change":"-55.900","suggested_items_amount_percentage_change":"-27.200","return_items_percentage_change":"-69.500","return_items_amount_percentage_change":"-25.800","compliance_percentage_change":"-30.900"},{"dealer_code":"I080","suggested_quarter_create_date":"2021-04-01","suggested_year":2021,"suggested_quarter":4,"suggested_returns":476,"sum_suggested_returns":"30932.29","returned_quantity":259,"sum_return_amount":"17084.50","suggested_compliance":"54.41","suggested_items_percentage_change":"-9.300","suggested_items_amount_percentage_change":"-45.100","return_items_percentage_change":"10.700","return_items_amount_percentage_change":"-56.800","compliance_percentage_change":"22.100"},{"dealer_code":"I080","suggested_quarter_create_date":"2021-01-01","suggested_year":2021,"suggested_quarter":1,"suggested_returns":525,"sum_suggested_returns":"56361.81","returned_quantity":234,"sum_return_amount":"39534.83","suggested_compliance":"44.57","suggested_items_percentage_change":"105.900","suggested_items_amount_percentage_change":"131.400","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_quarter_create_date":"2020-10-01","suggested_year":2020,"suggested_quarter":10,"suggested_returns":255,"sum_suggested_returns":"24355.57","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"0.000","suggested_items_amount_percentage_change":"0.000","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"}],"month_data":[{"dealer_code":"I080","suggested_month_create_date":"2021-08-01","suggested_year":2021,"suggested_month":8,"suggested_returns":210,"sum_suggested_returns":"22531.80","returned_quantity":79,"sum_return_amount":"12681.82","suggested_compliance":"37.62","suggested_items_percentage_change":"1.400","suggested_items_amount_percentage_change":"90.700","return_items_percentage_change":"-24.800","return_items_amount_percentage_change":"72.600","compliance_percentage_change":"-25.800"},{"dealer_code":"I080","suggested_month_create_date":"2021-06-01","suggested_year":2021,"suggested_month":6,"suggested_returns":207,"sum_suggested_returns":"11818.04","returned_quantity":105,"sum_return_amount":"7346.01","suggested_compliance":"50.72","suggested_items_percentage_change":"-23.000","suggested_items_amount_percentage_change":"-38.200","return_items_percentage_change":"-31.800","return_items_amount_percentage_change":"-24.600","compliance_percentage_change":"-11.400"},{"dealer_code":"I080","suggested_month_create_date":"2021-05-01","suggested_year":2021,"suggested_month":5,"suggested_returns":269,"sum_suggested_returns":"19114.25","returned_quantity":154,"sum_return_amount":"9738.49","suggested_compliance":"57.25","suggested_items_percentage_change":"-14.300","suggested_items_amount_percentage_change":"-43.200","return_items_percentage_change":"-6.100","return_items_amount_percentage_change":"-62.800","compliance_percentage_change":"9.600"},{"dealer_code":"I080","suggested_month_create_date":"2021-03-01","suggested_year":2021,"suggested_month":3,"suggested_returns":314,"sum_suggested_returns":"33681.48","returned_quantity":164,"sum_return_amount":"26211.60","suggested_compliance":"52.23","suggested_items_percentage_change":"48.800","suggested_items_amount_percentage_change":"48.500","return_items_percentage_change":"134.300","return_items_amount_percentage_change":"96.700","compliance_percentage_change":"57.400"},{"dealer_code":"I080","suggested_month_create_date":"2021-02-01","suggested_year":2021,"suggested_month":2,"suggested_returns":211,"sum_suggested_returns":"22680.33","returned_quantity":70,"sum_return_amount":"13323.23","suggested_compliance":"33.18","suggested_items_percentage_change":"-17.300","suggested_items_amount_percentage_change":"-6.900","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_month_create_date":"2020-11-01","suggested_year":2020,"suggested_month":11,"suggested_returns":255,"sum_suggested_returns":"24355.57","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"11.800","suggested_items_amount_percentage_change":"-0.700","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"},{"dealer_code":"I080","suggested_month_create_date":"2020-09-01","suggested_year":2020,"suggested_month":9,"suggested_returns":228,"sum_suggested_returns":"24517.16","returned_quantity":0,"sum_return_amount":"0.00","suggested_compliance":"0.00","suggested_items_percentage_change":"0.000","suggested_items_amount_percentage_change":"0.000","return_items_percentage_change":"0.000","return_items_amount_percentage_change":"0.000","compliance_percentage_change":"0.000"}]}}}');
        EDealerHTTPMockResponseTest returnComplianceListingContr = new EDealerHTTPMockResponseTest(mockResponse);
        EDealerHTTPMockResponseTest returnComplianceContr = new EDealerHTTPMockResponseTest(mockResponse1);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:AWS_EDealer'+'/return-compliance-report/dealer',returnComplianceListingContr);
        endpoint2TestResp.put('callout:AWS_EDealer'+'/return-compliance-kpi/dealers',returnComplianceContr);
        EdealerHttpCalloutServiceMultiMockTest multiCalloutMock = new EdealerHttpCalloutServiceMultiMockTest(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.startTest();
        // calling apex class method
        list<string> listDealerCode = new list<string>();
        listDealerCode.add('I080');
        
        EDealerReturnComplianceListingCtrl.fetchAWSReturnsComplianceData(listDealerCode,'k',null,null,'2021',4,2000,system.today(),system.today().addDays(3));
        Test.stopTest();    
        
    }
    @isTest
    private static void testWrapperData(){
        EDealerReturnComplianceListingCtrl.ReturnsComplianceWrapper objMaster=new EDealerReturnComplianceListingCtrl.ReturnsComplianceWrapper();
        objMaster.dlrcode='I080';
        objMaster.grp_num='I080';
        objMaster.rmatype='RM';
        objMaster.item='03-08712';
        objMaster.suggested_date='2021-08-10';
        objMaster.po_number='MDISTKRETURN-Aug2021';
        objMaster.suggested_amt=1.00000; 
        objMaster.returned_date='2021-10-06';
        objMaster.returned_qty=1.00000;
        objMaster.returned_amt=1.00000;
        objMaster.avg_return_compliance=1.00000;
        objMaster.return_status='RETURN ACCEPTED';
        objMaster.suggested_extnet=109.97;
        objMaster.suggested_qty=1;
        objMaster.returned_extnet=109.97;
        objMaster.order_status='INVOICED';
        List<EDealerReturnComplianceListingCtrl.ReturnsComplianceWrapper> lstMaster=new List<EDealerReturnComplianceListingCtrl.ReturnsComplianceWrapper>();
        lstMaster.add(objMaster); 
        
        //ResponseWrapper Data 
        EDealerReturnComplianceListingCtrl.ReturnsComplianceResponseWrapper resWrap=new EDealerReturnComplianceListingCtrl.ReturnsComplianceResponseWrapper();
        resWrap.error='Unknown Error'; 
        resWrap.response=lstMaster; 
        //resWrap.kpiDetails=lstMaster;
    }
}