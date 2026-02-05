@isTest
public class EDealerSupplierCrossReferenceTest {
    @isTest
    private static void validateFetchAWSDealerSupplierReportData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "division": "KW", "dlrsplrcd": "0008", "splrname": "CUMMINS RECON USA", "dmdgroup": "CUMMINSUS", "activesw": "Y", "distchan": "ENGUS", "leadtime": 6.0, "transittime": 1.0, "minimumname": null, "managedsw": "Y", "monday": 1, "tuesday": 0, "wednesday": 0, "thursday": 0, "friday": 0, "saturday": 0, "sunday": 0}], "RowCount": [{"rowcount": 3}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('C223');
        
        EDealerSupplierCrossReference.SupplierCrossWrapper obj = new EDealerSupplierCrossReference.SupplierCrossWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='P';
        string strObj = JSON.serialize(obj);
        
        // calling apex class method
        EDealerSupplierCrossReference.fetchAWSDealerSupplierReportData(strObj);
        Test.stopTest(); 
    }
    
    @isTest
    private static void validateFetchAWSDealerSupplierReportData1(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "division": "KW", "dlrsplrcd": "0008", "splrname": "CUMMINS RECON USA", "dmdgroup": "CUMMINSUS", "activesw": "Y", "distchan": "ENGUS", "leadtime": 6.0, "transittime": 1.0, "minimumname": null, "managedsw": "Y", "monday": 1, "tuesday": 0, "wednesday": 0, "thursday": 0, "friday": 0, "saturday": 0, "sunday": 0}], "RowCount": [{"rowcount": 3}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('C223');
        
        EDealerSupplierCrossReference.SupplierCrossWrapper obj = new EDealerSupplierCrossReference.SupplierCrossWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='K';
        obj.field ='DMDGROUP';
        obj.operator ='Equals to';
        obj.value = 'CUMMINSUS';
        string strObj = JSON.serialize(obj);
        
        // calling apex class method
        EDealerSupplierCrossReference.fetchAWSDealerSupplierReportData(strObj);
        
        Test.stopTest();
    }
    
    @isTest
    private static void validateFetchAWSDealerSupplierReportData2(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('null');
        
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        
        // calling apex class method
        list<string> lstDealerCode = new list<string>();
        lstDealerCode.add('C223');
        
        EDealerSupplierCrossReference.SupplierCrossWrapper obj = new EDealerSupplierCrossReference.SupplierCrossWrapper();
        obj.recLimit=2000;
        obj.offSet=0;
        obj.dealerCodes=lstDealerCode;
        obj.dealer_division='K';
        obj.field ='DMDGROUP';
        obj.operator ='Equals to';
        obj.value = 'CUMMINSUS';
        string strObj = JSON.serialize(obj);
        try{
            EDealerSupplierCrossReference.fetchAWSDealerSupplierReportData(strObj);
        }
        catch(Exception ex){
            system.debug('Line Number::'+ex.getMessage());
        }
    }
}