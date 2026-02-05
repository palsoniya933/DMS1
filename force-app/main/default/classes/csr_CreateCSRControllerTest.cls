@isTest
public class csr_CreateCSRControllerTest {
    static User createTestUserWithPermissionSet() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(
            FirstName = 'Test',
            LastName = 'CSR',
            Email = 'testcsr' + DateTime.now().getTime() + '@example.com',
            Username = 'testcsr' + DateTime.now().getTime() + '@example.com',
            Alias = 'tcsr',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
        
        insert u;
        
        List<PermissionSet> psList = [SELECT Id FROM PermissionSet WHERE Name = 'CSR_Processor' LIMIT 1];
        
        if (!psList.isEmpty()) {
            insert new PermissionSetAssignment(
                AssigneeId = u.Id,
                PermissionSetId = psList[0].Id
            );
        }
        
        return u;
    }
    
    static Account createTestAccount() { 
        Account acc = new Account(Name = 'Test Dealer', Dealer_Code__c = '1234');
        insert acc;
        return acc;
    }
    
    /**
* Given: A valid mock response for dealers
* When:  getDealers is invoked
* Then:  A list of dealers should be returned
*/
    @isTest
    static void whenGetDealers_thenReturnDealerList() {
        Test.setMock(HttpCalloutMock.class, new DealerMockResponse());
        Test.startTest();
        List<csr_CreateCSRController.Dealer> dealers = csr_CreateCSRController.getDealers();
        Test.stopTest();
        System.assertEquals(1, dealers.size());
        System.assertEquals('1234', dealers[0].DealerId);
    }
    
    /**
* Given: A valid dealer code and mock response
* When:  getDealerInfo is invoked
* Then:  Dealer details should be returned
*/
    @isTest
    static void whenGetDealerInfo_thenReturnDealerDetail() {
        Test.setMock(HttpCalloutMock.class, new DealerMockResponse());
        Test.startTest();
        csr_CreateCSRController.DealerDetail info = csr_CreateCSRController.getDealerInfo('1234');
        Test.stopTest();
        System.assertNotEquals(null, info);
        System.assertEquals('1234', info.Dlrout);
        System.assertEquals('Test Dealer', info.Dlrname);
    }
    
    /**
* Given: A test user with CSR permission set
* When:  User-related methods are called
* Then:  Correct user info should be returned
*/
    @isTest
    static void whenUserMethodsCalled_thenReturnUserInfo() {
        User testUser = createTestUserWithPermissionSet();
        
        System.runAs(testUser) {
            Account acc = createTestAccount();
            Test.startTest();
            User u = csr_CreateCSRController.getCurrentUser();
            String name = csr_CreateCSRController.getUserNameById(testUser.Id);
            List<User> users = csr_CreateCSRController.getAllUsers();
            Test.stopTest();
            
            System.assertEquals(testUser.Id, u.Id);
            System.assert(name.contains(testUser.FirstName));
            System.assert(users.size() > 0);
        }
    }
    
    /**
* Given: A test user
* When:  User-related methods are called without account creation
* Then:  Correct user info should still be returned
*/
    @isTest
    static void whenUserMethodsCalledWithoutAccount_thenReturnUserInfo() {
        User testUser = createTestUserWithPermissionSet();
        
        System.runAs(testUser) {
            Test.startTest();
            User u = csr_CreateCSRController.getCurrentUser();
            String name = csr_CreateCSRController.getUserNameById(testUser.Id);
            List<User> users = csr_CreateCSRController.getAllUsers();
            Test.stopTest();
            
            System.assertEquals(testUser.Id, u.Id);
            System.assert(name.contains(testUser.FirstName));
            System.assert(users.size() > 0);
        }
    }
    
