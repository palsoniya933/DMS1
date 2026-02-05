@isTest
public class EatonRestResourceTest {

    @testSetup static void setup() {
        Account act = new AccountBuilder()
                        .withDealerCode('TEST CLASS')
                        .buildInsert();

        Contact ct = new ContactBuilder()
                        .withLastName('lname0')
                        .withAccount(act.id)
                        .buildInsert();
        
        Vehicle__c v = new VehicleBuilder()
                        .withChassisID('GD307131')
                        .withEngine('TX-12')       // Added 2023-05-31 for the new Eaton validation rule
                        .buildInsert();
    }
    
    @IsTest
    public static void eatonCreateCaseSuccess(){ 
        Contact cct = [SELECT Id FROM Contact WHERE LastName='lname0' LIMIT 1];
        Eaton_Integration_Variables__mdt[] variables = MDTEatonDAO.getEatonVariables('setup');
        User eatonUser = [SELECT Id FROM User WHERE Name=:variables[0].User_Name__c];    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Case/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json'); 
        req.addParameter('status', 'New');//iVBORw0KGgoAAAANSUhEUgAAABsAAAAbCAYAAACN1PRVAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTM4IDc5LjE1OTgyNCwgMjAxNi8wOS8xNC0wMTowOTowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjgwOTVGNzMxNUNBRDExRTk4MkI1RUE0RjA0NzU4NkRDIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjgwOTVGNzMyNUNBRDExRTk4MkI1RUE0RjA0NzU4NkRDIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6ODA5NUY3MkY1Q0FEMTFFOTgyQjVFQTRGMDQ3NTg2REMiIHN0UmVmOmRUQ9InhtcC5kaWQ6ODA5NUY3MzA1Q0FEMTFFOTgyQjVFQTRGMDQ3NTg2REMiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz5fFfgKAAABa0lEQVR42uxWgW2DQAzMR1mgK9AR6AisQEZoR/iMACOUEcoIYYQwQhihjEDO1RFZX/B/oypSpFgyD35jv/8OP26aps29ZLu5ozyTPV6ynVyccxWGnLYWDG1mB8yVGLyaH6ANfGrlo9/XMtK3+3ki9Y9yS/Vio71U9lAr5Xc0/EQL8YttY2XMeVT0kriDlYkZAsm2ZMr0RtVSJCbLZWFWZeGqB2xFj7EnFt2Cj8gBfg7jR5hwZyQbg+cTVtdi3CPYECtFSAb/zyTqswodNCMrzwjyFcML88VSUIuNgtv3CsNOK2w88zl8z8Rsrk5I0a6A/r5gz0gcXXmPWOM2Ye+FGHvcvgr4AZZ5IhvraweJUD/jyoR9NbHyqgpLBrKzNZPxQ5xB7qgpctCt7FdvXJFOJSuEgVyp11j8uREbybSUCT63HTFkohWsvXbzfzrPhIXNgr1ZaEdRcSl/V2Rgrr+ZWw5P9/yVe7hkFwEGACB1urvOIYKLAAAAAElFTkSuQmCC
        string incoming = '{"request": {"primaryContact" : "' + cct.id + '","category" :"Transmission Diagnostics","status":"new","subject":"eaton case new","disposition":"Part Support","repair_order_num":"66013","chassis_num":"BD129400","vin_num":"1XPVDP9X5BD129400","failure_date":"04/29/2019","inservice_date":"01/01/2017","odometer_units":"miles","odometer":0,"trans_serial":"P1114084","caseNotes":[{"Note":"first one"},{"Note": "second one"}],"fileAttachments":[{"fileName":"logo.jpg","description":"ISP logo","data":""}]}}';
        req.requestBody = Blob.valueOf(incoming);
        system.debug('reqBody |' + req.requestBody.tostring());
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        System.runAs(eatonUser){
            EatonRestResource.doPut();         
        }
        Test.stopTest();
        String responseresult = res.responseBody.toString();
        system.debug(responseresult);
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(responseresult);
        system.assertEquals(results.get('caseStatus'), 'SUCCESS');
        system.assertEquals(results.get('commentStatus'), 'SUCCESS');
        system.assertEquals(results.get('attStatus'), 'FAILED');//SUCCESS
    }

