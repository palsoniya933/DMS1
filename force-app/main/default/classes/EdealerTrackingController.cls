/*** 
*   Name        :   edealerTrackingController
*   Description :   This is the apex class which is used for edealerTracking component
*/

public without sharing class  EdealerTrackingController {
    
    /**
*    this is the method which will check if the curent logged in user's activity is already tracked 
*    then increment the count else insert the tracking
*    Example : 
     If user is logged in edealer then we will check if the user is logged in same day then increment the count
     else increase the count and update the record.
**/
    @AuraEnabled
    public static void insertTrackingDetails(String trackingDetail){
        try{
            
            list<EDealer_Tracking__c> lstTracking =[Select id, Number_of_Visit__c ,Number_of_User__c,Tracking_Details__c,Last_Logged_In__c,Kenworth_User_Visited__c 
                                                    ,Peterbilt_User_Visited__c FROM EDealer_Tracking__c WHERE Tracking_Details__c=: trackingDetail 
                                                    and OwnerId =:UserInfo.getUserId() and Last_Logged_In__c = today];
            System.debug('trackingDetail'+trackingDetail);
            System.debug('lstTracking'+lstTracking);
            User usr = [SELECT id,Contact.Account.PACCARDivision__c,Contact.Account.Dealer_Code__c,Profile.Name, 
                        ASI_Username__c FROM user WHERE id =:UserInfo.getUserId()];
            
            // new record creation use case
            if(!lstTracking.isEmpty()){            
                lstTracking[0].Number_of_Visit__c= lstTracking[0].Number_of_Visit__c + 1;
                lstTracking[0].Last_Logged_In__c= system.now();            
                lstTracking[0].User_First_Name__c= UserInfo.getFirstName();
                lstTracking[0].User_Last_Name__c= UserInfo.getLastName();
                lstTracking[0].Username__c= UserInfo.getUserName();
                lstTracking[0].User_Primary_Dealer_Code__c=usr.contact.Account.Dealer_Code__c;
                lstTracking[0].User__c= usr.Profile.Name;
                lstTracking[0].User_Division__c= usr.Contact.Account.PACCARDivision__c;
                lstTracking[0].User_ASI__c= usr.ASI_Username__c;
                if(usr.Contact.Account.PACCARDivision__c =='K'){
                    lstTracking[0].Kenworth_User_Visited__c =lstTracking[0].Kenworth_User_Visited__c+1;
                }else if (usr.Contact.Account.PACCARDivision__c =='P'){
                    lstTracking[0].Peterbilt_User_Visited__c =lstTracking[0].Peterbilt_User_Visited__c+1;
                }
               
                update lstTracking;
            }
            
            // update the existing record use case
            else{
                EDealer_Tracking__c objTracking = new EDealer_Tracking__c();
                objTracking.Number_of_Visit__c = 1;
                
                objTracking.Tracking_Details__c = trackingDetail;
                objTracking.Last_Logged_In__c= system.now();
                objTracking.User_First_Name__c= UserInfo.getFirstName();
                objTracking.User_Last_Name__c= UserInfo.getLastName();
                objTracking.Username__c= UserInfo.getUserName();
                objTracking.User_Primary_Dealer_Code__c=usr.contact.Account.Dealer_Code__c;
                objTracking.User__c= usr.Profile.Name;
                objTracking.User_Division__c= usr.Contact.Account.PACCARDivision__c;
                if(usr.Contact.Account.PACCARDivision__c =='K'){
                    objTracking.Kenworth_User_Visited__c = 1;    
                }else if(usr.Contact.Account.PACCARDivision__c =='P')
                {
                    objTracking.Peterbilt_User_Visited__c = 1;   
                }
                objTracking.User_ASI__c= usr.ASI_Username__c;
                System.debug('objTracking.User_Division__c'+objTracking.User_Division__c);
                
                
                insert objTracking;
            }
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EdealerTrackingController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
        
    }
    
    @AuraEnabled
    public static void updateTimeSpent(String trackingDetail, Integer timeSpent){
        try{
            
            list<EDealer_Tracking__c> lstTracking =[Select id, Number_of_Visit__c ,Number_of_User__c,Tracking_Details__c,Last_Logged_In__c,Kenworth_User_Visited__c 
                                                    ,Peterbilt_User_Visited__c,Time_Spent_In_Secs__c FROM EDealer_Tracking__c WHERE Tracking_Details__c=: trackingDetail 
                                                    and OwnerId =:UserInfo.getUserId() and Last_Logged_In__c = today];
            System.debug('trackingDetail'+trackingDetail);
            System.debug('lstTracking'+lstTracking);
            User usr = [SELECT id,Contact.Account.PACCARDivision__c,Contact.Account.Dealer_Code__c,Profile.Name, 
                        ASI_Username__c FROM user WHERE id =:UserInfo.getUserId()];
            
            if(!lstTracking.isEmpty()){            
                lstTracking[0].Time_Spent_In_Secs__c= lstTracking[0].Time_Spent_In_Secs__c != null ? 
                lstTracking[0].Time_Spent_In_Secs__c + timeSpent : timeSpent;             
                update lstTracking;
            }
           
        }
        catch(Exception ex){
            EDealerLogUtils.createExceptionLog('EdealerTrackingController'
                                               ,ex.getMessage()
                                               ,ex.getStackTraceString());
            throw new AuraException(ex.getMessage());  
        }
        
    }
}