/**
* @File Name : EDealerPlanningBreadthReport.cls
* @Description : Planning Breadth report in Gateway
* @Author : Vivian D. Mirador
* @Last Modified By : 
* @Last Modified On : December 11, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 11, 2024 |   | Initial Version
**/

public class EDealerPlanningBreadthReport {

    private static final String MOCK_JSON = '{\"response\":[{\"action_required\":\"No_Action_Required\",\"dealer_response_or_note\":\"\",\"grp_nbr\":\"I080\",\"loc\":\"I080\",\"item\":\"F50-2035-130\",\"current_abc\":\"D\",\"current_si\":\"Y\",\"distchan\":\"PDCUS\",\"dlrsplr_code\":\"P\",\"stock_class\":\"004G\",\"date_added_to_dif\":\"Added 05/10/21\",\"dnet\":\"335.5800\",\"current_minss\":0,\"current_mp\":0,\"current_comment\":\" \",\"sunset_date\":\"2024\",\"current_12m_dmd\":\"1.0000\",\"current_12m_hits\":1,\"abctots\":0,\"maap_loc\":\"A100\",\"item_desc\":\"LINE-#8 DISCHARGE ASSY\",\"date_of_exception\":\"2024-09-10\",\"order_number\":\"STUS330\",\"order_type\":\"ST\",\"planning_breadth_exception\":\"Manual D locked down\"}]}';
    private static final Map<String, String> MOCK_LANGUAGE_TRANSLATION = new Map<String, String>{
        'action_required'=>'ACTION REQUIRED',
        'dealer_response_or_note'=>'DEALER RESPONSE OR NOTE',
        'grp_nbr'=>'GROUP NUMBER',
        'loc'=>'LOC',
        'item'=>'ITEM',
        'current_abc'=>'CURRENT ABC',
        'current_si'=>'CURRENT SI',
        'distchan'=>'DISTCHAN',
        'dlrsplr_code'=>'DLRSPLR CODE',
        'stock_class'=>'STOCK CLASS',
        'date_added_to_dif'=>'DATE ADDED TO DIF',
        'dnet'=>'DNET',
        'current_minss'=>'CURRENT MINSS',
        'current_mp'=>'CURRENT MP',
        'current_comment'=>'CURRENT COMMENT',
        'sunset_date'=>'SUNSET DATE',
        'current_12m_dmd'=>'CURRENT 12M DMD',
        'current_12m_hits'=>'CURRENT 12M HITS',
        'abctots'=>'ABCTOTS',
        'maap_loc'=>'MAAP LOC',
        'item_desc'=>'ITEM DESC',
        'date_of_exception'=>'ORDER DATE',
        'order_number'=>'ORDER NUMBER',
        'order_type'=>'ORDER TYPE',
        'planning_breadth_exception'=>'PLANNING BREADTH EXCEPTION'
    };
    private static final Boolean returnMOCK_JSON = false;
    
    @AuraEnabled
    public static PlanningBreadthReportResponseWrapper getPlanningBreadthData(List<String> dealerCodes, String division){

        if (returnMOCK_JSON){
            PlanningBreadthReportResponseWrapper MOCK_RESPONSE = new PlanningBreadthReportResponseWrapper();
            MOCK_RESPONSE.dataJSON = MOCK_JSON;
            MOCK_RESPONSE.languageTranslation = MOCK_LANGUAGE_TRANSLATION;
            //MOCK_RESPONSE.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Planning Breadth');
            return MOCK_RESPONSE;
        }

        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('dealer_codes', dealerCodes);
        payloadMap.put('dealer_division', division);
        
        // Serialize the map to a JSON string
        String requestGetRecordPayload = JSON.serialize(payloadMap);
        System.debug('Request Payload-->: ' + requestGetRecordPayload);
        
        Map<string,object> calloutDetails = new Map<string,object>();
        // https://dealerships-api-dev.paccar.cloud/dealerships/planning-breadth-report/{proxy+}
        calloutDetails.put('endpoint', '/planning-breadth-report/dealers');
        calloutDetails.put('method', 'POST');
        calloutDetails.put('body', requestGetRecordPayload);
        calloutDetails.put('classname', 'EDealerPlanningBreadthReport');
        system.debug('calloutDetails----- '+calloutDetails);
       
        String resultData = EDealerHttpHandler.callout(calloutDetails);
        //System.debug('resultData----'+resultData);
        PlanningBreadthReportResponseWrapper response = new PlanningBreadthReportResponseWrapper();
        response.dataJSON = resultData;
        response.languageTranslation = EDealerMetadataUtility.translateColumnHeaders('Planning Breadth');
        
        //system.debug('response : '+ response);
        
        if(resultData != null) {
            return response;
        } else {
            return null;
        }
    }
    
    public class PlanningBreadthReportResponseWrapper{
        @AuraEnabled public String dataJSON;
        @AuraEnabled public map<string,string>languageTranslation;
    }

    public class HeaderCmts {
        public string Comments;
    }
    
    public class ErrorResponse {
        public String IsSuccess;
        public Integer ErrorMessagesCount;
        public List<HeaderCmts> ErrorMessages;
    }

}