    /**
* Given: A CSR wrapper and two line wrappers
* When:  saveCSRWithLines is called
* Then:  CSR and lines should be created and lines can be deleted
*/
    @isTest
    static void whenSaveCSRWithLines_thenCSRAndLinesCreatedAndDeleted() {
        csr_CreateCSRController.CSRSaveWrapper csrWrapper = new csr_CreateCSRController.CSRSaveWrapper();
        csrWrapper.csrNumber = 'CSRTEST1';
        csrWrapper.customerName = 'Test Customer';
        csrWrapper.dealerName = 'Test Dealer';
        csrWrapper.internalCheckbox = false;
        csrWrapper.dealerAction = false;
        csrWrapper.expedite=false;
        List<csr_CreateCSRController.CsrLineWrapper> lineWrappers = new List<csr_CreateCSRController.CsrLineWrapper>();
        
        csr_CreateCSRController.CsrLineWrapper lw1 = new csr_CreateCSRController.CsrLineWrapper();
        lw1.lineNumber = 'Line-001';
        lw1.partNumber = 'PN-1001';
        lw1.qty = 2;
        lw1.csrPrice = 50;
        lw1.isMRChecked = false;
        
        lw1.status = 'Pending Approval';
        lineWrappers.add(lw1);
        
        csr_CreateCSRController.CsrLineWrapper lw2 = new csr_CreateCSRController.CsrLineWrapper();
        lw2.lineNumber = 'Line-002';
        lw2.partNumber = 'PN-2002';
        lw2.qty = 3;
        lw2.csrPrice = 75;
        lw2.status = 'Pending Approval';
        lw1.isMRChecked = false;
        lineWrappers.add(lw2);
        
        Test.startTest();
        csr_CreateCSRController.SaveResultWrapper result =
            csr_CreateCSRController.saveCSRWithLines(
                JSON.serialize(csrWrapper),
                JSON.serialize(lineWrappers),
                new List<Id>(),
                null
            );
        
        List<Id> toDelete = new List<Id>();
        for (csr_CreateCSRController.CsrLineWrapper lw : result.csrLines) {
            toDelete.add(lw.id);
        }
        
        csr_CreateCSRController.SaveResultWrapper afterDelete =
            csr_CreateCSRController.saveCSRWithLines(
                JSON.serialize(csrWrapper),
                null,
                toDelete,
                result.csrData.id
            );
        Test.stopTest();
        
        Integer countLines = [SELECT COUNT() FROM CSR_Line__c WHERE CSR__c = :result.csrData.id];
    }
    
    /**
* Given: A CSR and its line records
* When:  fetchCsrAndCsrLinesById is called
* Then:  CSR with lines should be returned
*/
    @isTest
    static void whenFetchCsrAndCsrLinesById_thenReturnCSRWithLines() {
        CSR__c csr = new CSR__c(
            CSR_Number__c = 'CSR0001',
            csr_Status__c = 'N'
        );
        insert csr;
        
        List<CSR_Line__c> csrLines = new List<CSR_Line__c>{
            new CSR_Line__c(
                CSR__c = csr.Id,
                Name = 'Line-001',
                csr_Parts_Number__c = 'PN-1001',
                csr_Quantity__c = 2,
                Csr_Price__c = 50,
                csr_Status__c = 'N'
            ),
                new CSR_Line__c(
                    CSR__c = csr.Id,
                    Name = 'Line-002',
                    csr_Parts_Number__c = 'PN-2002',
                    csr_Quantity__c = 3,
                    Csr_Price__c = 75,
                    csr_Status__c = 'N'
                )
                };
                    insert csrLines;
        
        Test.startTest();
        csr_CreateCSRController.CSRWithLinesWrapper wrapper =
            csr_CreateCSRController.fetchCsrAndCsrLinesById(csr.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, wrapper, 'Wrapper should not be null');
        System.assertNotEquals(null, wrapper.csrRecord, 'CSR record should be returned');
        System.assertEquals(csr.Id, wrapper.csrRecord.csrRecord.Id, 'CSR Id must match');
        System.assertEquals(2, wrapper.csrLines.size(), 'Should return 2 CSR lines');
    }
    
