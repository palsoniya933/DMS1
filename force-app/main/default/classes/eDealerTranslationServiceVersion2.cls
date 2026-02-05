public class eDealerTranslationServiceVersion2 {
	
    public static Map<String,ColumnDetails> getTableDetailsInLoggedInUserLanguage(String tableColumns){
        system.debug('tableColumns:::'+tableColumns);
        Map<String,ColumnDetails> ColumnDetailsByColumnAPIName=new Map<String,ColumnDetails>();
		List<ColumnDetails> obj = (List<ColumnDetails>)JSON.deserialize(tableColumns,List<ColumnDetails>.class);
        for(ColumnDetails cd:obj){
            ColumnDetailsByColumnAPIName.put(cd.columnAPIName,cd);
        }
        system.debug('ColumnDetailsByColumnAPIName:::'+JSON.serializePretty(ColumnDetailsByColumnAPIName));
        return ColumnDetailsByColumnAPIName;
    }
    
    public class ColumnDetails{
       @AuraEnabled public String columnAPIName;
       @AuraEnabled public String label;
       @AuraEnabled public String order;
       @AuraEnabled public String datatype;
    }
}