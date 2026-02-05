@isTest
public class eDealerCsrPartListControllerTest {
    @testSetup
    static void setupTestData() {
        // Insert Account with Dealer_Code__c = I3080 (used in payload)
        Account acc = new Account(
            Name = 'Test Dealer',
            Dealer_Code__c = 'I3080'
        );
        insert acc;
    }
    @IsTest static void validateGetAllowedQtyCSRType() {
        Test.startTest();
        List<String> result = eDealerCsrPartListController.getAllowedQtyCSRType();
        Test.stopTest();
        
        Assert.isFalse(result.isEmpty(), 'No CSR Types found.');
    }
    private class DealerInfoMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Region":"APAC","ExchRate":"1.0","CurrencyCode":"USD","Dlrname":"Test Dealer"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @IsTest static void testSaveCSRChanges() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}]}');
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        String payloadWithCSRTypeB = '{"headerData":{"DealerId":"I080","CSRType":"B","CsrUser":"I080","CompetitiveType":"B","DealerType":"S","CustomerName":"Test Customer","Status":""},"partDataList":[{"Id":"","Part":"","PartDescription":"","Quantity":0,"Channel":"","Competitor":{"CompetitorCode":"000067","CompetitorBrand":"test"},"CompPart":"","CompPrice":"","Brand":"","isSelected":false}]}';
        String payloadWithCSRTypeW = '{"headerData":{"DealerId":"I080","CSRType":"W","CsrUser":"I080","CompetitiveType":"B","DealerType":"S","CustomerName":"Test Customer","Status":""}';
        
