@IsTest
public class eDealerDownloadTemplateTest {

    @IsTest static void validateDownloadTemplateId() {
        Test.startTest();
        String templateId = eDealerDownloadTemplate.getDownloadTemplateId();
        Test.stopTest();
        
       	Assert.isNotNull(templateId, 'No template got for mass upload.');
    }
    
}