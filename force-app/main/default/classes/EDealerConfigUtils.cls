public class EDealerConfigUtils {

    public static eDealer_Config__mdt getConfigByDeveloperName(String developerName){
        system.debug('developerName---'+developerName);
        //Get EDealer Config Data
        eDealer_Config__mdt edealerConfig = new eDealer_Config__mdt();
        if( Schema.sObjectType.eDealer_Config__mdt.fields.Long_Value__c.isAccessible()
           && Schema.sObjectType.eDealer_Config__mdt.fields.DeveloperName.isAccessible()
           && Schema.sObjectType.eDealer_Config__mdt.fields.Value__c.isAccessible()
          ){
              edealerConfig = [SELECT Id,DeveloperName, Long_Value__c,Value__c FROM eDealer_Config__mdt WHERE DeveloperName =:developerName];
          }        
        return edealerConfig;
    }
}