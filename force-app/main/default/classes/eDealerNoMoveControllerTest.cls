@isTest
public class eDealerNoMoveControllerTest {

    // Mock class to simulate HTTP callout
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');

            // Sample JSON response based on the updated structure
            String jsonResponse = '{'
                + '"dealers": ['
                + '{'
                + '"total_inventory": 14000,'
                + '"total_inventory_no_move_sugg": 7000,'
                + '"total_inventory_no_move_not_sugg": 7000,'
                + '"total_inventory_no_move_sugg_percentage": 50.0,'
                + '"total_inventory_no_move_not_sugg_percentage": 50.0,'
                + '"total_percentage": 10,'
                + '"total_pdc_no_move_sugg_inventory": 3200,'
                + '"total_dsp_no_move_sugg_inventory": 4200,'
                + '"total_pdc_no_move_not_sugg_inventory": 2200,'
                + '"total_dsp_no_move_not_sugg_inventory": 1800,'
                + '"total_pdc": 5400,'
                + '"total_dsp": 6000,'
                + '"loc": "I080"'
                + '}'
                + '],'
                + '"total": {'
                + '"total_inventory": 14000,'
                + '"total_inventory_no_move_sugg": 7000,'
                + '"total_inventory_no_move_not_sugg": 7000,'
                + '"total_inventory_no_move_sugg_percentage": 50.0,'
                + '"total_inventory_no_move_not_sugg_percentage": 50.0,'
                + '"total_percentage": 10,'
                + '"total_pdc_no_move_sugg_inventory": 3200,'
                + '"total_dsp_no_move_sugg_inventory": 4200,'
                + '"total_pdc_no_move_not_sugg_inventory": 2200,'
                + '"total_dsp_no_move_not_sugg_inventory": 1800,'
                + '"total_pdc": 5400,'
                + '"total_dsp": 6000'
                + '}'
                + '}';

            res.setBody(jsonResponse);
            return res;
        }
    }

    @isTest
    static void testGetNoMoveData() {
        // Set the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Define test input parameters
        List<String> dealerCodes = new List<String>{'I080'};
        String category = 'nomove';

        // Call the method to be tested
        eDealerNoMoveController.NoMoveDataWrapper result = eDealerNoMoveController.getNoMoveData(dealerCodes, category);

        // Verify the results
        System.assertNotEquals(null, result, 'Expected a non-null response.');
        
        // Verify total inventory
        System.assertNotEquals(null, result.total, 'Expected total inventory to be populated.');
        System.assertEquals(14000, result.total.total_inventory, 'Total inventory does not match.');
        System.assertEquals(7000, result.total.total_inventory_no_move_sugg, 'Total suggested inventory does not match.');
        
        // Verify dealers inventory
        System.assertNotEquals(null, result.dealers, 'Expected dealers list to be populated.');
        System.assertEquals(1, result.dealers.size(), 'Expected one dealer in the list.');
        
        eDealerNoMoveController.DealerInventory dealer = result.dealers[0];
        System.assertEquals(14000, dealer.total_inventory, 'Dealer total inventory does not match.');
        System.assertEquals('I080', dealer.loc, 'Dealer location does not match.');
    }
}