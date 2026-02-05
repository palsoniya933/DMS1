/**
 * @author anthony.beran@slalom.com
 * @date 2019-03-06
 * @version 1.0
 * @description EatonWebservice
 */
global class EatonWebservice {

//    Product Field = we can Ignore , need further discussion
//    Case -> Type  = Category
//    Disposition :-  Case Resolution
//    Status = Status
//    Subject = Subject
//    ChassisNum =  Chassis Num in the Vehicle object   / discuss if we should have independent field on Case
//    Odometer  = Odometer /Mileage on Case
//    OEM = Lookup from Vehicle / discuss if we should have independent field on Case
//    VIN = Lookup from Vehicle / discuss if we should have independent field on Case
//    Repair Order Number = Repair Order Number on Case    (Check with Priyanka  if Customer Order Num and Repair Order Num are same )
//        In Service Date = In Service Date
//        Transmission Serial Number =   Transmission Serial Number
//    Failure Date =  failure date , Truck Down Date --- check with priyanka
    webService static void createCase(String category, String resolution, String status, String subject, Integer odometer, Date inServiceDate, String transmissionSerialNumber) {
        //TODO: any field validation needed?
        //TODO: will this only be a single case or can it be a List?
        //TODO: this logic should be moved to a separate class that can be tested
        //TODO: not sure what field Category maps to

        Case c = new Case(
            //Resolution__c = resolution,
            Status = status,
            Subject = subject,
            Odometer__c = odometer,
            In_Service_Date__c = inServiceDate,
            Transmission_Serial_Number__c = transmissionSerialNumber,
            origin ='Eaton',
            Type = category
        );

        try {
            insert c;
            System.debug('case inserted');
            System.debug(c.Id);
        } catch(Exception e) {
            System.debug(e.getMessage());
            //TODO: log the error
            //TODO: what do we return?
        }
    }
}