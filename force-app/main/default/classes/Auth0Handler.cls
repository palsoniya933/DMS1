global class Auth0Handler implements Auth.RegistrationHandler {    
 global User createUser(Id portalId, Auth.UserData data) {
     System.debug(data);
     
     String sub = data.attributeMap.get('sub');
     String authUsername = data.identifier.substringAfterLast('|');
     User u = new User();
     
     try{
         u = [SELECT Id FROM User WHERE FederationIdentifier = :authUsername LIMIT 1];
         System.debug('Found Id: ' + u.Id);
         return u;
     } catch(Exception e) {
         //User does not exist
     }                    
     return u;
 }
     
 global void updateUser(Id userId, Id portalId, Auth.UserData data) {
     User u = new User(id=userId);
     System.debug('Existing Id: ' + u.Id);
 }
}