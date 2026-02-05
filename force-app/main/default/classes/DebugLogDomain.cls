/**
 * @author anthony.beran@slalom.com
 * @date 2019-06-02
 * @version 1.1
 * @description DebugLogDomain - domain class for Debug_Log__c object
 */

public with sharing class DebugLogDomain {
    public static Boolean overrideQueuing = false;

    public class Log {
        public Exception e;
        public String state;
        public String className;
        public String methodName;
        String caseId;
        String user; 
        String status;
        String request;
        String response;

        public Log(Exception e, String state, String className, String methodName) {
            this.e = e;
            this.state = state;
            this.className = className;
            this.methodName = methodName;
        }
        public Log(Id caseId, String user, String status, String request, String response) {
            this.caseId = caseId;
            this.user = user;
            this.status = status;
            this.request = request;
            this.response = response;
        }    
    }

    /**
     * @description Insert new debug log record based on Exception e
     *
     * @param e
     */
    public static void log(Exception e) {
        DebugLogDomain.queueLog(e, '', '', '');
    }

    /**
     * @description Insert new debug log record with state data
     *
     * @param e
     * @param state
     */
    public static void log(Exception e, String state) {
        DebugLogDomain.queueLog(e, state, '', '');
    }

    /**
     * @description Insert new debug log record with state data, class and method name
     *
     * @param e Apex exception class instance
     * @param state the data state at the point of the exception
     * @param className the class where the exception happened
     * @param methodName the method where the exception happened
     */
    public static void log(Exception e, String state, String className, String methodName) {
        DebugLogDomain.queueLog(e, state, className, methodName);
    }
    /**
     * @description create and inserts new debug log record for Eaton Integration.
     */
    public static void log(Id caseId, String user, String status, String request, String response) {
        DebugLogDomain.queueLog(caseId, user, status, request, response);
    }


    /**
     * @description Inserts list of logs
     *
     * @param logs
     */
    public static void log(List<DebugLogDomain.Log> logs) {
        DebugLogDomain.queueLog(logs);
    }

    /**
     * @description returns single Log object that can be used with queueLog. Generally used when logging within a loop to avoid DML governor limits
     *
     * @param e
     * @param state
     * @param className
     * @param methodName
     *
     * @return DebugLogDomain.Log
     */
    public static DebugLogDomain.Log createLog(Exception e, String state, String className, String methodName) {
        return new Log(e, state, className, methodName);
    }

    
    /**
     * @description proxy method for single log events to be pushed to queueLog List
     *
     * @param e
     * @param state
     * @param className
     * @param methodName
     */
    private static void queueLog(Exception e, String state, String className, String methodName) {
        DebugLogDomain.queueLog(new List<DebugLogDomain.Log>{new DebugLogDomain.Log(e, state, className, methodName)});
    }

    private static void queueLog(Id caseId, String user, String status, String request, String response) {
        DebugLogDomain.queueLog(new List<DebugLogDomain.Log>{new DebugLogDomain.Log(caseId, user, status, request, response)});
    }

    /**
     * @description Publishes a new Log Event platform event. Either will publish via a Queue to move the DML operation into a separate context to avoid various mixed DML or rollback DML exceptions. If called from a Queueable context will directly publish instead to avoid hitting the queue child queue governor limit of 1.
     *
     * @param className
     * @param methodName
     * @param e
     * @param state
     */
    private static void queueLog(List<DebugLogDomain.Log> logs) {
        List<Log_Event__e> logEvents = new List<Log_Event__e>();

        for ( DebugLogDomain.Log log : logs ) {
            logEvents.add(new Log_Event__e(
                Class__c = log.className,
                Method__c = log.methodName,
                Message__c = null != log.e ? log.e.getMessage().left(131072): '',
                Stacktrace__c = null != log.e ? log.e.getStackTraceString().left(131072): '',
                Line_Number__c = null != log.e ? log.e.getLineNumber() : null,
                Cause__c = null != log.e ? null != log.e.getCause() ? log.e.getCause().getMessage().left(131072) : '' : '',
                Type__c = null != log.e ? log.e.getTypeName() : '',
                Data__c = null != log.state ? log.state.left(131072) :'',
                Case_Id__c = log.caseId,
                Created_By__c = log.user,
                Status__c = log.status,
                Request_Body__c = log.request,
                Response_Body__c = log.response
            ));
        }

        if ( true == System.isQueueable() || true == DebugLogDomain.overrideQueuing) {
            //since we don't want to hit the child queue limit - just publish instead
            DebugLogDomain.publishLog(logEvents);
        } else {
            System.enqueueJob(new DebugLogQueue(logEvents));
        }
    }

    /**
     * @description Returns new debug log record based on Exception e
     *
     * @param e
     *
     * @return Debug_Log__c
     */
    public static void publishLog(List<Log_Event__e> logs) {

        //log any publishing errors
        List<Database.SaveResult> results = EventBus.publish(logs);

        Integer i = 0;
        for ( Database.SaveResult result : results ) {
            if ( false == result.isSuccess() ) {
                List<Debug_Log__c> debugLogs = new List<Debug_Log__c>();

                for(Database.Error err : result.getErrors()) {
                    debugLogs.add(new Debug_Log__c(
                        Class__c = 'DebugLogDomain',
                        Method__c = 'publishLog',
                        Status__c = String.valueOf(err.getStatusCode()),
                        Message__c = err.getMessage(),
                        Data__c = JSON.serialize(logs[i])
                    ));
                }

                if ( !debugLogs.isEmpty() ) {
                    insert debugLogs;
                }
            }
            i++;
        }
    }

    public static void insertLogs(List<Log_Event__e> logs) {
        List<Debug_Log__c> debugLogs = new List<Debug_Log__c>();

        for ( Log_Event__e log : logs ) {
            debugLogs.add( new Debug_Log__c(
                Class__c = log.Class__c,
                Method__c = log.Method__c,
                Message__c = log.Message__c,
                Stacktrace__c = log.Stacktrace__c,
                Line_Number__c = log.Line_Number__c,
                Cause__c = log.Cause__c,
                Data__c = log.Data__c,
                Type__c = log.Type__c,
                Case_Id__c = log.Case_Id__c,
                Created_By__c = log.Created_By__c,
                Status__c = log.Status__c,
                Request_Body__c = log.Request_Body__c,
                Response_Body__c = log.Response_Body__c
            ));
        }

        if ( !debugLogs.isEmpty() ) {
            insert debugLogs;
        }
    }
    
}