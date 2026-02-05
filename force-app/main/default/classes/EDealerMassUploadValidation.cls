public class EDealerMassUploadValidation{
   @AuraEnabled
    public static string validatePartNumber(String payload){
        PartsDetailRequestPayloadWrapper payloadFromDownload = (PartsDetailRequestPayloadWrapper) System.JSON.deserialize(payload, PartsDetailRequestPayloadWrapper.class);    
        CsrPartRequestWrapper requestPayload = new CsrPartRequestWrapper(); 
        // populate, request payload for GWCSRPartValid API
        requestPayload.DealerCd = payloadFromDownload.DealerCd;     
        requestPayload.CallingSystem = payloadFromDownload.CallingSystem;
        requestPayload.CSRType = payloadFromDownload.CSRType;
        for(PartNo partlist : payloadFromDownload.partno){
            PartNo partdetail = new PartNo();
            partdetail.PartNumber = partlist.PartNumber;  
            partdetail.PartQty = 1;
            partdetail.CompCd = partlist.CompCd; 
            requestPayload.PartNo.add(partdetail);
        }
        String requestPayloadStr = JSON.serialize(requestPayload);
        System.debug('Request Payload String for GWCSRPartValid '+requestPayloadStr);        
        Map<string,object> calloutDetails = new Map<string,object>();
        calloutDetails.put('endpoint','/sales-part/CompetitiveSalesRequest/v1/GWCSRPartValid');
        calloutDetails.put('namedCredentials','callout:GatewayApplication');
        calloutDetails.put('method','POST');
        calloutDetails.put('body',requestPayloadStr);
        calloutDetails.put('classname','EDealerCsrPartsDetailController');   
        system.debug('Callout Details: '+calloutDetails);
        String resultData = EDealerHttpHandler.callout(calloutDetails); 
        if(resultData!= null) {
           system.debug('Result Data is '+resultData); 
           return resultData;
        } else {   
           MasterDataPartsWrapper res = (MasterDataPartsWrapper)System.JSON.deserialize(resultData, MasterDataPartsWrapper.class);
           String eMsg = res.ErrorResponse.ErrorMessages[0].ErrDesc;
           return eMsg; 
        }    


    }    

	public class MasterDataPartsWrapper {       
        public Data CsrPartsDetailData;
        public ErrorResponse ErrorResponse;
    }  

	public class ErrMsg {
    	public String ErrDesc;
	}

	public class Data {
		public String DealerID;
		public List<PartNos> PartNos;
	}

	public class PartNos {
		public String ValidFlg;
		public String PartNo;
		public String PartDesc;
		public Integer PartQty;
		public String CompCd;
		public String CompName;
		public String PdcFlg;
		public String DspFlg;
		public List<ErrMsg> ErrMsg;
	}

	public class ErrorResponse {
		public String IsSuccess;
		public Integer ErrorMessagesCount;
		public List<ErrMsg> ErrorMessages;
	}

    public class PartsDetailRequestPayloadWrapper {
        public String DealerCd;
        public String CSRType;
        public String CallingSystem;
	    public List<PartNo> PartNo;
    }

	public class PartNo {
		public String PartNumber;
		public Integer PartQty;
		public String CompCd;
	}

    public class CsrPartRequestWrapper {
        public String DealerCd;
        public String CSRType;
        public String CallingSystem;
	    public List<PartNo> PartNo = new List<PartNo>();
    }
}