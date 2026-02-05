@IsTest
public class eDealerCreateCsrCommentControllerTest {
    
    @IsTest static void validateCsrCommentCreation() {
        eDealerCreateCsrCommentController.CommentWrapper wrapper = new eDealerCreateCsrCommentController.CommentWrapper( '30348092', 1, 0, 'D', 'Testing Comment', 'I080' );
        String commentsPayload = JSON.serialize(wrapper);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        String responseData = eDealerCreateCsrCommentController.createCsrComment(commentsPayload);
        Test.stopTest();
        
        Assert.isNotNull(responseData, 'CSR Comment creation fails.');
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