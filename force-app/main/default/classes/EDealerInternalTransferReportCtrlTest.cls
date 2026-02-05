@isTest
public class EDealerInternalTransferReportCtrlTest {
    
    @isTest
    private static void validateFetchAWSInternalTransferReportData(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        // mockResponse.setBody('');
        mockResponse.setBody('{"response": [{"division": "KW","groupCode":"0997","Toloc": ["A878","A879"],"Fromloc":["A876","A875"], "offSet":10,"recLimit":10}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        Test.startTest();  
        List<String> lstFromLocation=new List<String>();
        lstFromLocation.add('A876');
        lstFromLocation.add('A875');
        
        List<string> lstToLocation=new List<String>();
        lstToLocation.add('A878');
        EDealerInternalTransferReportController.InternalWrapper objInternalWrapper = new EDealerInternalTransferReportController.InternalWrapper();
        
        objInternalWrapper.dealer_division ='k';
        objInternalWrapper.field ='Part_Number';
        objInternalWrapper.operator ='Equals to';
        objInternalWrapper.value ='4373989CUM';
        objInternalWrapper.from_loc = lstFromLocation;
        objInternalWrapper.to_loc= lstToLocation;
        
        // calling apex class method
        /*EDealerInternalTransferReportController.fetchAWSInternalTransferReportData(JSON.serialize(objInternalWrapper));
        
        objInternalWrapper.field ='';
        objInternalWrapper.operator ='';
        objInternalWrapper.value ='';*/
        
        // calling apex class method
        EDealerInternalTransferReportController.fetchAWSInternalTransferReportData(JSON.serialize(objInternalWrapper));
        
        List<EDealerInternalTransferReportController.FilterWrapper> lstresponse=new List<EDealerInternalTransferReportController.FilterWrapper>();
        
        EDealerInternalTransferReportController.FilterWrapper objFilterWrapper =new EDealerInternalTransferReportController.FilterWrapper();
        objFilterWrapper.fieldName='test';
        objFilterWrapper.fieldOperator='test1';
        objFilterWrapper.fieldValue='A123';
        
        EDealerInternalTransferReportController.FilterWrapper objFilterWrapper1 =new EDealerInternalTransferReportController.FilterWrapper();
        objFilterWrapper1.fieldName='test';
        objFilterWrapper1.fieldOperator='test1';
        objFilterWrapper1.fieldValue='A123';
        lstresponse.add(objFilterWrapper);
        lstresponse.add(objFilterWrapper1);
        string strEdealerWrap = JSON.serialize(lstresponse);
        
        EDealerInternalTransferReportController.fetchFilteredData('KW','0997',lstFromLocation,lstToLocation,10,10,strEdealerWrap); 
        Test.stopTest();       
    }
    
    @isTest
    private static void wrapperData(){
        
        List<EDealerInternalTransferReportController.InternalTransferWrapper> lstresponse=new List<EDealerInternalTransferReportController.InternalTransferWrapper>();
        EDealerInternalTransferReportController.InternalTransferWrapper objInternal=new EDealerInternalTransferReportController.InternalTransferWrapper();
        objInternal.FROM_12_Mth_Dmd=2;
        objInternal.FROM_12_Mth_Hits=3;
        objInternal.from_abc='';
        objInternal.from_dealernet=5;
        objInternal.from_distchan='';
        objInternal.from_loc='A876';
        objInternal.from_ohoo=1;
        objInternal.grp_nbr='0997';
        objInternal.oh=3;
        objInternal.Opportunity_Qty=7;
        objInternal.Part_Number='';
        objInternal.TO_12_Mth_Dmd=1;
        objInternal.TO_12_Mth_Hits=5;
        objInternal.to_abc='';
        objInternal.to_distchan='';
        objInternal.to_loc='A888';
        objInternal.to_ohoo=2;
        objInternal.Transfer_Qty=12;
        objInternal.Transfer_Value=5;
        lstresponse.add(objInternal);
        
        EDealerInternalTransferReportController.InternalTransferResponseWrapper objTrans=new EDealerInternalTransferReportController.InternalTransferResponseWrapper();
        objTrans.error='Unknown Error';
        objTrans.response=lstresponse;
        
        
        EDealerInternalTransferReportController.FilterWrapper objFilterWrapper =new EDealerInternalTransferReportController.FilterWrapper();
        objFilterWrapper.fieldName='test';
        objFilterWrapper.fieldOperator='test1';
        objFilterWrapper.fieldValue='A123';
    }
}