public class eDealerReportFilter {
    @auraEnabled
    public static map<string,string> translateReportFilterField(string reportName){
        return EDealerMetadataUtility.translateReportFilterField(reportName);
    }
}