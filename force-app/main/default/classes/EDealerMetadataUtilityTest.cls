@isTest
public class EDealerMetadataUtilityTest {
    @isTest
    public static void testMetadataUtility(){
        User u = EDealerUserUtils.fetchLoggedInUserdetails();
        System.assert(u != null, 'EDealer  User Utils is null.');
        EDealerMetadataUtility.getEdealerAccessMetadataByProfilesName(new Set<String>{u.Profile.Name});
        System.assert(EDealerMetadataUtility.getEdealerAccessMetadataByProfilesName(new Set<String>{u.Profile.Name}) != null, 'EDealer EDealer User Utils is null.');
    }
    
    @isTest
    static void testTableColumnHeaderTranslations() {
        // Provide test data as needed
        String reportName = 'partsTableHeader';
        
        // Mock the callout to getEdealerTranslationRecordByDeveloperName
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"records": [{"Translation_json__c": "[{\"en_US\": \"Label1\", \"columnAPIName\": \"Value1\"}]"}]}', 200));
        
        // Call the method to be tested
        Test.startTest();
        List<Map<String, String>> result = EDealerMetadataUtility.tableColumnHeaderTranslations(reportName);
        Test.stopTest();
        
        // Add assertions based on the expected outcome
        System.assertNotEquals(null, result);
        //System.assertEquals(1, result.size());
        //System.assertEquals('Label1', result[0].get('label'));
        //System.assertEquals('Value1', result[0].get('value'));
        // Add more assertions as needed
    }
    
    @isTest
    static void testTranslateColumnHeaders(){
        String reportName = 'Global Report';
        Test.startTest();
        Map<String, String> result = EDealerMetadataUtility.translateColumnHeaders(reportName);
        Test.stopTest();
        system.assert(result !=null);
    }
    
    @isTest
    static void testTranslateReportFilterField(){
        String reportName = 'ABC Criteria';
        Test.startTest();
        Map<String, String> result = EDealerMetadataUtility.translateReportFilterField(reportName);
        Test.stopTest();
        system.assert(result !=null);

        
    } 
    
    @isTest
    static void testCsrHeaderTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.csrHeaderTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    
    @isTest
    static void testCsrTileTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.csrTileTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    
    
    
    @isTest
    static void testMyCSRTileTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.myCSRTileTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    
    @isTest
    static void testCsrDrilldownTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.csrDrilldownTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    
    @isTest
    static void testPendingCSRTileTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.pendingCSRTileTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    
    @isTest
    static void testCsrDashboardTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.csrDashboardTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    
    @isTest
    static void testCSRAnnouncementTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.CSRAnnouncementTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    @isTest
    static void testquoteRequestTranslations(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.quoteRequestTranslations;
        Test.stopTest();
        system.assert(result !=null);

    } 
    @isTest
    static void testvolumeSalesCustomButtonsTranslation(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.volumeSalesCustomButtonsTranslation;
        Test.stopTest();
        system.assert(result !=null);

    } 
      
    @isTest
    static void testvolumeSaleQuoteTranslation(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.volumeSaleQuoteTranslation;
        Test.stopTest();
        system.assert(result !=null);

    }
    
    @isTest
    static void testvolumeSaleBundleTranslation(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.volumeSalesBundle;
        Test.stopTest();
        system.assert(result !=null);

    }
   
    @isTest
    static void testdealerAccessType(){
        Test.startTest();
        string result = EDealerMetadataUtility.dealerAccessType('Sales Support','National Sales Manager-KW');
        Test.stopTest();
        system.assert(result !=null);

    }
    
    @isTest
    static void testGetVolumeSalesValues(){
        Test.startTest();
        Map<String,Object> result = EDealerMetadataUtility.getVolumeSalesValues();
        Test.stopTest();
        system.assert(result !=null);

    }
    
    // Helper class to mock the HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        String responseBody;
        Integer statusCode;
        
        public MockHttpResponseGenerator(String responseBody, Integer statusCode) {
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseBody);
            res.setStatusCode(statusCode);
            return res;
        }
    }
    
}