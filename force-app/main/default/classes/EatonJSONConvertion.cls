/**
 * @author navita.anand@slalom.com
 * @date 2019-02-05
 * @last modified 2019-03-14
 * @version 1.1
 * @description JSON file creation for Eaton Callout
 */

public class EatonJSONConvertion {
	public class EntpWarCase {
		public String DealerCode;
		public String ContactID;
		public String ContactFirstName;
		public String ContactLastName;
		public String ContactEmailAddress;
		public String PartnerCaseId;
		public String ClaimantClaim;
		public String Country;
		public String OEMNamePlate;
		public String EmergingFailureTrend;
		public String RepairOrder;
		public String ClaimStatus;
		public String ClaimType;
		public String Comments;
		public String VIN;
		public String VehicleInServiceDate;
		public String AssetSerialNumber;
		public String MileageOperatingHours;
		public String MileageOperatingHoursUOM;
		public String PaymentContact;
		public String DateReported;
		public ListOfEautoWmsWarrantyClaimNote ListOfEautoWmsWarrantyClaimNote;
		public ListOfEautoWmsWarrantyClaimAttachment ListOfEautoWmsWarrantyClaimAttachment;

		public EntpWarCase(String d, String cid, String fn, String ln, String em, 
		ID pid, String cc, String cy, String om, String ef, string ro, String cs, String ct, 
		String cm, String vn, String ve, String ast, String mo, String mu, String pc, String dr, ListOfEautoWmsWarrantyClaimNote ec, ListOfEautoWmsWarrantyClaimAttachment files ){
			DealerCode=d;
			ContactID = cid;
			ContactFirstName = fn;
			ContactLastName = ln;
			ContactEmailAddress = em;
			PartnerCaseId = pid;
			ClaimantClaim = cc;
			Country =cy;
			OEMNamePlate =om;
			EmergingFailureTrend = ef;
			RepairOrder=ro;
			ClaimStatus=cs;
			ClaimType=ct;
			Comments=cm;
			VIN=vn;
			VehicleInServiceDate=ve;
			AssetSerialNumber=ast;
			MileageOperatingHours=mo;
			MileageOperatingHoursUOM=mu;
			PaymentContact=pc;
			DateReported=dr;
			ListOfEautoWmsWarrantyClaimNote=ec;
			ListOfEautoWmsWarrantyClaimAttachment=files;
		}
	}
	public List<ListOfEntpWarCaseProcessingIO> ListOfEntpWarCaseProcessingIO;

	public class ListOfEntpWarCaseProcessingIO {
		public List<EntpWarCase> EntpWarCase;
		public ListOfEntpWarCaseProcessingIO(List<EntpWarCase> caseList){
			EntpWarCase = caseList;
		}
	}

	public class EautoWmsWarrantyClaimNote {
		public String Note;
		public Id ENTPIntegrationId;
		public String ENTPNoteCategory;
		public DateTime Created;
		public String CreatedByName;
		public EautoWmsWarrantyClaimNote(String notes, Id id, Datetime cdate, String createdBy){
			Note = notes;
			ENTPIntegrationId = id;
			Created = cdate;
			CreatedByName = createdBy;
		}
	}

	public class ListOfEautoWmsWarrantyClaimNote {
		public List<EautoWmsWarrantyClaimNote> EautoWmsWarrantyClaimNote;
		public ListOfEautoWmsWarrantyClaimNote(List<EautoWmsWarrantyClaimNote> notes){
			EautoWmsWarrantyClaimNote = notes;
		}
	}

	public class ListOfEautoWmsWarrantyClaimAttachment {
		public List<EautoWmsWarrantyClaimAttachment> EautoWmsWarrantyClaimAttachment;
		public ListOfEautoWmsWarrantyClaimAttachment(List<EautoWmsWarrantyClaimAttachment> files){
			EautoWmsWarrantyClaimAttachment = files;
		}
	}

	public class EautoWmsWarrantyClaimAttachment {
		public Id ENTPIntegrationId;
		public String ClaimFileName;
		public String ClaimFileExt;
		public Integer ClaimFileSize;
		public String ENTPComments;
		public String ClaimFileBuffer;
		public EautoWmsWarrantyClaimAttachment(Id id, String title, String ext, Integer size, String comments, String body){
			ENTPIntegrationId=id;
			ClaimFileName=title;
			ClaimFileExt = ext;
			ClaimFileSize = size;
			ENTPComments = comments;
			ClaimFileBuffer = body;
		}
	}
	
	public static EatonJSONConvertion parse(String json) {
		return (EatonJSONConvertion) System.JSON.deserialize(json, EatonJSONConvertion.class);
	}
	
	

}