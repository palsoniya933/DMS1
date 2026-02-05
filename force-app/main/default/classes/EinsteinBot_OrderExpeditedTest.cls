@isTest
private class EinsteinBot_OrderExpeditedTest {

    private static testMethod void testIncorrectOrderNumber() {
        List<EinsteinBot_OrderExpedited.CheckOrderInput>
                listToTest = new List<EinsteinBot_OrderExpedited.CheckOrderInput>();
        EinsteinBot_OrderExpedited.CheckOrderInput
                orderIncorrect = new EinsteinBot_OrderExpedited.CheckOrderInput();
        orderIncorrect.sOrderNumber = 'TX12345';
        listToTest.add(orderIncorrect);
        List<EinsteinBot_OrderExpedited.CheckOrderOutput>
                cou = EinsteinBot_OrderExpedited.canOrderByExpedited(listToTest);
        system.assert(cou[0].sResult.contains('Order TX12345 is not recognized'));
    }


    private static testMethod void testIfOrderCanBeExpedited() {
        List<EinsteinBot_OrderExpedited.CheckOrderInput>
                listToTest = new List<EinsteinBot_OrderExpedited.CheckOrderInput>();
        EinsteinBot_OrderExpedited.CheckOrderInput
                orderCanBeExpedited = new EinsteinBot_OrderExpedited.CheckOrderInput();
        orderCanBeExpedited.sOrderNumber = 'TD12345';
        listToTest.add(orderCanBeExpedited);
        List<EinsteinBot_OrderExpedited.CheckOrderOutput>
            cou = EinsteinBot_OrderExpedited.canOrderByExpedited(listToTest);
        system.assert(cou[0].sResult.contains('Order type TD is eligible'));
    }

    private static testMethod void testIfOrderCanNotBeExpedited() {
        List<EinsteinBot_OrderExpedited.CheckOrderInput>
                listToTest = new List<EinsteinBot_OrderExpedited.CheckOrderInput>();
        EinsteinBot_OrderExpedited.CheckOrderInput
                orderCanBeExpedited = new EinsteinBot_OrderExpedited.CheckOrderInput();
        orderCanBeExpedited.sOrderNumber = 'ST12345';
        listToTest.add(orderCanBeExpedited);
        List<EinsteinBot_OrderExpedited.CheckOrderOutput>
                cou = EinsteinBot_OrderExpedited.canOrderByExpedited(listToTest);
        system.assert(cou[0].sResult.contains('Stock order type ST is not eligible'));
    }
}