public with sharing class GatewayAnnouncements {
    
    /**
* Returns all “active” Gateway_Announcement__c records that the current user
* has NOT yet read, already translated to the user’s language.
*
* Active = Start_Date__c ≤ TODAY ≤ End_Date__c.
* An announcement is considered “read” if an Announcement_Recipient__c
* exists for the same Gateway_Announcement__c and CreatedById = current user.
*
* @return List of Gateway_Announcement__c visible to the user.
*/
    @AuraEnabled
    public static List<Gateway_Announcement__c> getActiveAnnouncements() {
        
        try {
            if (!areGatewayFieldsAccessible() || !areRecipientFieldsAccessible()) {
                return new List<Gateway_Announcement__c>();
            }
            
            Id userId = UserInfo.getUserId();
            String lang = UserInfo.getLanguage();
            
            List<Gateway_Announcement__c> gatewayAnnouncements = [
                SELECT Id,
                Announcement_Verbiage__c,
                Announcement_Verbiage_French__c,
                Announcement_Verbiage_Spanish__c,
                Start_Date__c,
                End_Date__c
                FROM   Gateway_Announcement__c
                WHERE  Start_Date__c <= TODAY
                AND    End_Date__c   >= TODAY
                AND    Id NOT IN (
                    SELECT Gateway_Announcement__c
                    FROM   Announcement_Recipient__c
                    WHERE  CreatedById = :userId )
            ];
            return translateVerbiageByLanguage(gatewayAnnouncements, lang);
            
        } catch (Exception e) {
            throw new AuraHandledException('Unable to fetch active announcements – ' + e.getMessage());
        }
    }
    
    /**
* Creates one Announcement_Recipient__c record for every announcement Id supplied,
* marking those announcements as “read” for the current user.
*
* @param announcementIds  Ids of Gateway_Announcement__c to mark as read.
*/
    @AuraEnabled
    public static void markAnnouncementsAsRead(List<Id> announcementIds) {
        try{
            if (announcementIds == null || announcementIds.isEmpty() || !areRecipientFieldsAccessible()) {
                return;
            }   
            
            Id currentUserId = UserInfo.getUserId();
            
            List<Announcement_Recipient__c> existingRecs = [
                SELECT Gateway_Announcement__c
                FROM Announcement_Recipient__c
                WHERE CreatedById = :currentUserId
                AND Gateway_Announcement__c IN :announcementIds
            ];
            
            Set<Id> alreadySeen = new Set<Id>();
            for (Announcement_Recipient__c rec : existingRecs) {
                alreadySeen.add(rec.Gateway_Announcement__c);
            }
            
            List<Announcement_Recipient__c> recipientsToCreate = new List<Announcement_Recipient__c>();
            for (Id annId : announcementIds) {
                if (!alreadySeen.contains(annId)) {
                    recipientsToCreate.add(new Announcement_Recipient__c(
                        Gateway_Announcement__c = annId
                    ));
                }
            }
            
            if (!recipientsToCreate.isEmpty()) {
                insert recipientsToCreate;
            }
        }catch (Exception e) {
            throw new AuraHandledException('Unable to mark announcements as read – ' + e.getMessage());
        }
    }
    
    /**
* Fetches announcements that are either still active OR have started in the
* last 30 days, then translates their verbiage to the user’s language.
*
* @return Recent and active Gateway_Announcement__c records.
*/
    @AuraEnabled(cacheable=true)
    public static List<Gateway_Announcement__c> getRecentAndActiveAnnouncements() {
        try {
            if (!areAnnouncementFieldsAccessible()) {
                return new List<Gateway_Announcement__c>();
            }
            String userLang = UserInfo.getLanguage();
            List<Gateway_Announcement__c> announcements = fetchRecentAndActiveAnnouncements();
            return translateVerbiageByLanguage(announcements, userLang);
        } catch (Exception e) {
            return new List<Gateway_Announcement__c>();
        }
    }
    
    /**
* Helper: SOQL for announcements that started in the last 30 days and are
* still active today.
*
* @return List of Gateway_Announcement__c matching the date window.
*/
    static List<Gateway_Announcement__c> fetchRecentAndActiveAnnouncements() {
        return [
            SELECT Id, Name,
            Announcement_Verbiage__c,
            Announcement_Verbiage_French__c,
            Announcement_Verbiage_Spanish__c,
            Start_Date__c,
            End_Date__c
            FROM   Gateway_Announcement__c
            WHERE  Start_Date__c <= TODAY
            AND    End_Date__c   >= N_DAYS_AGO:30
            ORDER  BY CreatedDate DESC
        ];
    }
    
    /**
* Replaces Announcement_Verbiage__c with the language‑appropriate text for the
* supplied announcements and returns only those that have non‑blank verbiage.
*
* @param announcements List to translate in‑place.
* @param userLang      Current user’s language locale.
* @return List after translation and blank‑filtering.
*/
    static List<Gateway_Announcement__c> translateVerbiageByLanguage(
        List<Gateway_Announcement__c> announcements,
        String userLang) {
            
            List<Gateway_Announcement__c> result = new List<Gateway_Announcement__c>();
            for (Gateway_Announcement__c ann : announcements) {
                String text = resolveVerbiageForLanguage(ann, userLang);
                if (String.isBlank(text)) continue;
                ann.Announcement_Verbiage__c = text;
                result.add(ann);
            }
            return result;
        }
    
    /**
* Picks the correct language field from a single Gateway_Announcement__c.
*
* @param ann   The announcement record.
* @param lang  Language locale (e.g., fr_CA, es_MX, en_US).
* @return The chosen verbiage string (may be blank).
*/
    static String resolveVerbiageForLanguage(Gateway_Announcement__c ann, String lang) {
        if (lang == 'fr_CA') return ann.Announcement_Verbiage_French__c;
        if (lang == 'es_MX') return ann.Announcement_Verbiage_Spanish__c;
        return ann.Announcement_Verbiage__c;
    }
    
    /** Field‑level security check for all columns used by getRecentAndActiveAnnouncements. */
    private static Boolean areAnnouncementFieldsAccessible() {
        return Schema.sObjectType.Gateway_Announcement__c.fields.Id.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Name.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage_French__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage_Spanish__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Start_Date__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.End_Date__c.isAccessible();
    }
    
    /** Field‑level security check for the subset of columns used by getActiveAnnouncements. */
    private static Boolean areGatewayFieldsAccessible() {
        return Schema.sObjectType.Gateway_Announcement__c.fields.Id.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage_French__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage_Spanish__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Start_Date__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.End_Date__c.isAccessible();
    }
    
    /** Field‑level security check for monthly‑list use‑case (no Start_Date__c needed). */
    private static Boolean areMonthlyGatewayFieldsAccessible() {
        return Schema.sObjectType.Gateway_Announcement__c.fields.Id.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Name.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage_French__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.Announcement_Verbiage_Spanish__c.isAccessible() &
            Schema.sObjectType.Gateway_Announcement__c.fields.End_Date__c.isAccessible();
    }
    
    /** Field‑level security check for Announcement_Recipient__c lookups. */
    private static Boolean areRecipientFieldsAccessible() {
        return Schema.sObjectType.Announcement_Recipient__c.fields.Gateway_Announcement__c.isAccessible() &
            Schema.sObjectType.Announcement_Recipient__c.fields.CreatedById.isAccessible();
    }
}