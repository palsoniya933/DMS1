trigger AgentWorkTriggers on AgentWork (before insert, after insert) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            List<VoiceCall> updates = new List<VoiceCall>();
            for (AgentWork aw : Trigger.new) {
                String voiceCallPrefix = Schema.SObjectType.VoiceCall.getKeyPrefix();
                Integer acw = aw.AfterConversationActualTime;
                if (acw == null) acw = 0;
                // Check if the Work Item Id is a Voice Call
                String workItemId = aw.WorkItemId;
                if (workItemId.startsWith(voiceCallPrefix)) {VoiceCall vc = [SELECT After_Conversation_Work_In_Seconds__c FROM VoiceCall WHERE Id = :aw.WorkItemId];vc.After_Conversation_Work_In_Seconds__c = acw;updates.add(vc);}
            }update updates;
        }
    } if (Trigger.isAfter && Trigger.isInsert) {CalabrioAgentController.calAgentsAPICall(Trigger.new);}
    
}