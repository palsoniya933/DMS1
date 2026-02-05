@isTest
public class EDealerUserAuthenticationTest {
    
    @isTest
    private static void testASIUserAuthentication(){
        
        try{
            Contact objCon=new Contact();
            objCon.LastName='Test';
            insert objCon;
            // setting mock response
            HttpResponse mockResponse = new HttpResponse();
            mockResponse.setStatus('OK');
            mockResponse.setStatusCode(200); 
            mockResponse.setHeader('Content-Type', 'application/json');
            mockResponse.setBody('{"response":"Authenticated","error":""}');
            
            // setting mock apex class
            Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
            
            Test.startTest();
            
            // calling apex class method
            //EDealerSuggestedOrderUtils.callSuggestedOrdersApi(new List<string>{'999990'},'division');  
            EDealerUserAuthentication.ASIAuthenticationResponseWrapper resWrapp = EDealerUserAuthentication.ASIUserAuthentication('TestMartin', '12'); 
            system.assertEquals('Authenticated', resWrapp.response,'EDealer user authentication Response should be authenticated.');
            System.Assert(String.isBlank(resWrapp.error), 'error');
            EDealerUserAuthentication.getAndSaveASIDealersLocations('TestMartin'); 
            
            
            //   EDealerUserAuthentication.getAndSaveASIDealersLocations('TestUser'); 
            Test.stopTest(); 
        }
        catch(exception ex){}
        
    }
    
    @isTest
    private static void testASIUserAuthentication01(){
        
        try{
            Contact objCon=new Contact();
            objCon.LastName='Test';
            insert objCon;
            // setting mock response
            HttpResponse mockResponse = new HttpResponse();
            mockResponse.setStatus('OK');
            mockResponse.setStatusCode(200); 
            mockResponse.setHeader('Content-Type', 'application/json');
            mockResponse.setBody('{"response": {"primary_dealer": "K083","interactive_order_entry": "Y", "allow_upload_of_orders": "Y", "allow_upload_of_rma": "Y", "price_inquiry": "Y", "return_inquiry": "Y", "dealer_control_of_doests": "Y", "Accessible_Dealers": [{"dealer_code": "I080", "dealer_suffix": "", "cstnam": "WEST"}, {"dealer_code": "I080", "dealer_suffix": "", "cstnam": "INDI"},{"dealer_code": "K806", "dealer_suffix": "", "cstnam": "PAL"}, {"dealer_code": "K806", "dealer_suffix": "", "cstnam": "PALMER TRUCKS KENTUCKY, LLC"}, {"dealer_code": "V930", "dealer_suffix": "", "cstnam": "TRP STORE 041-NORTHERN KY"}, {"dealer_code": "K807", "dealer_suffix": "", "cstnam": "KENWORTH OF SELLERSBURG"}, {"dealer_code": "K807", "dealer_suffix": "", "cstnam": "BURG"}, {"dealer_code": "I081", "dealer_suffix": "", "cstnam": "AST"}]}}');
            //mockResponse.setBody('{"response": [{"InputUser": "TestMartin","InputPassword":"12"}]}');
            
            // setting mock apex class
            Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
            
            Test.startTest();
            
            // calling apex class method
            //EDealerSuggestedOrderUtils.callSuggestedOrdersApi(new List<string>{'999990'},'division');  
            string EDealerUserref=EDealerUserAuthentication.checkASIUsername();
             System.assert(EDealerUserref == null, 'EDealer User Authentication is null.');
           EDealerUserAuthentication.ASIUserDealersLocationResponseWrapper ASIUserDealersLocation=EDealerUserAuthentication.ASIUserDealerLocations('test');
            System.assert(ASIUserDealersLocation != null, 'ASIUser Dealers Location is null.');

            EDealerUserAuthentication.ASIUserDealerLocations('TestUser'); 
            EDealerUserAuthentication.ASIUserDealersLocationResponseWrapper ASIUserDealersLocation1=EDealerUserAuthentication.ASIUserDealerLocations('test');
            System.assert(ASIUserDealersLocation1 != null, 'ASIUser Dealers Location is null.');
            System.Assert(String.isBlank(ASIUserDealersLocation1.error), 'error');
            System.Assert(String.isBlank(ASIUserDealersLocation1.message), 'callout error');
            boolean bool=EDealerUserAuthentication.getAndSaveASIDealersLocations('TestUser');
            System.assert(bool != null, 'EDealer User Authentication is null.');
            boolean boolRef=EDealerUserAuthentication.ASIAuthenticationByPass();
            System.assert(boolRef != null, 'EDealer User Authentication is null.');
            Test.stopTest(); 
        }
        catch(exception ex){}
        
    }
    
    @isTest
    private static void testASIUserAuthentication03(){
        try{
            Contact objCon=new Contact();
            objCon.LastName='Test';
            insert objCon;
            // setting mock response
            HttpResponse mockResponse = new HttpResponse();
            mockResponse.setStatus('OK');
            mockResponse.setStatusCode(200); 
            mockResponse.setHeader('Content-Type', 'application/json');
            mockResponse.setBody('{"response": {"primary_dealer": "K083","interactive_order_entry": "Y", "allow_upload_of_orders": "Y", "allow_upload_of_rma": "Y", "price_inquiry": "Y", "return_inquiry": "Y", "dealer_control_of_doests": "Y", "Accessible_Dealers": [{"dealer_code": "I080", "dealer_suffix": "", "cstnam": "WEST"}, {"dealer_code": "I080", "dealer_suffix": "", "cstnam": "INDI"},{"dealer_code": "K806", "dealer_suffix": "", "cstnam": "PAL"}, {"dealer_code": "K806", "dealer_suffix": "", "cstnam": "PALMER TRUCKS KENTUCKY, LLC"}, {"dealer_code": "V930", "dealer_suffix": "", "cstnam": "TRP STORE 041-NORTHERN KY"}, {"dealer_code": "K807", "dealer_suffix": "", "cstnam": "KENWORTH OF SELLERSBURG"}, {"dealer_code": "K807", "dealer_suffix": "", "cstnam": "BURG"}, {"dealer_code": "I081", "dealer_suffix": "", "cstnam": "AST"}]}}');
            //mockResponse.setBody('{"response": [{"InputUser": "TestMartin","InputPassword":"12"}]}');
            
            // setting mock apex class
            Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
            
            Test.startTest();
             boolean boolRef=EDealerUserAuthentication.ASIAuthenticationByPass();
            System.assert(boolRef != null, 'EDealer User Authentication is null.');
            Test.stopTest(); 
        }
        catch(exception ex){}
        
    }
    
}