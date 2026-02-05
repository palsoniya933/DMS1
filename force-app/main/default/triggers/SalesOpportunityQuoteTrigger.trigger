/**
 * @author: Chito Bulahan - Luisito.Bulahan@paccar.com
 * @created date: 2021-03-18
 * @last modified: 2021-03-18
 * @version: 1.0
 * @description: This will trigger a create or update process from a Sales Opportunity object to Quote object.
 */
trigger SalesOpportunityQuoteTrigger on Quote (before insert, after insert){
    if(Trigger.isInsert) {
        if (Trigger.isBefore) {
            // process before insert to Quote object
            Map<Id, Opportunity> opps = new Map<Id, Opportunity>();
            for(Quote record: Trigger.new) {
                opps.put(record.OpportunityId, null);
            }
            opps.putAll([SELECT Battery__c, Truck_Models__c FROM Opportunity WHERE Id = :opps.keySet()]);
            for(Quote record: Trigger.new) {
                Opportunity opp = opps.get(record.OpportunityId);
                // copy fields from opp to record as needed
                record.Battery_Model_Reference__c = opp.Battery__c;
                record.Truck_Model_Reference__c = opp.Truck_Models__c;
            }
            
        } else if (Trigger.isAfter) {
            // process after insert
        }    
                      
    }
 
}