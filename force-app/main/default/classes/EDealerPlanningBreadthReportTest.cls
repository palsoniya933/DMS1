/**
* @File Name : EDealerPlanningBreadthReportTest.cls
* @Description : Planning Breadth test class
* @Author : Vivian D. Mirador
* @Last Modified By :
* @Last Modified On : December 19, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 19, 2024 |   | Initial Version
**/
@isTest
public class EDealerPlanningBreadthReportTest {
    @isTest
    private static void validategetPlanningBreadthData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
		mockResponse.setBody('{"response":[{"action_required":"No_Action_Required","dealer_response_or_note":"","grp_nbr":"I080","loc":"I080","item":"F50-2035-130","current_abc":"D","current_si":"Y","distchan":"PDCUS","dlrsplr_code":"P","stock_class":"004G","date_added_to_dif":"Added 05/10/21","dnet":"335.5800","current_minss":0,"current_mp":0,"current_comment":"","sunset_date":"2024","current_12m_dmd":"1.0000","current_12m_hits":1,"abctots":0,"maap_loc":"A100","item_desc":"LINE-#8 DISCHARGE ASSY","date_of_exception":"2024-09-10","order_number":"STUS330","order_type":"ST","planning_breadth_exception":"Manual D locked down"}, {"action_required":"No_Action_Required","dealer_response_or_note":"","grp_nbr":"I080","loc":"I080","item":"F50-2035-130","current_abc":"D","current_si":"Y","distchan":"PDCUS","dlrsplr_code":"P","stock_class":"004G","date_added_to_dif":"Added 05/10/21","dnet":"335.5800","current_minss":0,"current_mp":0,"current_comment":"","sunset_date":"2024","current_12m_dmd":"1.0000","current_12m_hits":1,"abctots":0,"maap_loc":"A100","item_desc":"LINE-#8 DISCHARGE ASSY","date_of_exception":"2024-09-10","order_number":"STUS330","order_type":"ST","planning_breadth_exception":"Manual D locked down"}]}');

        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();
        // calling apex class method
        EDealerPlanningBreadthReport.PlanningBreadthReportResponseWrapper resWrrap = EDealerPlanningBreadthReport.getPlanningBreadthData(new List<String>{'T650'},'KW');
        system.debug('resWrrap :' + resWrrap);
        Test.stopTest(); 
    }
}