        Test.startTest();
        eDealerCsrPartListController.saveCSRChanges(payloadWithCSRTypeB, '4343434', '1', 'excel.xlsx');
        eDealerCsrPartListController.saveCSRChanges(payloadWithCSRTypeW, '', '1', 'excel.xlsx');
        Test.stopTest();
    }
    
    @IsTest static void testSubmitCSR() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        String payload = '{"headerData":{"DealerId":"I3080","CSRType":"B","CsrUser":"I080","CompetitiveType":"B","DealerType":"S","CustomerName":"Test Customer","Status":""},"partDataList":[{"Id":"","Part":"","PartDescription":"","Quantity":0,"Channel":"","Competitor":{"CompetitorCode":"000067","CompetitorBrand":"test"},"CompPart":"","CompPrice":"","Brand":"","isSelected":false}]}';
        
        Test.startTest();
        eDealerCsrPartListController.submitCSR(payload, '4343434', '1', 'excel.xlsx'); 
        eDealerCsrPartListController.submitCSR(payload, '', '1', 'excel.xlsx');
        Test.stopTest();
    }
    
    @IsTest static void testSubmitCSR1() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}]}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        String payload = '{"headerData":{"DealerId":"I3080","CSRType":"W","CsrUser":"I080","CompetitiveType":"B","DealerType":"S","CustomerName":"Test Customer","Status":""},"partDataList":[{"Id":"","Part":"","PartDescription":"","Quantity":0,"Channel":"","Competitor":{"CompetitorCode":"000067","CompetitorBrand":"test"},"CompPart":"3","CompPrice":"3","Brand":"","isSelected":false}]}';
        
        Test.startTest();
        eDealerCsrPartListController.submitCSR(payload, '4343434', '1', 'excel.xlsx'); 
        eDealerCsrPartListController.submitCSR(payload, '', '1', 'excel.xlsx');
        Test.stopTest();
    }
    
    @IsTest static void testSubmitCSRWithNullCsrType() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}]},"ErrorResponse":{"IsSuccess":true}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        String payload = '{"headerData":{"DealerId":"I3080","CSRType":"","CsrUser":"I080","CompetitiveType":"B","DealerType":"S","CustomerName":"Test Customer","Status":""},"partDataList":[{"Id":"","Part":"","PartDescription":"","Quantity":0,"Channel":"PDC","Competitor":{"CompetitorCode":"","CompetitorBrand":"test"},"CompPart":"3","CompPrice":"3","Brand":"","isSelected":false}]}';
        
        Test.startTest();
        eDealerCsrPartListController.submitCSR(payload, '4343434', '1', 'excel.xlsx'); 
        eDealerCsrPartListController.submitCSR(payload, '', '1', 'excel.xlsx');
        Test.stopTest();
    }
    @IsTest static void testSubmitCSRWithNullCsrTypeR() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}],"ErrorResponse":{"IsSuccess":true},"CSROutput":{"Sanbr":30348730,"phase":1}}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        String payload = '{"headerData":{"DealerId":"I3080","CSRType":"R","CsrUser":"I080","CompetitiveType":"B","DealerType":"S","CustomerName":"Test Customer","Status":""},"partDataList":[{"Id":"","Part":"","PartDescription":"","Quantity":0,"Channel":"PDC","Competitor":{"CompetitorCode":"000067","CompetitorBrand":"test"},"CompPart":"3","CompPrice":"3","Brand":"","isSelected":false}]}';
        
        String fileDetail = '[{"fileId": 1, "fileName": "TestFile.pdf", "dealerCode": "ABC123", "filetype": "txt", "fileSizeInBytes": 1000, "formatedfileSize": "1KB", "blobData": "Base64EncodedData", "isEditMode": false, "isDeleted": false, "key": "Key123"}]';
        
        Test.startTest();
        eDealerCsrPartListController.submitCSR(payload, '4343434', '1', fileDetail); 
        eDealerCsrPartListController.submitCSR(payload, '', '1', fileDetail);
        Test.stopTest();
    }
    
    @IsTest static void testSubmitCSRWithNullCsrTypeRFileUpload() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}],"ErrorResponse":{"IsSuccess":"false","ErrorMessages": [{"ErrorDescription": "Sample Error"}]},"CSROutput":{"Sanbr":30348730,"phase":1}}');
        
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        String payload = '{"headerData":{"DealerId":"I3080","CSRType":"R","CsrUser":"I080","CompetitiveType":"B","DealerType":"S","CustomerName":"Test Customer","Status":""},"partDataList":[{"Id":"","Part":"","PartDescription":"","Quantity":0,"Channel":"PDC","Competitor":{"CompetitorCode":"000067","CompetitorBrand":"test"},"CompPart":"3","CompPrice":"3","Brand":"","isSelected":false}]}';
        
        String fileDetail = '[{"fileId": 1, "fileName": "TestFile.pdf", "dealerCode": "ABC123", "filetype": "txt", "fileSizeInBytes": 1000, "formatedfileSize": "1KB", "blobData": "Base64EncodedData", "isEditMode": false, "isDeleted": false, "key": "Key123"}]';
        
        Test.startTest();
        eDealerCsrPartListController.submitCSR(payload, '4343434', '1', fileDetail); 
        eDealerCsrPartListController.submitCSR(payload, '', '1', fileDetail);
        Test.stopTest();
    }
    @IsTest static void testGetColumnHeaders() {
        String reportName = 'CSL RSL Report'; 
        
        Test.startTest();
        try {
            Map<String, Object> result = eDealerCsrPartListController.getColumnHeaders(reportName);
        } catch (Exception e) {
            Map<String, Object> result=null;
        }
        Test.stopTest();
    }
    
    @IsTest static void testcancelCSR(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"response": [{"loc": "I080", "distchan": "*", "dlrsplrcd": "*", "stkclass": "*", "abc": "A", "abc_level": 1, "abccriteriaminqty": 10}], "RowCount": [{"rowcount": 4}]}');
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        Test.startTest();
        String resultData =  eDealerCsrPartListController.cancelCSR('I080','30348704','1','I080');
        Test.stopTest();
    }
    
    @IsTest static void getPartsColumnHeaders(){
        Test.startTest();
        eDealerCsrPartListController.getPartsColumnHeaders();
        Test.stopTest();
        
    }
    
    /*@isTest
static void testGetPartsColumnHeaders() {
Test.startTest();
String reportName = 'eDealer_Language_Translation__mdt'; 
List<Map<String, String>> result = eDealerCsrPartListController.getPartsColumnHeaders(reportName);
Test.stopTest();
}
*/
    
    @isTest
    static void givenPayload_whenSaveCSR_thenInsertCSRAndLines() {
        // Prepare payload JSON (DealerId is important here)
        String payload = 
            '{' +
            '"DealerId":"I3080",' +
            '"CSRType":"C",' +
            '"CsrUser":"I080",' +
            '"CompetitiveType":"B",' +
            '"DealerType":"S",' +
            '"CustomerName":"Test Customer",' +
            '"Status":"",' +
            '"CSRILine":[' +
            '{' +
            '"PartNumber":"ac1001",' +
            '"PartDescription":"test",' +
            '"Quantity":1,' +
            '"Channel":"WHS",' +
            '"CompetitorCode":"000067",' +
            '"CompPart":"3",' +
            '"Price":"3",' +
            '"CompetitorBrand":"test"' +
            '}' +
            ']' +
            '}';     
        String csrNumber = 'CSR-001';
        String phase = '1';
        
        // Mock the dealer info callout
        Test.setMock(HttpCalloutMock.class, new DealerInfoMock());
        
        Test.startTest();
        // Call the method under test
        eDealerCsrPartListController.saveCSRAndLinesDataToSF(payload, csrNumber, phase);
        Test.stopTest();
        
        // Validate CSR inserted
        List<CSR__c> csrs = [
            SELECT Id, CSR_Number__c, csr_Phase__c 
            FROM CSR__c 
            WHERE CSR_Number__c = :csrNumber
        ];
        
        System.assertEquals(1, csrs.size(), 'CSR should be inserted');
        System.assertEquals(csrNumber, csrs[0].CSR_Number__c, 'csrNumber should match');
        List<CSR_Line__c> csrLines = [
            SELECT Id, csr_Parts_Number__c, csr_Quantity__c, csr_W_D__c
            FROM CSR_Line__c
            WHERE CSR__c = :csrs[0].Id
        ];
        
        System.assertEquals(1, csrLines.size(), 'CSR Line should be inserted');
        System.assertEquals('ac1001', csrLines[0].csr_Parts_Number__c, 'Part number should match');
        System.assertEquals(1, csrLines[0].csr_Quantity__c, 'Quantity should match');
        System.assertEquals('WHS', csrLines[0].csr_W_D__c, 'Channel should match');
    }


    @isTest
    static void testGetWreckCSRMinPrice() {
        Test.startTest();
        Decimal result = eDealerCsrPartListController.getWreckCSRMinPrice();
        Test.stopTest();
        System.assertEquals(150, result, 'Limit should be 150');
    }

}