    static testMethod void eatonCreateCaseFailed(){
        Contact cct = [SELECT Id FROM Contact WHERE LastName='lname0' LIMIT 1];
        Eaton_Integration_Variables__mdt[] variables = MDTEatonDAO.getEatonVariables('setup');
        User eatonUser = [SELECT Id FROM User WHERE Name=:variables[0].User_Name__c]; 

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Case/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json'); 
        req.addParameter('status', 'New');
        string incoming = '{"request": {"primaryContact" : "' + cct.id + 'X","category" :"Transmission Diagnostics","status":"new","subject":"eaton case","disposition":"Part Support","repair_order_num":"66013","chassis_num":"BD129400","vin_num":"1XPVDP9X5BD129400","failure_date":"04/29/2019","inservice_date":"01/01/2017","odometer_units":"miles","odometer":0,"trans_serial":"P1114084","caseNotes":[{"Note":"first one"},{"Note": "second one"}],"fileAttachments":[]}}';
        req.requestBody = Blob.valueOf(incoming);
        system.debug('reqBody |' + req.requestBody.tostring());
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        System.runAs(eatonUser){
            EatonRestResource.doPut();         
        }
        Test.stopTest(); 

        String responseresult = res.responseBody.toString();
        system.debug(responseresult);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseresult);
        system.assertEquals(results.get('caseStatus'), 'FAILED');
        system.assertEquals(results.get('commentStatus'), 'FAILED');
        system.assertEquals(results.get('attStatus'), 'FAILED');
    }
    static testMethod void eatonCreateCaseAttFailed(){    
        Contact cct = [SELECT Id FROM Contact WHERE LastName='lname0' LIMIT 1];
        Eaton_Integration_Variables__mdt[] variables = MDTEatonDAO.getEatonVariables('setup');
        User eatonUser = [SELECT Id FROM User WHERE Name=:variables[0].User_Name__c];   

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Case/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json'); 
        req.addParameter('status', 'New');
        string incoming = '{"request": {"primaryContact" : "' + cct.id + '","category" :"Transmission Diagnostics","status":"new","subject":"eaton case new","disposition":"Part Support","repair_order_num":"66013","chassis_num":"BD129400","vin_num":"1XPVDP9X5BD129400","failure_date":"04/29/2019","inservice_date":"01/01/2017","odometer_units":"miles","odometer":0,"trans_serial":"P1114084","caseNotes":[{"Note":"first one"},{"Note": "second one"}],"fileAttachments":[{"fileName":"logo.jpg","description":"Paccar logo","data":""}]}}';
        req.requestBody = Blob.valueOf(incoming);
        system.debug('reqBody |' + req.requestBody.tostring());
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        System.runAs(eatonUser){
            EatonRestResource.doPut();         
        }
        Test.stopTest(); 

        String responseresult = res.responseBody.toString();
        system.debug(responseresult);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseresult);
        system.assertEquals(results.get('caseStatus'), 'SUCCESS');
        system.assertEquals(results.get('commentStatus'), 'SUCCESS');
        system.assertEquals(results.get('attStatus'), 'FAILED');
    }

    static testMethod void eatonUpdateCaseSuccess(){
        Contact cct = [SELECT Id FROM Contact WHERE LastName='lname0' LIMIT 1];  
        Eaton_Integration_Variables__mdt[] variables = MDTEatonDAO.getEatonVariables('setup');
        User eatonUser = [SELECT Id FROM User WHERE Name=:variables[0].User_Name__c]; 
        string queueId = [select Id from Group where DeveloperName='Transmission'].id;

        Case cc = new CaseBuilder()
            .withRecordType('Technical Assistance')
            .withOwner(queueId)
            .withType('Powertrain Support')
            .withCategory('Transmission Diagnostics')
            .withVehicleVIN('01XTYR89SGD307132')
            .withSubject('subject')
            .withDescription('description')
            .withContact(cct.id)
            .withPaccarSerialNumber('Z2345678')    // Modified from AB1234566 2023-05-31 for Eaton validation rule
            .buildInsert();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Case/' + cc.id; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json'); 
        req.addParameter('status', 'New');
        string incoming = '{"request": {"primaryContact" : "'+ cct.id + '" ,"category" :"Transmission Diagnostics","status":"new","subject":"eaton case new","disposition":"Part Support","repair_order_num":"66013","chassis_num":"BD129400","vin_num":"1XPVDP9X5BD129400","failure_date":"04/29/2019","inservice_date":"01/01/2017","odometer_units":"miles","odometer":0,"trans_serial":"P1114084","caseNotes":[{"Note":"first one"},{"Note": "second one"}],"fileAttachments":[]}}';
        req.requestBody = Blob.valueOf(incoming);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        System.runAs(eatonUser){
            EatonRestResource.doPut();
        }
        Test.stopTest();   

        String responseresult = res.responseBody.toString();
        system.debug(responseresult);

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseresult);
        system.assertEquals(results.get('caseStatus'), 'SUCCESS');
        system.assertEquals(results.get('commentStatus'), 'SUCCESS');
        system.assertEquals(results.get('attStatus'), 'SUCCESS');

    }
    
    static testMethod void eatonUpdateCaseFailed(){
        Contact cct = [SELECT Id FROM Contact WHERE LastName='lname0' LIMIT 1];  
        Eaton_Integration_Variables__mdt[] variables = MDTEatonDAO.getEatonVariables('setup');
        User eatonUser = [SELECT Id FROM User WHERE Name=:variables[0].User_Name__c];  
        String queueId = [select Id from Group where DeveloperName='Transmission'].id;

        Case cc = new CaseBuilder()
            .withRecordType('Technical Assistance')
            .withOwner(queueId)
            .withType('Powertrain Support')
            .withCategory('Transmission Diagnostics')
            .withVehicleVIN('01XTYR89SGD307132')
            .withSubject('subject')
            .withDescription('description')
            .withContact(cct.id)
            .withPaccarSerialNumber('Z2345678')    // Modified from AB1234566 2023-05-31 for Eaton validation rule            
            .buildInsert();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Case/' + cc.id + 'X'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json'); 
        req.addParameter('status', 'New');
        string incoming = '{"request": {"primaryContact" : "'+ cct.id + '" ,"category" :"Transmission Diagnostics","status":"new","subject":"eaton case new","disposition":"Part Support","repair_order_num":"66013","chassis_num":"BD129400","vin_num":"1XPVDP9X5BD129400","failure_date":"04/29/2019","inservice_date":"01/01/2017","odometer_units":"miles","odometer":0,"trans_serial":"P1114084","caseNotes":[{"Note":"first one"},{"Note": "second one"}],"fileAttachments":[]}}';
        req.requestBody = Blob.valueOf(incoming);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        System.runAs(eatonUser){
            EatonRestResource.doPut();
        }
        Test.stopTest();   

        String responseresult = res.responseBody.toString();
        system.debug(responseresult);

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseresult);
        system.assertEquals(results.get('caseStatus'), 'FAILED');
        system.assertEquals(results.get('commentStatus'), 'FAILED');
        system.assertEquals(results.get('attStatus'), 'FAILED');
        system.assertEquals(results.get('Message'), 'INVALID CASE ID');
    }
}