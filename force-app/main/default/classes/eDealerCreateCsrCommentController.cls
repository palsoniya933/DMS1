public with sharing class eDealerCreateCsrCommentController {
    @AuraEnabled 
    public static String createCsrComment(String commentsPayload) {
        System.debug('commentspayload-----'+commentsPayload);        
        CommentWrapper wrapperInstance = (CommentWrapper)JSON.deserialize(commentspayload, CommentWrapper.class);
        System.debug('wrapperInstance-----'+wrapperInstance);
        Map<string,object> calloutDetails = new map<string,object>();
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWCSRCreateHeadCmt');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',commentsPayload);
        calloutDetails.put('classname','eDealerCreateCsrCommentController');        
        String resultData = EDealerHttpHandler.callout(calloutDetails); 
        System.debug('resultData-----:::'+resultData);        
        return resultData;
    }
    
    public class CommentWrapper {
        @AuraEnabled public String CSRNumber;
        @AuraEnabled public Integer Phase;
        @AuraEnabled public Integer LineNumber;
        @AuraEnabled public String CommentType;
        @AuraEnabled public String Comment;
        @AuraEnabled public String UserName;
        
        public CommentWrapper(String CSRNumber,Integer phase, Integer lineNumber, String commentType, String comment, String userName) {
            this.Phase = phase;
            this.LineNumber = lineNumber;
            this.CommentType = commentType;
            this.Comment = comment;
            this.UserName = userName;
            this.CSRNumber = CSRNumber;
        }
    }
    
}