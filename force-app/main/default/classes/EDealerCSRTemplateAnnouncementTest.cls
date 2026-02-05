@isTest
private class EDealerCSRTemplateAnnouncementTest {

    @isTest
    static void testGetTemplateDetail() {
       

        // Call the method to be tested
        Test.startTest();
        CSR_Template_Notification__mdt result = EDealerCSRTemplateAnnouncement.getTemplateDetail();
        //EDealerCSRTemplateAnnouncement.getCSRAnnouncementTranslations();
        Test.stopTest();

        // Assert the result
       // System.assertEquals(templateRecord.Id, result.Id, 'Template record Id should match');
        // Add more assertions as needed
    }
        @isTest
    static void testgetCSRAnnouncementTranslations() {

        // Call the method to be tested
        Test.startTest();
       
        EDealerCSRTemplateAnnouncement.getCSRAnnouncementTranslations();
        Test.stopTest();

        // Assert the result
       // System.assertEquals(templateRecord.Id, result.Id, 'Template record Id should match');
        // Add more assertions as needed
    }

}