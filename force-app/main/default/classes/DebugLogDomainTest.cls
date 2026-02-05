/**
 * @author anthony.beran@slalom.com
 * @date 2019-06-02
 * @version 1.0
 * @description DebugLogDomainTest
 */
@IsTest
private class DebugLogDomainTest {

    @AuraEnabled(Cacheable=true)
    static public void auraCacheableMethod() {
        DebugLogDomain.log(new LogException('aura cacheable call test'));
    }

    @Future
    static public void futureMethod() {
        DebugLogDomain.log(new LogException('future call test'));
    }

    static public void exceptionMethod() {
        LogException ex = new LogException('exception thrown test');
        DebugLogDomain.log(ex);
        throw ex;
    }

    static testMethod void log() {
        //arrange

        //act
        Test.startTest();
        DebugLogDomain.log(new LogException('test exception'), 'data');
        Test.stopTest();

        List<Debug_Log__c> logs = [
            SELECT Message__c, Data__c
            FROM Debug_Log__c
        ];

        //assert
        System.assert(1 == logs.size());
        System.assert('test exception' == logs[0].Message__c);
        System.assert('data' == logs[0].Data__c);
    }

    static testMethod void logFutureContext() {
        //arrange

        //act
        Test.startTest();
        DebugLogDomainTest.futureMethod();
        Test.stopTest();

        List<Debug_Log__c> logs = [
            SELECT Message__c, Data__c
            FROM Debug_Log__c
        ];

        //assert
        System.assert(1 == logs.size());
        System.assert('future call test' == logs[0].Message__c);
    }

    static testMethod void logCacheableContext() {
        //arrange

        //act
        Test.startTest();
        DebugLogDomainTest.auraCacheableMethod();
        Test.stopTest();

        List<Debug_Log__c> logs = [
            SELECT Message__c, Data__c
            FROM Debug_Log__c
        ];

        //assert
        System.assert(1 == logs.size());
        System.assert('aura cacheable call test' == logs[0].Message__c);
    }

    static testMethod void logExceptionThrownContext() {
        //arrange

        //act
        Test.startTest();
        try {
            DebugLogDomainTest.exceptionMethod();
        } catch (Exception e) {
            System.assert(true, 'Expect exception to be thrown.');
        }

        Test.stopTest();

        List<Debug_Log__c> logs = [
            SELECT Message__c, Data__c
            FROM Debug_Log__c
        ];

        //assert
        System.assert(1 == logs.size());
        System.assert('exception thrown test' == logs[0].Message__c);
    }

    static testMethod void logNoState() {
        //arrange

        //act
        Test.startTest();
        DebugLogDomain.log(new LogException('test exception with no data'));
        Test.stopTest();

        List<Debug_Log__c> logs = [
            SELECT Message__c, Data__c
            FROM Debug_Log__c
        ];

        //assert
        System.assert('test exception with no data' == logs[0].Message__c);
        System.assert(null == logs[0].Data__c, 'Expect null. Got ' + logs[0].Data__c);
    }

    static testMethod void logStateClassMethod() {
        //arrange

        //act
        Test.startTest();
        DebugLogDomain.log(new LogException('test exception'), 'data', 'TestClass', 'testMethod');
        Test.stopTest();

        List<Debug_Log__c> logs = [
            SELECT Message__c, Data__c, Class__c, Method__c
            FROM Debug_Log__c
        ];

        //assert
        System.assert(1 == logs.size(), 'Expect 1 log record to be created. Got ' + logs.size());
        System.assert('test exception' == logs[0].Message__c);
        System.assert('data' == logs[0].Data__c);
        System.assert('TestClass' == logs[0].Class__c);
        System.assert('testMethod' == logs[0].Method__c);
    }

//    static testMethod void createNetworkLog() {
//        //arrange
//
//        //act
//        Test.startTest();
//        Debug_Log__c log = DebugLogDomain.createNetworkTransactionLog('500', 'request', 'response');
//        Test.stopTest();
//
//        //assert
//        System.assert('500' == log.Status__c);
//        System.assert('request' == log.Request_Body__c);
//        System.assert('response' == log.Response_Body__c);
//    }
//
//    static testMethod void logNetworkTransaction() {
//        //arrange
//
//        //act
//        Test.startTest();
//        String msg = String.format('STATUS CODE: {0}, CREDENTIAL: {1}, RESPONSE: {2}', new String[]{'500', 'request', 'response'});
//        DataLakeService.DataLakeServiceException e = new DataLakeService.DataLakeServiceException(msg);
//        DebugLogDomain.log(e);
//        Test.stopTest();
//
//        List<Debug_Log__c> logs = [
//            SELECT Message__c
//            FROM Debug_Log__c
//            WHERE Type__c = 'DataLakeServiceException'
//        ];
//
//        //assert
//        System.assert(1 == logs.size(), 'Expect 1 log record to be created. Got ' + logs.size());
////        System.assert('500' == logs[0].Status__c);
////        System.assert('request' == logs[0].Request_Body__c);
////        System.assert('response' == logs[0].Response_Body__c);
//    }
}