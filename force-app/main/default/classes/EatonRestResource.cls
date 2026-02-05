/**
 * @author navita.anand@slalom.com
 * @created date 2019-04-26
 * @last modified 2019-07-21
 * @version 1.5
 * @description REST web service for Eaton to create and update cases
 */
@RestResource(urlMapping='/Case/*')
global with sharing class EatonRestResource {

    /*Class to define Response structure */
    private class caseResponse {
        public String recordID;
        public String ClaimantClaim;
        public String Message;
        public String caseStatus;
        public String commentStatus;
        public String attStatus;
        public caseResponse(String caseId, String claim, String err, String caseStatus, String commentStatus, String attStatus) {
            this.recordID = caseId;
            this.ClaimantClaim = claim;
            this.Message = err;
            this.caseStatus= caseStatus;
            this.commentStatus = commentStatus;
            this.attStatus = attStatus;
        }
    }
    global class caseDetailsParent{
        public caseDetails request;
    }
    /*Class to define the JSON structure for case, comments and attachments */
    global class caseDetails {
        public String primaryContact {get; set;}
        public String product {get; set;}
        public String category {get; set;}
        public String status{get; set;}
        public String subject {get; set;}
        public String disposition {get; set;}
        public String chassis_num {get; set;}
        public String oem {get; set;}
        public String odometer_units {get; set;}
        public String vin_num {get; set;}
        public String repair_order_num {get; set;}
        public String failure_date {get; set;}
        public Integer odometer {get; set;}
        public String inservice_date {get; set;}
        public String trans_serial {get; set;}
        
        List<caseAttachment> fileAttachments {get; set;}
        List<caseNote> caseNotes {get; set;}
    }

    /*Class to define the properties of Attachment list in JSON object*/
    private class caseAttachment {
        String fileName {get; set;}
        String description {get; set;}
        String data {get; set;}
    }

    /*Class to define the properties of Note list in JSON object */
    private class caseNote {
        String Note {get; set;}     
    }

    @HttpPut
    global static void doPut() {
        String caseId;
        Case eatonCase;
        String message;
        String caseStatus;
        String commentStatus;
        String attStatus;
        caseResponse obj;

        RestRequest req = RestContext.request;

        caseDetailsParent reqParent = (caseDetailsParent)JSON.deserialize(req.requestbody.tostring(), caseDetailsParent.class);
        caseDetails request = reqParent.request;
        system.debug('incoming request | ' + request);
        caseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);//get the case id from the request URL
        Case[] validCase = [Select id, Case_ID__c from case where id=:caseId];

        if(!String.isblank(caseId)){  
            if(validCase.size()>0){            
                eatonCase = new Case(id=caseId); //if it is an update request then create a case object with the case id
            }
            else{
                caseStatus = 'FAILED';
                commentStatus ='FAILED';
                attStatus = 'FAILED';
                obj = new caseResponse(caseId, null, 'INVALID CASE ID', caseStatus, commentStatus, attStatus);
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(obj));
                return;
            }
        }
        else{
            eatonCase = new Case();//if it is insert request then create a new case object
        }
                
            Date mydate1;
            Date mydate2;
            Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
                    .get('Technical Assistance').getRecordTypeId();
            if(request.failure_date!=null){
                mydate1 = date.parse(request.failure_date); /*format should be mm/dd/yyyy */
            }
            if(request.inservice_date!=null){
                mydate2 = date.parse(request.inservice_date); /*format should be mm/dd/yyyy */
            }
        
            Vehicle__c[] vehicle = [SELECT id from Vehicle__c where Chassis_ID__c=:request.chassis_num];//find the vehicle using the chassis number

            if(vehicle.size()>0){
                eatonCase.Vehicle__c = vehicle[0].Id;
            }
            try{ 
                eatonCase.ContactId = request.primaryContact; 
                eatonCase.Vehicle_Chassis_Number__c = request.chassis_num;
                eatonCase.Vehicle_VIN__c = request.vin_num;
                eatonCase.RecordTypeId = recTypeId;
                eatonCase.Type = 'Powertrain Support';
                eatonCase.Case_Category__c = request.category; /*Transmission Part Identification, Transmission Diagnostics */
                eatonCase.Status = request.status; /* New, In Progress, Update Required, Resolved*/
                eatonCase.Subject = request.subject;
                eatonCase.Disposition_Category__c = 'Engine Support';
                eatonCase.Disposition__c = request.disposition; 
                eatonCase.Units__c = request.odometer_units;
                eatonCase.Repair_Order__c =request.repair_order_num;        
                eatonCase.Failure_Date__c = mydate1; /*format should be mm/dd/yyyy */
                eatonCase.Odometer__c = request.odometer;
                eatonCase.In_Service_Date__c = mydate2; /*format should be mm/dd/yyyy */
                if(request.trans_serial != 'PACTRANS-GENERIC'){
                   eatonCase.Transmission_Serial_Number__c = request.trans_serial; 
                }
                eatonCase.origin ='Eaton';   
             
                upsert eatonCase; //create or update the case
                caseStatus = 'SUCCESS';
            }
            catch(System.QueryException e){//if the system cannot find the case id in Salesforce
                caseStatus ='FAILED';
                message = e.getMessage();
                system.debug('query exception');
                system.debug('object |' + eatonCase);
            }catch(Exception e){//if some other error occurs
                caseStatus ='FAILED';
                message = e.getMessage();
                system.debug('other exception');
                system.debug('object |' + eatonCase);
            }
            Id debugLogsCaseId;
            if((!caseStatus.equals('FAILED') && !String.isEmpty(caseId) && !String.isEmpty(eatonCase.Id)) || //if update successful
            (!caseStatus.equals('FAILED') && String.isEmpty(caseId) && !String.isEmpty(eatonCase.Id)) //if insert successful      
            ){ 
                Case[] updCase = [Select Case_ID__c from case where id=:eatonCase.Id];
                commentStatus = createComments(eatonCase.Id, request); //get the status on comment creation
                attStatus = createAttachments(eatonCase.Id, request);  //get the status on attachment upload
                obj = new caseResponse(eatonCase.Id, updCase[0].Case_ID__c, 'SUCCESS', caseStatus, commentStatus, attStatus);
                debugLogsCaseId = eatonCase.Id;
            }
            else if((caseStatus.equals('FAILED') && !String.isEmpty(caseId))) //if update failed
            {
                commentStatus = createComments(caseId, request); //get the status on comment creation
                attStatus = createAttachments(caseId, request);  //get the status on attachment upload
                obj = new caseResponse(caseId, validCase[0].Case_ID__c, message, caseStatus, commentStatus, attStatus);
                debugLogsCaseId = caseId;
            }
            else if(caseStatus.equals('FAILED') && String.isEmpty(caseId)){ //if insert failed
                caseStatus = 'FAILED';
                commentStatus ='FAILED';
                attStatus = 'FAILED';
                obj = new caseResponse(null, null, message, caseStatus, commentStatus, attStatus);
            }  
            RestContext.response.addHeader('Content-Type', 'application/json');   
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(obj));
           //Insert debug logs for incoming requests
           system.debug('MESSAGE |' + message);
           DebugLogDomain.log(debugLogsCaseId, UserInfo.getName(), message!=null ? message.abbreviate(100) : message, req.requestbody.tostring().abbreviate(131072), JSON.serialize(obj));
    }

    /*Method to capture comments on the case*/
    private static string createComments(String caseid, caseDetails request){
        CaseComment[] comments = new CaseComment[]{};            
            if(request.caseNotes!=null){
                for(caseNote cc : request.caseNotes){
                    if(!String.isBlank(cc.Note)){
                        comments.add(new CaseComment(
                            CommentBody = cc.Note,
                            IsPublished =true, //make the comments public
                            ParentId = caseid //associate the comment with case record
                        ));
                    }
                }
                try{
                    insert comments;   //insert the case comment  
                    return 'SUCCESS'; 
                }  
                catch(Exception e){
                    DebugLogDomain.log(e, caseid);
                    return 'FAILED';
                }          
            }
        return 'SUCCESS'; 
    }

    /*Method to upload attachments on the case */
    private static string createAttachments(String caseid, caseDetails request){
        ContentVersion[] cvs = new ContentVersion[] {};
        if(request.fileAttachments!=null){
            for (caseAttachment att : request.fileAttachments) {
                cvs.add(new ContentVersion(
                    Title = att.fileName,
                    VersionData = EncodingUtil.base64Decode(att.data),//decode the base64 information to upload the file
                    PathOnClient = att.fileName,
                    ContentLocation = 'S',
                    IsMajorVersion = true
                ));
            }            
            try{
                insert cvs; //insert the content version 
            }
            catch(Exception e){
                DebugLogDomain.log(e, caseid);
                return 'FAILED';
            }
            List<ID> cvsIds = new List<ID>();
            for(ContentVersion cv : cvs){ //get the list of content version ids for the content version records inserted above
                cvsIds.add(cv.id);
            }

            List<ID> docIds = new List<ID>();
            for(ContentVersion cv : [Select id, ContentDocumentId from ContentVersion where id IN :cvsIds]){
                docIds.add(cv.ContentDocumentId); //get the content document ids for the content version inserted above
            }

            List<ContentDocumentLink> allLinks = new List<ContentDocumentLink>();

            for(ID i : docIds){ //loop through each content document id to create a document link record
                ContentDocumentLink cd1 = new contentDocumentLink();
                cd1.ContentDocumentId = i;
                cd1.LinkedEntityId = caseid; //link the content document with the case
                cd1.ShareType = 'V';
                cd1.Visibility = 'AllUsers';
                allLinks.add(cd1);
            }
            try{
                insert allLinks; //insert the content document link to relate the content version with the case record
                return 'SUCCESS';
            }
            catch(Exception e){
                return 'FAILED';
            }
                
            }
       return 'SUCCESS';
    }
}