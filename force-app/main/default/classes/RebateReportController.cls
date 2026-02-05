/** 
Name        : RebateReportController
Description : This is an controller for eDealer rebate report page.
Developer: Vishal Kajale
*/
public with sharing class RebateReportController {
    public String dealerCode { get; set; }
    public String downloadUrl { get; set; }    
    
    @AuraEnabled
    public static string initiateRebateReportDownload(String dealerCode) {
        try{
        string finalCsvData= calloutForRebateReport(dealerCode);
        return finalCsvData;
        }
        catch(Exception err){
            System.debug('Error--'+err.getMessage());
            System.debug('Stack Trace --'+ err.getStackTraceString());
            Throw new AuraHandledException(err.getMessage());
        }
    }
    
    public static string calloutForRebateReport(String dealerCode) {
            System.debug('dealerCode: ' + dealerCode);
            String csvResponse = getRebateReport(dealerCode);
            System.debug('csvResponse'+csvResponse);
            String finalCsvData=processAndSaveRebateData(csvResponse, dealerCode);
            return finalCsvData;
    }
    
    public static String getRebateReport(String dealerCode) {
        if (dealerCode == null) {
            throw new AuraHandledException('Error: Dealer code not found for the current user');
        }
        
        // Callout to get the rebate report data
        String dealerCodeQueryString = '?dealer_code=' + EncodingUtil.urlEncode(dealerCode, 'UTF-8');
        Map<String, String> header = new Map<String, String>();
        Map<String, Object> calloutDetails = new Map<String, Object>();
        calloutDetails.put('namedCredentials', 'callout:GatewayAWSConnection');
        calloutDetails.put('endpoint', '/dealerships/dealer-rebate-report/dealer/' + dealerCodeQueryString);
        calloutDetails.put('headers', header);
        calloutDetails.put('method', 'GET');
        calloutDetails.put('classname', 'RebateReportController');
        
        System.debug('calloutDetails: ' + calloutDetails);
        String dataString = EDealerHttpHandler.callout(calloutDetails);
        System.debug('Raw Response: ' + dataString);
        
        if (dataString != null) {
            return dataString;
        }
        throw new AuraHandledException('Error: data not imported');
    }
    
    public static String processAndSaveRebateData(String csvResponse, String dealerCode) {
        // Parse JSON input
        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(csvResponse);
        String csvData = (String) jsonData.get('csv_data');
        
        // Avoid regex methods like replaceAll and split
        csvData = csvData.replace('\r\n', '\n'); // simple replace, not regex
    
        // Split manually (safe)
        List<String> rows = new List<String>();
        while (csvData.contains('\n')) {
            Integer idx = csvData.indexOf('\n');
            rows.add(csvData.substring(0, idx));
            csvData = csvData.substring(idx + 1);
        }
        if (!String.isBlank(csvData)) rows.add(csvData); // add last line
        
        // Prepare header
        List<String> formattedRows = new List<String>{
            'Transaction ID\tDealer Invoice #\tPart Number\tPart Description\tStock Class\tUOM\tProcess Date\tDealer Group\tDealer Group Name\tDealer Code\tDealer Name\tFleet Group\tFleet Group Name\tFleet ID\tFleet Name\tDominant Channel\tDealer Invoice Line\tDealer Net (EFFNET)\tNTE Dealer Rebate (EFFPRC)\tDealer Historical Qty (365)\tAverage Dealer Cost ($)\tDealer Rebate Qty\tDealer Rebate Price\tDealer Rebate Amount\tSold Dealer Price\tDealer Ext Sales\tDealer Margin\tFleet NTE Price\tNTE Ext Sales\tNTE Margin'
        };
        
        // Process rows
        for (Integer i = 1; i < rows.size(); i++) {
            String row = rows[i].trim();
            formattedRows.add(row.replace(',', '\t')); // safe version, not regex
        }
        
        // Build final CSV
        String finalCsvData = String.join(formattedRows, '\n').replace('\t', ',');
        return finalCsvData;
    }
}