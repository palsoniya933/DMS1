@isTest
public class EdealerHttpCalloutServiceMultiMockTest implements HttpCalloutMock{
    Map<String, HttpCalloutMock> requests;
    
    public EdealerHttpCalloutServiceMultiMockTest(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        if (mock != null) {
            return mock.respond(req);
        } else {
            system.debug('HTTP callout not supported for test methods');
            //throw new MyCustomException('HTTP callout not supported for test methods');
        }
        return null;
    }
    
    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}