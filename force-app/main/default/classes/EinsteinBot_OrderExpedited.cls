public with sharing class EinsteinBot_OrderExpedited {

    /** Inputs */
    public class CheckOrderInput {
        @InvocableVariable(required=true)
        public String sOrderNumber;
    }

    /** Outputs */
    public class CheckOrderOutput {
        @InvocableVariable(required=true)
        public String sResult;
    }

    /** Invocable Method */
    @InvocableMethod(label='Can Order be Expedited')
    public static List<CheckOrderOutput> canOrderByExpedited(List<CheckOrderInput> orderNumberInput)
    {

        String orderType = orderNumberInput[0].sOrderNumber.left(2).toUpperCase();
        List<String> canBeExpedited = new List<String>{'TD', 'TW', 'EM', 'E1', 'XE', 'EB', 'PE', 'DE', 'VP'};
        List<String> canNotBeExpedited = new List<String>{'ST', 'XS', 'S1'};
        String result = ' ';
		 String supportLink = System.Label.Ein_Order_Exp;
        if (canBeExpedited.contains(orderType)) {
            result = 'Order type ' + orderType + ' is eligible for expedite. Please submit a TCS 365 Order Support, Expedite an Order case at '+supportLink+' A Customer Service Agent will review your order and provide feedback to the best possible ship date. Thank you for your business and partnership. PACCAR Parts Customer Service.';
        } else if (canNotBeExpedited.contains(orderType)) {
            result = 'Stock order type ' + orderType + ' is not eligible for expedite. For faster lead time, please submit a TCS 365 Order Support, Modify an Order case and request conversion to a truck down or emergency order order type. Please provide customer name through the TCS case at '+supportLink +'  The Truck Down or Emergency order type will provide your customer the best possible lead time. Thank you for your business and partnership. PACCAR Parts Customer Service.';
        } else {
            result = 'Order ' + orderNumberInput[0].sOrderNumber + ' is not recognized by our automated system. Please call our Customer Service team at 800-944-0251, Option 1 for support. We are available by phone 5am-5pm PST. Thank you for your business and partnership.';
        }

        // Build the output structure containing the results
        List<CheckOrderOutput> resultOutputs = new List<CheckOrderOutput>();
        CheckOrderOutput resultOutput = new CheckOrderOutput();
        resultOutput.sResult = result;
        resultOutputs.add(resultOutput);
        return resultOutputs;
    }

}