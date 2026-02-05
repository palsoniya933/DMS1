trigger VoiceAnnouncementTriggers on Voice_Announcement__c (after insert, after update, after delete) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Voice_Announcement__c announcement : Trigger.new) {
            DbCrudFacade.InsertAnnouncement(
                announcement.Flow__c, 
                announcement.Prompt__c
            );
        }
    } else if (Trigger.isDelete) {
        for (Voice_Announcement__c announcement : Trigger.old) {
            DbCrudFacade.DeleteAnnouncement(
                announcement.Flow__c
            );
        }
    }
}