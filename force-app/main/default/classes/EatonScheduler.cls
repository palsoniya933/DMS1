/**
 * @author navita.anand@slalom.com
 * @created date 2019-07-05
 * @last modified 2019-07-05
 * @version 1.1
 * @description class to schedule the callout for case comments and files
 */
global class EatonScheduler implements Schedulable, Database.AllowsCallouts {
    global void execute(SchedulableContext ctx) {
        EatonCalloutScheduler.scheduleMethod();
    }
    
}