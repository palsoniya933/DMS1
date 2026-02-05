@IsTest
public class EDealerCsrFileUploadTest {

    @IsTest static void validateUploadFile() {
        String fileDetail = '[{"fileId": 1, "fileName": "TestFile.pdf", "dealerCode": "ABC123", "filetype": "txt", "fileSizeInBytes": 1000, "formatedfileSize": "1KB", "blobData": "Base64EncodedData", "isEditMode": false, "isDeleted": false, "key": "Key123"}]';
        String csrNumber = '30348092';
        Integer csrPhase = 1;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        EDealerCsrFileUpload.uploadFile(fileDetail, csrNumber, csrPhase);
        Test.stopTest();
    }
    
    @IsTest static void validateUploadFileEditMode() {
        String fileDetail = '[{"fileId": 1, "fileName": "TestFile.pdf", "dealerCode": "ABC123", "filetype": "txt", "fileSizeInBytes": 1000, "formatedfileSize": "1KB", "blobData": "Base64EncodedData", "isEditMode": true, "isDeleted": true, "key": "Key123"}]';
        String csrNumber = '30348092';
        Integer csrPhase = 1;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        EDealerCsrFileUpload.uploadFile(fileDetail, csrNumber, csrPhase);
        Test.stopTest();
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