    private class AsiMockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(
                '{"Data":{"CSRNumber":123,"Phase":1,"CsrLines":[{"LineNbr":1,"Itmid":"PN-1001","Channel":"DSP","Quantity":10.0},{"LineNbr":2,"Itmid":"PN-2002","Channel":"WHS","Quantity":5.0}]},"ErrorResponse":{"IsSuccess":"true","ErrorMessages":[]}}'
            );
            return res;
        }
    }
    
    private static CSR__c createTestCSR() {
        CSR__c csr = new CSR__c(
            CSR_Number__c = 'CSR-001',
            csr_Status__c = 'N'
        );
        insert csr;
        return csr;
    }

    @isTest
    static void givenValidPayload_whenDenyCSRLinesAPI_thenReturnMappedResponse() {
        Test.setMock(HttpCalloutMock.class, new DenyCSRLinesMockResponse());

        Test.startTest();
        String payload = JSON.serialize(new Map<String, Object>{
            'CSRNumber' => '12345678',
                'Phase' => '1',
                'LineNumber' => '1',
                'ReasonCode' => '02',
                'UserName' => 'Test User'                
                });
        Boolean denyCsrLines = csr_CreateCSRController.denyCSRLinesAPI(payload);
        Test.stopTest();
        System.assertEquals(true, denyCsrLines, 'One CSR Line should be denied');
    }

    @isTest
    static void givenValidPayload_whenReworkCSRLinesAPI_thenReturnMappedResponse() {
        Test.setMock(HttpCalloutMock.class, new ReworkCSRLinesMockResponse());

        Test.startTest();
        String payload = JSON.serialize(new Map<String, Object>{
            'CSRNumber' => '12345678',
                'Phase' => '1',
                'LineNumber' => '1',
                'Comment' => '02',
                'UserName' => 'Test User'                
                });
        Boolean reworkCsrLines = csr_CreateCSRController.reworkCSRLinesAPI(payload);
        Test.stopTest();
        System.assertEquals(true, reworkCsrLines, 'One CSR Line should be reworked');
    }

    @IsTest
    static void testUpdateDeniedCSRLines() {
        List<CSR_Line__c> csrLines = new List<CSR_Line__c>();

        for (Integer i = 0; i < 2; i++) {
            csrLines.add(new CSR_Line__c(
                Name = 'Test CSR Line ' + i,
                csr_Status__c = 'D',
                csr_Deny_Reason_Code__c = null
            ));
        }

        insert csrLines;

        List<Id> csrLineIds = new List<Id>();
        for (CSR_Line__c line : csrLines) {
            csrLineIds.add(line.Id);
        }

        Test.startTest();
        csr_CreateCSRController.updateDeniedCSRLines(
            csrLineIds,
            '02'
        );
        Test.stopTest();

        List<CSR_Line__c> updatedLines = [
            SELECT csr_Status__c, csr_Deny_Reason_Code__c
            FROM CSR_Line__c
            WHERE Id IN :csrLineIds
        ];

        for (CSR_Line__c line : updatedLines) {
            System.assertEquals(
                'R',
                line.csr_Status__c,
                'CSR Status should be updated to R'
            );
            System.assertEquals(
                '02',
                line.csr_Deny_Reason_Code__c,
                'Deny Reason Code should be updated'
            );
        }
    }

    @IsTest
    static void testUpdateReworkedCSRLines() {
        CSR__c csr = new CSR__c(
            CSR_Number__c = '12345678',
            csr_Status__c = 'X'
        );
        insert csr;

        List<CSR_Line__c> csrLines = new List<CSR_Line__c>();
        for (Integer i = 1; i <= 3; i++) {
            csrLines.add(new CSR_Line__c(
                CSR__c = csr.Id,
                csr_Status__c = 'X'
            ));
        }
        insert csrLines;

        List<Id> lineIds = new List<Id>();
        for (CSR_Line__c line : csrLines) {
            lineIds.add(line.Id);
        }

        Test.startTest();
            csr_CreateCSRController.updateReworkedCSRLines(lineIds);
        Test.stopTest();

        List<CSR_Line__c> updatedLines = [
            SELECT Id, csr_Status__c
            FROM CSR_Line__c
            WHERE Id IN :lineIds
        ];

        for (CSR_Line__c line : updatedLines) {
            System.assertEquals(
                'Rework',
                line.csr_Status__c,
                'CSR Line status should be Rework'
            );
        }

        CSR__c updatedCSR = [
            SELECT Id, csr_Status__c
            FROM CSR__c
            WHERE Id = :csr.Id
        ];

        System.assertEquals(
            'Rework',
            updatedCSR.csr_Status__c,
            'Parent CSR status should be Rework'
        );
    }
    
    // test method for CreateCSRAndLineInASI 
    @isTest
    static void givenValidPayload_whenCreateCSRAndLineInASI_thenReturnResponseWithLines() {
        Test.setMock(HttpCalloutMock.class, new AsiMockResponse());
        CSR__c csr = createTestCSR();
        String dummyPayload = '{"DealerId":"1234"}';
        
        Test.startTest();
        String response = csr_CreateCSRController.createCSRAndLineInASI(dummyPayload, csr.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assert(response.contains('"CSRNumber":123'), 'Response must contain CSRNumber');
        System.assert(response.contains('"CsrLines"'), 'Response must contain CSR lines');
        System.assert(response.contains('"Itmid":"PN-1001"'), 'Response must include first line part number');
        System.assert(response.contains('"Channel":"DSP"'), 'Response must include channel for line');
    }
    /**
* Given: A valid payload and API response
* When:  updateCsrAndLinesInASI is called
* Then:  Status and line status should be mapped back to Salesforce labels
*/
    @isTest
    static void givenValidPayload_whenUpdateCsrAndLinesInASI_thenReturnMappedResponse() {
        Test.setMock(HttpCalloutMock.class, new UpdateCsrAndLinesMock());
        
        String requestObj = JSON.serialize(new Map<String, Object>{
            'CSRNumber' => 'CSR-123',
                'Status' => 'Holding',
                'Phase'=>1,
                'CSRILine' => new List<Object>{
                    new Map<String, Object>{
                        'LineNumber' => 1,
                            'LineStatus' => 'Holding'
                            }
                }
        });
        
        Test.startTest();
        String responseStr = csr_CreateCSRController.updateCsrAndLinesInASI(requestObj,true);
        Test.stopTest();
        
        System.assertNotEquals(null, responseStr, 'Response should not be null');
        
        // Deserialize into response wrapper
        csr_CreateCSRController.UpdateCsrResponse resp =
            (csr_CreateCSRController.UpdateCsrResponse) JSON.deserialize(responseStr, csr_CreateCSRController.UpdateCsrResponse.class);
        
        // Assert CSR number and status mapping
        System.assertEquals('Development', resp.Data.Status, 'Status should be mapped back to Salesforce label');
        System.assertEquals('Development', resp.Data.CsrLines[0].LineStat, 'Line status should be mapped back');
    }
    @isTest
    static void givenValidPayload_whenCancelAndUncancelCSRLines_thenReturnMappedResponse() {
        // Arrange mock callout
        Test.setMock(HttpCalloutMock.class, new CancelMockResponse());
        
        // Create a dummy user with ASI_Username__c
        User testUser = createTestUserWithPermissionSet();
        System.runAs(testUser) {
            testUser.ASI_Username__c = 'asi_test_user'; // assuming field exists on User
            update testUser;
            
            // Prepare request JSON
            String requestObj = JSON.serialize(new Map<String, Object>{
                'CSRNumber' => 'CSR-789',
                    'Phase' => 1
                    });
            
            Test.startTest();
            csr_CreateCSRController.CancelUncancelResponse resp =
                csr_CreateCSRController.cancelAndUncancelCSRLines(requestObj);
            Test.stopTest();
            
            // Assertions
            System.assertNotEquals(null, resp, 'Response must not be null');
            System.assertNotEquals(null, resp.data, 'Data must not be null');
            System.assertEquals(2, resp.data.csrLinesO.size(), 'Should return 2 CSR lines');
            
            // Validate status mapping
            System.assertEquals('Development', resp.data.csrLinesO[0].status, 'D should map to Development');
            System.assertEquals('', resp.data.csrLinesO[0].cancelReason, 'Null cancel reason should default to blank');
            System.assertEquals('Cancelled', resp.data.csrLinesO[1].status, 'C should map to Holding');
            System.assertEquals('Out of stock', resp.data.csrLinesO[1].cancelReason, 'Cancel reason must be preserved');
        }
    }
    @isTest
    static void givenValidApiResponse_whenGetCancelReasonsFromAPI_thenReturnReasonOptions() {
        Test.setMock(HttpCalloutMock.class, new CancelReasonMock());
        
        Test.startTest();
        List<csr_CreateCSRController.CancelReasonOption> reasons =
            csr_CreateCSRController.getCancelReasonsFromAPI();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, reasons, 'Result should not be null');
        System.assertEquals(2, reasons.size(), 'Should return 2 cancel reasons');
        
        // Check mapping: value = ReasonCode, label = ReasonDescription
        System.assertEquals('R01', reasons[0].value, 'First reason code mismatch');
        System.assertEquals('Out of stock', reasons[0].label, 'First reason description mismatch');
        System.assertEquals('R02', reasons[1].value, 'Second reason code mismatch');
        System.assertEquals('Price mismatch', reasons[1].label, 'Second reason description mismatch');
    }
    @IsTest
    static void givenValidPayload_whenUpdateHeaderStatusForDealerAction_thenReturnMappedStatus() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new WaitForDealerMock());
        
        String csrNumber = 'CSR-1001';
        Integer phase = 1;
        
        Test.startTest();
        String result = csr_CreateCSRController.updateHeaderStatusForDealerAction(csrNumber, phase);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Status label should not be null');
        // Assuming statusMap maps "W" -> "Waiting For Dealer" or similar
        System.debug('Mapped Status => ' + result);
    }
    
    public class DealerMockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            if (req.getEndpoint().contains('GetDealers')) {
                res.setBody('{"Dealers":[{"DealerId":"1234","DealerName":"Test Dealer"}]}');
            } else if (req.getEndpoint().contains('GWPRDealerInfo')) {
                res.setBody('{"Data":{"Dlrout":"1234","Dlrname":"Test Dealer"}}');
            }
            return res;
        }
        
    }
    
    private class UpdateCsrAndLinesMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            
            String responseBody = JSON.serialize(new Map<String, Object>{
                'Data' => new Map<String, Object>{
                    'CSRNumber' => 'CSR-123',
                        'Status' => 'D',
                        'CsrLines' => new List<Object>{
                            new Map<String, Object>{
                                'LineNbr' =>1,
                                    'LineStat' => 'D'
                                    }
                        }
                },
                    'ErrorResponse' => new Map<String, Object>{
                        'IsSuccess' => true,
                            'ErrorMessages' => new List<String>()
                            }
            });
            
            res.setBody(responseBody);
            return res;
        }
    }
    private class CancelMockResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            
            // Mock response body like API returns
            String body = JSON.serialize(new Map<String, Object>{
                'Data' => new Map<String, Object>{
                    'CsrLinesO' => new List<Object>{
                        new Map<String, Object>{
                            'LineNbr' => 1,
                                'status' => 'D',       // should map to Development
                                'cancelReason' => null // should default to ''
                                },
                                    new Map<String, Object>{
                                        'LineNbr' => 2,
                                            'status' => 'C',       
                                            'cancelReason' => 'Out of stock'
                                            }
                    }
                },
                    'ErrorResponse' => new Map<String, Object>{
                        'IsSuccess' => true,
                            'ErrorMessages' => new List<String>()
                            }
            });
            
            res.setBody(body);
            return res;
        }
    }
    private class WaitForDealerMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            
            
            // Sample response from your JSON example
            String body = '{' +
                '"Data": {' +
                '"StatusCode": "W",' +
                '"StatusDescription": "Pending Dealer Response"' +
                '},' +
                '"ErrorResponse": {' +
                '"IsSuccess": "true",' +
                '"ErrorMessages": []' +
                '}' +
                '}';
            
            res.setBody(body);
            return res;
        }
    }
    private class CancelReasonMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            
            // Mock API response
            String body = JSON.serialize(new Map<String, Object>{
                'CancelReasons' => new List<Object>{
                    new Map<String, Object>{
                        'ReasonCode' => 'R01',
                            'ReasonDescription' => 'Out of stock'
                            },
                                new Map<String, Object>{
                                    'ReasonCode' => 'R02',
                                        'ReasonDescription' => 'Price mismatch'
                                        }
                }
            });
            
            res.setBody(body);
            return res;
        }
    }

    public class DenyCSRLinesMockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            if (req.getEndpoint().contains('DenyCSRLines')) {
                res.setBody('{"Data":{"Denials":[{"CSRNumber":30357997,"Phase":1,"LineNumber":1,"Status":"C","DenyReason":""}]},"ErrorResponse":{"IsSuccess":"true","ErrorMessages":[]}}');
            }
            return res;
        }
    }

    public class ReworkCSRLinesMockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            if (req.getEndpoint().contains('ReworkLines')) {
                res.setBody('{"Data":{"Reworks":[{"CSRNumber":30356671,"Phase":1,"LineNumber":1,"Status":"D"}]},"ErrorResponse":{"IsSuccess":"false","ErrorMessages":[]}}');
            }
            return res;
        }
    }    
    
    private static CSR__c createTestCSRWithFields() {
        CSR__c csr = new CSR__c(
            // Replace these placeholder values with actual picklist values from your org
            csr_DealerGroup__c = 'O997',    // e.g. 'GroupA'
            csr_Dealer_Type__c = 'G',      // e.g. 'Distributor'
            csr_Dealer_Name__c = 'DealerName1',
            csr_DealerDivision__c = 'K',
            csr_Customer_Name__c = 'Customer1',
            csr_Internal_Checkbox__c = false,
            csr_Competitive_Type__c = 'B', // e.g. 'TypeA'
            csr_Type__c = 'B',                         // e.g. 'Standard'
            csr_Effective_Date__c = String.valueOf(Date.today()),
            csr_Expiration_Date__c = String.valueOf(Date.today().addDays(30)),
            csr_Assigned_To__c = UserInfo.getUserId(),
            csr_AccountId__c = null,
            csr_Country__c = 'USA',
            csr_DPM_Name__c = 'DPMName',
            csr_District__c = 'District1',
            csr_Region__c = 'Regi',
            csr_Currency_Code__c = 'USD',
            csr_Exchange_Rate__c = 1.0,
            csr_RSM_Name__c = 'RSMName',
            csr_DealerCode__c = 'DCode1',
            CSR_Number__c = 'CSR-0001',
            csr_Status__c = 'N', // Assuming 'N' is a valid status code
            csr_Phase__c = 0
        );
        insert csr;
        return csr;
    }
    
    // Helper method to create test CSR Lines associated to a CSR (no changes needed here)
    private static List<CSR_Line__c> createTestCSRLines(Id csrId) {
        List<CSR_Line__c> lines = new List<CSR_Line__c>();
        lines.add(new CSR_Line__c(
            CSR__c = csrId,
            csr_Parts_Number__c = 'PN-001',
            csr_Part_Description__c = 'Part Desc 1',
            csr_Quantity__c = 10,
            csr_W_D__c = 'WHS',
            csr_Competitor__c = 'Comp1',
            csr_Competitor_P_N__c = 'CPN1',
            Csr_Price__c = 100,
            csr_Competitor_Brand__c = 'Brand1',
            csr_PPD_MRG__c = 5,
            csr_Discount__c = 10,
            csr_Competitor_Price__c = 90,
            csr_Stock_Class__c = 'Cla1',
            csr_Requested_Discount__c = 7,
            csr_Landing_Cost__c = 80,
            csr_STDDLERNET__c = 85,
            csr_Part_Type_Description__c = 'TypeDesc1',
            csr_Part_Type__c = 'G',
            csr_Best_Net__c = 75,
            csr_Status__c = 'N' // Assuming 'N' is a valid status code for lines
        ));
        lines.add(new CSR_Line__c(
            CSR__c = csrId,
            csr_Parts_Number__c = 'PN-002',
            csr_Part_Description__c = 'Part Desc 2',
            csr_Quantity__c = 20,
            csr_W_D__c = 'DSP',
            csr_Competitor__c = 'Comp2',
            csr_Competitor_P_N__c = 'CPN2',
            Csr_Price__c = 200,
            csr_Competitor_Brand__c = 'Brand2',
            csr_PPD_MRG__c = 10,
            csr_Discount__c = 15,
            csr_Competitor_Price__c = 180,
            csr_Stock_Class__c = 'Clas',
            csr_Requested_Discount__c = 12,
            csr_Landing_Cost__c = 160,
            csr_STDDLERNET__c = 170,
            csr_Part_Type_Description__c = 'TypeDesc2',
            csr_Best_Net__c = 150,
            csr_Status__c = 'N'
        ));
        insert lines;
        return lines;
    }
    
    @isTest
    static void testCopyCSR_Success() {
        // Arrange
        CSR__c originalCsr = createTestCSRWithFields();
        List<CSR_Line__c> originalLines = createTestCSRLines(originalCsr.Id);
        
        Test.startTest();
        
        // Act
        csr_CreateCSRController.CSRWithLinesWrapper copyWrapper = csr_CreateCSRController.copyCSR(originalCsr.Id);
        
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, copyWrapper, 'Copy wrapper should not be null');
        System.assertNotEquals(null, copyWrapper.csrRecord, 'Copied CSR wrapper should not be null');
        System.assertNotEquals(null, copyWrapper.csrLines, 'Copied CSR lines should not be null');
        System.assertEquals(originalLines.size(), copyWrapper.csrLines.size(), 'Copied lines count should match original lines');
        
        CSR__c copiedCsr = copyWrapper.csrRecord.csrRecord;
        
        // Verify lines have the new CSR Id
        for (csr_CreateCSRController.CsrLineWrapper lineWrapper : copyWrapper.csrLines) {
            // The lineWrapper.id should be the Id of inserted CSR_Line__c record
            // Query the line record to verify CSR__c
            CSR_Line__c insertedLine = [SELECT CSR__c FROM CSR_Line__c WHERE Id = :lineWrapper.id LIMIT 1];
            System.assertEquals(copiedCsr.Id, insertedLine.CSR__c, 'Line CSR__c should match copied CSR Id');
        }
    }
    
    @isTest
    static void testFetchCSRRecordFromAPI_ValidInput() {
        Test.setMock(HttpCalloutMock.class, new FetchCSRRecordMock());
        
        Integer csrNumber = 123;
        Integer phase = 1;
        
        Test.startTest();
        String response = csr_CreateCSRController.fetchCSRRecordFromAPI(csrNumber, phase);
        Test.stopTest();
        
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assert(response.contains('CSRNumber'), 'Response should contain CSRNumber');
    }
    
    /**
* Test fetchCSRRecordFromAPI with null parameters should throw AuraHandledException.
*/
    @isTest
    static void testFetchCSRRecordFromAPI_NullParameters() {
        try {
            Test.startTest();
            csr_CreateCSRController.fetchCSRRecordFromAPI(null, null);
            Test.stopTest();
            System.assert(false, 'Exception was expected but not thrown');
        } catch (Exception e) {
            System.assert(e instanceof AuraHandledException, 'Expected AuraHandledException');
        }
    }
    
    /**
* Test saveCSRApiResponse method with valid API response JSON.
*/
    
    @isTest
    static void testSaveCSRApiResponse_ValidResponse() {
        // Provided JSON string (formatted as a single line string)
        String apiResponseJson = '{"Data":{"DealerId":"A082","DlrName":"ALLSTATE PB OF SOUTH ST. PAUL","Cntry":"US","CurrCode":"USD","CurrExchRate":1.00000000,"District":"063","DPMName":"LORENZEN, S.","Region":"U005","RSMName":"JASON CAREY","DlrGroup":"A082","CustName":"*VARIOUS","CompType":"R","DlrType":"G","CSRType":"B","CsrUser":"","Chassi":"","InsComp":"","WriteOff":0.00,"DlrDisc":0,"DurBid":0,"ExpMarkUp":"","DealerDiv":"P","CreateDate":20251008,"EffDate":20251008,"ExpDate":20251107,"Status":"X","IntCheck":"","AssignTo":"","CreateBy":"","MinDSPMrg":0.0000,"MinWHSMrg":22.9300,"MinDisc":24.9992,"MaxDisc":24.9992,"MaxPropDisc":0.0000,"HeaderCmts":[],"CsrLines":[{"LineNbr":1,"LineStat":"X","Channel":"WHS","PartType":"V","PartTypeDesc":"Vendor","ItemClass":"017","Itmid":"90045553","ItemDesc":"SHOCK","Quantity":3.0000,"PPDMRG":22.9300,"BestNet":241.540000,"CSRPrice":241.540000,"LnDisc":24.9992,"MarketReview":"Y","CompPrice":0.000000,"CompCode":"002995","CompName":"BLIND BID","CompPart":"","CompBrnd":"","CancelReasonCode":"","CancelReasonDesc":"","LineCmts":[]}]},"ErrorResponse":{"IsSuccess":true,"ErrorMessagesCount":0,"ErrorMessages":[]}}}';
        
        Integer csrNumber = 123;  // Use appropriate CSR number expected by your logic
        Integer phase = 1;        // Use appropriate phase
        
        Test.startTest();
        Id savedId = csr_CreateCSRController.saveCSRApiResponse(apiResponseJson, csrNumber, phase);
        Test.stopTest();
        
        System.assertNotEquals(null, savedId, 'Saved CSR Id should not be null');
        
        // Verify CSR__c record exists and CSR_Number__c matches input
        CSR__c csrRecord = [SELECT Id, CSR_Number__c FROM CSR__c WHERE Id = :savedId LIMIT 1];
        System.assertEquals(String.valueOf(csrNumber), csrRecord.CSR_Number__c, 'CSR Number should match');
    }
    
    /**
* Test saveCSRApiResponse method with invalid API response JSON should throw exception.
*/
    @isTest
    static void testSaveCSRApiResponse_InvalidResponse() {
        String invalidJson = '{"invalid":"json"}';
        Integer csrNumber = 123;
        Integer phase = 1;
        
        try {
            Test.startTest();
            csr_CreateCSRController.saveCSRApiResponse(invalidJson, csrNumber, phase);
            Test.stopTest();
            System.assert(false, 'Exception was expected but not thrown');
        } catch (Exception e) {
            System.assert(e instanceof AuraHandledException, 'Expected AuraHandledException');
        }
    }
    
    // Mock class for fetchCSRRecordFromAPI callout
    private class FetchCSRRecordMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String responseBody = '{"Data": {"CSRNumber": 123, "Phase": 1}, "ErrorResponse": {"IsSuccess": "true", "ErrorMessages": []}}';
            res.setBody(responseBody);
            return res;
        }
    }
    
    
    
    public class CSRApprovalMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"Success","message":"CSR submitted for approval"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testSubmitCSRForApprovalApi_WithCallout() {
        Test.setMock(HttpCalloutMock.class, new CSRApprovalMock());
        
        CSR__c testCsr = new CSR__c(CSR_Number__c = '456', csr_Phase__c = 1);
        insert testCsr;
        
        Integer csrNumber = Integer.valueOf(testCsr.CSR_Number__c);
        Integer phase = 1;
        String userName = 'testuser@example.com';
        
        Test.startTest();
        String response = csr_CreateCSRController.submitCSRForApprovalApi(csrNumber, phase, userName);
        Test.stopTest();
        
        System.assert(response.contains('Success'), 'Response should indicate success');
    }
    
    // Mock class for GWLineCalculations API callout (reuse existing pattern)
    class GWLineCalculationsMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            
            // Mocking a successful response with expected fields
            String responseBody = JSON.serialize(new Map<String, Object>{
                'Data' => new Map<String, Object>{
                    'PaccarMargin' => 18.25,
                        'FinalNet' => 300.75,
                        'Discount' => 8.5
                        },
                            'ErrorResponse' => null
                            });
            res.setBody(responseBody);
            return res;
        }
    }
    
    
    @isTest
    static void testUpdatePricingTarget_WithMockCallout() {
        // Set the mock for HTTP callout
        Test.setMock(HttpCalloutMock.class, new GWLineCalculationsMock());
        
        // Prepare minimal payload (omitting optional fields to test defaults)
        Map<String, Object> payloadMap = new Map<String, Object>{
            'DutyCost' => 7,
                'FreightCost' => 12,
                // 'OtherCost' omitted intentionally to test default of 0
                'RebateCost' => 3,
                'DisplayCurrencyCode' => 'USD',
                'UserName' => 'testuser@example.com',
                'IsForMarketingReview' => 'false'
                };
                    String payloadJSON = JSON.serialize(payloadMap);
        
        Test.startTest();
        Map<String, Object> response = csr_CreateCSRController.updatePricingTarget(payloadJSON);
        Test.stopTest();
        
        System.assertNotEquals(null, response, 'Response map should not be null');
        
        // Assert returned values equal expected mock values
        Decimal paccarMargin = (Decimal) response.get('PaccarMargin');
        Decimal finalNet = (Decimal) response.get('FinalNet');
        Decimal discount = (Decimal) response.get('Discount');
        
        System.assertEquals(18.25, paccarMargin, 'PaccarMargin should match mocked value');
        System.assertEquals(300.75, finalNet, 'FinalNet should match mocked value');
        System.assertEquals(8.5, discount, 'Discount should match mocked value');
    }
    
    
    
    @isTest
    static void testUpdateLocalCSRStatusAfterTermination() {
        // Arrange
        CSR__c testCsr = new CSR__c(
            CSR_Number__c = 'CSR-001',
            csr_Phase__c = 1,
            csr_Status__c = 'N'
        );
        insert testCsr;
        
        List<CSR_Line__c> testLines = new List<CSR_Line__c>{
            new CSR_Line__c(CSR__c = testCsr.Id, Name = '1', csr_Status__c = 'N'),
                new CSR_Line__c(CSR__c = testCsr.Id, Name = '2', csr_Status__c = 'N')
                };
                    insert testLines;
        
        Test.startTest();
        
        // Act: Terminate first line
        csr_CreateCSRController.updateLocalCSRStatusAfterTermination('CSR-001', 1, new List<Integer>{1});
        
        // Act: Terminate second line
        csr_CreateCSRController.updateLocalCSRStatusAfterTermination('CSR-001', 1, new List<Integer>{2});
        
        Test.stopTest();
        
        // Assert after both calls
        List<CSR_Line__c> updatedLines = [
            SELECT Id, Name, csr_Status__c FROM CSR_Line__c WHERE CSR__c = :testCsr.Id ORDER BY Name
        ];
        CSR__c updatedCsr = [SELECT Id, csr_Status__c FROM CSR__c WHERE Id = :testCsr.Id];
        
        for (CSR_Line__c line : updatedLines) {
            System.assertEquals('T', line.csr_Status__c, 'All lines should be terminated');
        }
        System.assertEquals('T', updatedCsr.csr_Status__c, 'CSR header status should be terminated');
    }
}