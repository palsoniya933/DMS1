@isTest
public class EDealerHTTPMockResponseTest implements HttpCalloutMock{
    private final HttpResponse response;
    private HttpRequest request;

    public EDealerHTTPMockResponseTest(HttpResponse response) {
        this.response = response; 
    }

    public HttpResponse respond(HttpRequest request) {
        this.request = request;
        return response;
    } 
}