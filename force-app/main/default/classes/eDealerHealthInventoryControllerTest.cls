@isTest
public class eDealerHealthInventoryControllerTest {
    
    
    // Inner class to implement the HttpCalloutMock interface
    class HttpCalloutMockImpl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response based on the request
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(200);
            response.setBody('{"dealers":[{"total_inventory":14000,"total_inventory_sugg":7000,"total_inventory_not_sugg":7000,"total_inventory_sugg_percentage":50.0,"total_inventory_not_sugg_percentage":50.0,"total_percentage":10,"total_pdc_sugg":3200,"total_dsp_sugg":4200,"total_pdc_not_sugg":2200,"total_dsp_not_sugg":1800,"total_pdc":5400,"total_dsp":6000,"loc":"I080"}],"total":{"total_inventory":14000,"total_inventory_sugg":7000,"total_inventory_not_sugg":7000,"total_inventory_sugg_percentage":50.0,"total_inventory_not_sugg_percentage":50.0,"total_percentage":10,"total_pdc_sugg":3200,"total_dsp_sugg":4200,"total_pdc_not_sugg":2200,"total_dsp_not_sugg":1800,"total_pdc":5400,"total_dsp":6000}}');
            return response;
        }
    }

    @isTest
    static void testGetHealthInventoryData() {
        // Set up the mock callout
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());

        // Prepare test inputs
        String dealerCode = 'D001';
        String division = 'P';
        List<String> selectedLocation = new List<String>{'A001', 'B001'};

        // Call the method under test
            eDealerHealthInventoryController.InventoryDataWrapper response = eDealerHealthInventoryController.getHealthInventoryData(selectedLocation, division);

        /**
        // Assertions to validate the response
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertNotEquals(null, response.healthInventory, 'Health Inventory should not be null');
        System.assertEquals('Sample Inventory', response.healthInventory.inventory, 'Inventory should match the mock data');
        System.assertEquals(75.0, response.healthInventory.percentage, 'Percentage should match the mock data');
        System.assertEquals('D001', response.dealerInventory[0].dealerCode, 'First dealer code should match the mock data');
        System.assertEquals(80.0, response.dealerInventory[0].percentage, 'First dealer percentage should match the mock data');
        **/
        
        Test.stopTest();
    }

    
}