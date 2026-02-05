@isTest
public class EDealerReturnComplianceControllerTest {
    
    @isTest
    private static void fetchAWSReturnsComplianceKPIData(){
        
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": {"quarter_data": [{"dealer_code": "A875", "suggested_quarter_create_date": "2021-04-01", "suggested_year": 2021, "suggested_quarter": 4, "suggested_returns": 754, "sum_suggested_returns": "86419.43", "returned_quantity": 0, "sum_return_amount": "0.00", "suggested_compliance": "0.00", "suggested_items_percentage_change": "153.900", "suggested_items_amount_percentage_change": "121.600", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_quarter_create_date": "2021-01-01", "suggested_year": 2021, "suggested_quarter": 1, "suggested_returns": 297, "sum_suggested_returns": "38998.02", "returned_quantity": 0, "sum_return_amount": "0.00", "suggested_compliance": "0.00", "suggested_items_percentage_change": "-84.000", "suggested_items_amount_percentage_change": "-71.900", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_quarter_create_date": "2020-10-01", "suggested_year": 2020, "suggested_quarter": 10, "suggested_returns": 1853, "sum_suggested_returns": "138891.66", "returned_quantity": 386, "sum_return_amount": "43808.01", "suggested_compliance": "20.83", "suggested_items_percentage_change": "-56.200", "suggested_items_amount_percentage_change": "-20.700", "return_items_percentage_change": "-18.200", "return_items_amount_percentage_change": "-10.600", "compliance_percentage_change": "86.900"}, {"dealer_code": "A875", "suggested_quarter_create_date": "2020-07-01", "suggested_year": 2020, "suggested_quarter": 7, "suggested_returns": 4234, "sum_suggested_returns": "175059.95", "returned_quantity": 472, "sum_return_amount": "49005.68", "suggested_compliance": "11.15", "suggested_items_percentage_change": "126.800", "suggested_items_amount_percentage_change": "0.200", "return_items_percentage_change": "-34.100", "return_items_amount_percentage_change": "-45.600", "compliance_percentage_change": "-70.900"}, {"dealer_code": "A875", "suggested_quarter_create_date": "2020-04-01", "suggested_year": 2020, "suggested_quarter": 4, "suggested_returns": 1867, "sum_suggested_returns": "174794.26", "returned_quantity": 716, "sum_return_amount": "90063.54", "suggested_compliance": "38.35", "suggested_items_percentage_change": "0.000", "suggested_items_amount_percentage_change": "0.000", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}], "year_data": [{"dealer_code": "A875", "suggested_year": "2020", "suggested_returns": 9120, "sum_suggested_returns": "651052.62", "returned_quantity": 2124, "sum_return_amount": "254987.53", "suggested_compliance": "23.29"}], "month_data": [{"dealer_code": "A875", "suggested_month_create_date": "2021-04-01", "suggested_year": 2021, "suggested_month": 4, "suggested_returns": 308, "sum_suggested_returns": "33986.68", "returned_quantity": 0, "sum_return_amount": "0.00", "suggested_compliance": "0.00", "suggested_items_percentage_change": "3.700", "suggested_items_amount_percentage_change": "-12.900", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_month_create_date": "2021-02-01", "suggested_year": 2021, "suggested_month": 2, "suggested_returns": 297, "sum_suggested_returns": "38998.02", "returned_quantity": 0, "sum_return_amount": "0.00", "suggested_compliance": "0.00", "suggested_items_percentage_change": "-31.900", "suggested_items_amount_percentage_change": "8.000", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-12-01", "suggested_year": 2020, "suggested_month": 12, "suggested_returns": 436, "sum_suggested_returns": "36121.08", "returned_quantity": 97, "sum_return_amount": "16710.36", "suggested_compliance": "22.25", "suggested_items_percentage_change": "1.600", "suggested_items_amount_percentage_change": "-24.400", "return_items_percentage_change": "-66.400", "return_items_amount_percentage_change": "-38.300", "compliance_percentage_change": "-67.000"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-11-01", "suggested_year": 2020, "suggested_month": 11, "suggested_returns": 429, "sum_suggested_returns": "47795.55", "returned_quantity": 289, "sum_return_amount": "27097.65", "suggested_compliance": "67.37", "suggested_items_percentage_change": "-56.600", "suggested_items_amount_percentage_change": "-13.100", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-10-01", "suggested_year": 2020, "suggested_month": 10, "suggested_returns": 988, "sum_suggested_returns": "54975.03", "returned_quantity": 0, "sum_return_amount": "0.00", "suggested_compliance": "0.00", "suggested_items_percentage_change": "-15.800", "suggested_items_amount_percentage_change": "-16.200", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-09-01", "suggested_year": 2020, "suggested_month": 9, "suggested_returns": 1174, "sum_suggested_returns": "65640.62", "returned_quantity": 158, "sum_return_amount": "23486.91", "suggested_compliance": "13.46", "suggested_items_percentage_change": "36.500", "suggested_items_amount_percentage_change": "58.000", "return_items_percentage_change": "-49.700", "return_items_amount_percentage_change": "-8.000", "compliance_percentage_change": "-63.100"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-08-01", "suggested_year": 2020, "suggested_month": 8, "suggested_returns": 860, "sum_suggested_returns": "41551.31", "returned_quantity": 314, "sum_return_amount": "25518.77", "suggested_compliance": "36.51", "suggested_items_percentage_change": "-60.900", "suggested_items_amount_percentage_change": "-38.800", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-07-01", "suggested_year": 2020, "suggested_month": 7, "suggested_returns": 2200, "sum_suggested_returns": "67868.01", "returned_quantity": 0, "sum_return_amount": "0.00", "suggested_compliance": "0.00", "suggested_items_percentage_change": "97.300", "suggested_items_amount_percentage_change": "-12.300", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-06-01", "suggested_year": 2020, "suggested_month": 6, "suggested_returns": 1115, "sum_suggested_returns": "77369.59", "returned_quantity": 269, "sum_return_amount": "28158.76", "suggested_compliance": "24.13", "suggested_items_percentage_change": "222.300", "suggested_items_amount_percentage_change": "66.200", "return_items_percentage_change": "45.400", "return_items_amount_percentage_change": "21.800", "compliance_percentage_change": "-54.900"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-05-01", "suggested_year": 2020, "suggested_month": 5, "suggested_returns": 346, "sum_suggested_returns": "46555.82", "returned_quantity": 185, "sum_return_amount": "23123.72", "suggested_compliance": "53.47", "suggested_items_percentage_change": "-14.800", "suggested_items_amount_percentage_change": "-8.500", "return_items_percentage_change": "-29.400", "return_items_amount_percentage_change": "-40.400", "compliance_percentage_change": "-17.100"}, {"dealer_code": "A875", "suggested_month_create_date": "2020-04-01", "suggested_year": 2020, "suggested_month": 4, "suggested_returns": 406, "sum_suggested_returns": "50868.85", "returned_quantity": 262, "sum_return_amount": "38781.06", "suggested_compliance": "64.53", "suggested_items_percentage_change": "0.000", "suggested_items_amount_percentage_change": "0.000", "return_items_percentage_change": "0.000", "return_items_amount_percentage_change": "0.000", "compliance_percentage_change": "0.000"}]}}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        List<EDealerReturnComplianceController.ReturnsWrapper> month_data=new List<EDealerReturnComplianceController.ReturnsWrapper>();
        List<EDealerReturnComplianceController.ReturnsWrapper> quarter_data=new List<EDealerReturnComplianceController.ReturnsWrapper>();
        List<EDealerReturnComplianceController.ReturnsWrapper> year_data=new List<EDealerReturnComplianceController.ReturnsWrapper>();
        
        EDealerReturnComplianceController.ReturnsWrapper returnWrap=new EDealerReturnComplianceController.ReturnsWrapper();
        returnWrap.compliance_percentage_change=34;
        returnWrap.dealer_code='A897';
        returnWrap.return_items_amount_percentage_change=12;
        returnWrap.return_items_percentage_change=23;
        returnWrap.returned_quantity=1;
        returnWrap.suggested_compliance=21;
        returnWrap.suggested_month=3;
        returnWrap.suggested_month_create_date=Date.today();
        returnWrap.suggested_quarter=4;
        returnWrap.suggested_returns=7;
        returnWrap.sum_return_amount=45;
        returnWrap.sum_suggested_returns=2;
        returnWrap.suggested_year=2;
        returnWrap.suggested_quarter_create_date=Date.today();
        returnWrap.suggested_items_percentage_change=3;
        returnWrap.suggested_items_amount_percentage_change=4;
        month_data.add(returnWrap);
        quarter_data.add(returnWrap);
        year_data.add(returnWrap);
        
        EDealerReturnComplianceController.ReturnsComplianceWrapper returnComWrap=new EDealerReturnComplianceController.ReturnsComplianceWrapper();
        returnComWrap.month_data=month_data;
        returnComWrap.quarter_data=quarter_data;
        returnComWrap.year_data=year_data;
        
        
        EDealerReturnComplianceController.ReturnsComplianceKPIResponseWrapper returnKPI=new EDealerReturnComplianceController.ReturnsComplianceKPIResponseWrapper();
        returnKPI.error='Unknown Error';
        returnKPI.response=returnComWrap;
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealer = new list<string>();
        lstDealer.add('I080');
        lstDealer.add('I081');
        EDealerReturnComplianceController.ReturnsComplianceKPIResponseWrapper resWrrap = EDealerReturnComplianceController.fetchAWSReturnsComplianceKPIData(lstDealer,'K');     
        system.assertEquals('A875', resWrrap.response.quarter_data[0].dealer_code,'Dealer code is not equal to A875');
        Test.stopTest(); 
        
    }
    
    
}