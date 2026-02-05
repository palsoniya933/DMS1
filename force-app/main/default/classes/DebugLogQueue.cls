/**
 * @author anthony.beran@slalom.com
 * @date 2019-07-17
 * @version 1.0
 * @description DebugLogQueue
 */

public with sharing class DebugLogQueue implements Queueable {
    public List<Log_Event__e> logEvents;

    public DebugLogQueue(List<Log_Event__e> logEvents) {
        this.logEvents = logEvents;
    }

    public void execute(QueueableContext context) {
        DebugLogDomain.publishLog(this.logEvents);
    }
}