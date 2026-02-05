public class EinsteinBot_RoadsideSms {

    /** Inputs */
    public class InputData {
        @InvocableVariable(required=true)
        public String driverPhone;
    }

    /** Outputs */
    public class OutputData {
        @InvocableVariable(required=true)
        public String sResult;
    }

    /** Invocable Method */
    @InvocableMethod(label='Roadside SMS')
    public static List<OutputData> roadsideSms(List<InputData> data)
    {

        System.debug('\n\n\n#KP# Roadside SMS start =====================================================================');
        System.debug('=================================================================================');
        System.debug('##KP##Roadside## Load Data for TimerId' + data[0].driverPhone);

        // clean up the phone number and make it compliant with (E164)
        String messagingPhone = data[0].driverPhone;
        messagingPhone = messagingPhone.replace('-','');
        messagingPhone = messagingPhone.replace(' ','');
        messagingPhone = messagingPhone.replace('(','');
        messagingPhone = messagingPhone.replace(')','');
        messagingPhone = messagingPhone.replace('.','');
        messagingPhone = messagingPhone.right(10);

        Timer__c timer = [
                SELECT  Id,
                        Timer_Type__c,
                        Status__c,
                        Service__c,
                        Case__c,
                        Name,
                        Follow_up_ETA__c,
                        Case__r.Driver_Phone_E164__c
                FROM Timer__c
                WHERE Case__r.Driver_Phone_E164__c = :messagingPhone
                AND Status__c = 'Ready'
                ORDER BY LastModifiedDate DESC
                LIMIT 1
        ];

        System.debug('\n\n\n##KP##Roadside## TimerId' + timer.Id);

        Service__c service = [
                SELECT  Id,
                        Payment_Method__c,
                        Status__c
                FROM Service__c WHERE Id = :timer.Service__c
        ];

        Case currentCase = [
                SELECT  Id,
                        Number_of_Active_Timers__c,
                        Status
                FROM Case WHERE Id = :timer.Case__c
        ];

        // == Close ServiceArrival TIMER ===
        timer.Status__c = 'Closed';
        update timer;
        System.debug('##KP##Roadside## Update Timer Status: ' + timer.Status__c + ' ' + timer.Id);

        //===== PAYMENT ===========
        System.debug('##KP##Roadside## Service Payment Method: ' + service.Payment_Method__c);
        if (service.Payment_Method__c == 'Customer Pay Direct'
                || service.Payment_Method__c == 'KW & PB Fleet Acct (Cust Pay)') {
            service.Status__c = 'Resolved';
            update service;
            System.debug('##KP##Roadside## Set Service Status1: Resolved');
        } else {
            service.Status__c = 'Resolved Pending Payment';
            update service;
            System.debug('##KP##Roadside## Set Service Status2: Resolved Pending Payment');
        }


        //==== Are there any other timers on case? ==================
        System.debug('##KP##Roadside## Active timers on Case: ' + currentCase.Number_of_Active_Timers__c);

        if (currentCase.Number_of_Active_Timers__c > 1) {
            // Yes.
            // Leave Case In Status that will route.....
            System.debug('##KP##Roadside## Yes. There are other timers timers.' + currentCase.Number_of_Active_Timers__c);
            System.debug('##KP##Roadside## Service: Case Status: ' + currentCase.Status);
        } else {
            // No. There are no other timers on case.
            // Are all services in the case have one of recommended statuses?
            List<Service__c> servicesForCase = [
                    SELECT
                            Id,
                            Status__c,
                            Payment_Method__c,
                            Refusal_Reason__c,
                            Reason_for_Rejection__c
                    FROM Service__c WHERE Case__c = :currentCase.Id
            ];

            Boolean isYes = true;
            List<Service__c> servicesToUpdate = new List<Service__c>();
            for (Service__c s : servicesForCase) {
                System.debug('##KP##Roadside## status is: ' + s.Status__c);

                if (s.Status__c == 'Requested') {
                    s.Status__c = 'Service Cancelled / Declined';
                    servicesToUpdate.add(s);
                }

                if (    s.Status__c != 'Service Cancelled / Declined' &&
                        s.Status__c != 'Rejected'  &&
                        s.Status__c != 'Resolved' &&
                        s.Status__c != 'Resolved Pending Payment')
                {
                    isYes = false;
                    System.debug('##KP##Roadside## Not expected service status found!');
                }
            }
            update servicesToUpdate;

            if (!isYes) {
                // 'No' path
                // There are some services that not meet the criteria
                System.debug('##KP##Roadside## Some services does not meet criteria.');

                //Is there a service in 'Requested' status then change it to 'Rejected'
/*                List<Service__c> servicesToUpdate = new List<Service__c>();
                for (Service__c s : servicesForCase) {
                    if (s.Status__c == 'Requested') {
                        s.Status__c = 'Service Cancelled / Declined';
                        servicesToUpdate.add(s);
                    }
                }
                System.debug('##KP##Roadside## Services with status "Requested" changed to Rejected:' + servicesToUpdate.size());
                update servicesToUpdate;*/

                //Is there any service in Accepted status
                Boolean isAnyAccepted = false;
                for (Service__c s : servicesForCase) {
                    if (s.Status__c == 'Accepted') {
                        isAnyAccepted = true;
                    }
                }

                if (isAnyAccepted == true) {
                    // Yes, there are services with "accepted" status
                    Boolean isWaitingForPayment = false;
                    for (Service__c s : servicesForCase) {
                        if (s.Status__c == 'Accepted') {
                            if (s.Payment_Method__c == 'Customer Pay Direct'
                                    || s.Payment_Method__c == 'KW & PB Fleet Acct (Cust Pay)') {
                                s.Status__c = 'Resolved';
                                update s;
                            } else {
                                //Waiting for payment
                                s.Status__c = 'Resolved Pending Payment';
                                update s;
                                isWaitingForPayment = true;
                            }
                        }
                        if (isWaitingForPayment) {
                            currentCase.Status = 'Resolved Pending Payment';
                        } else {
                            currentCase.Status = 'Resolved';
                        }
                        update currentCase;
                    }
                } else {
                    // 'No' path - no services with accepted status
                    // Change Case status to Resolved
                    // if no 'Accepted' services
                    currentCase.Status = 'Resolved';
                    update currentCase;
                }

            } else {
                // 'Yes' path
                // All services meet the criteria. All are in one of these statuses:
                // - Service Cancelled / Declined,
                // - Rejected,
                // - Resolved,
                // - Resolved Pending Payment
                System.debug('##KP##Roadside## ALL services MEET criteria.');

                // Are there any services that are in 'Resolved Pending Payment' in the case?

                servicesForCase = [
                        SELECT
                                Id,
                                Status__c
                        FROM Service__c WHERE Case__c = :currentCase.Id
                ];

                System.debug('##KP##Roadside## Services Size: ' + servicesForCase.size() );

                Boolean isAnyResolvedPendingPayment = false;
                for (Service__c s : servicesForCase) {
                    System.debug('##KP##Roadside## SHOW STATUSES: ' + s.Status__c );
                    if (s.Status__c == 'Resolved Pending Payment') {
                        isAnyResolvedPendingPayment = true;
                        System.debug('##KP##Roadside## FOUND Resolved Pending Payment status)');
                    }
                }

                if (isAnyResolvedPendingPayment) {
                    currentCase.Status = 'Resolved Pending Payment';
                    System.debug('##KP##Roadside## SET Case PENDING PAYMENT (Because of pending payment Services)');
                } else {
                    currentCase.Status = 'Resolved';
                    System.debug('##KP##Roadside## SET Case RESOLVED (No Pending Payment Services)');
                }
                update currentCase;
            }
        }

        // Build the output structure containing the results
        String result = ' all done';
        List<OutputData> resultOutputs = new List<OutputData>();
        OutputData resultOutput = new OutputData();
        resultOutput.sResult = result;
        resultOutputs.add(resultOutput);
        return resultOutputs;
    }
}