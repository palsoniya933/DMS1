@IsTest
public class EDealerMassUploadValidationTest {

    @IsTest static void validatePartNumber() {
        String payload = '{"DealerCd":"I080","PartNo":[{"PartNumber":"AC1001","PartQty":1,"CompCd":"A&B"},{"PartNumber":"TQRAC1-637","PartQty":1,"CompCd":"AAAS"}]}';
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        String message = EDealerMassUploadValidation.validatePartNumber(payload);
        Test.stopTest();
        
        system.debug('----message--' + message);
    }
    
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"Data": {}, "ErrorResponse": {"IsSuccess": "false", "ErrorMessages": [{"ErrorDescription": "Sample Error"}]}}');
            res.setStatusCode(200);
            return res;
        }
    }
    
}