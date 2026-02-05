({
    
    checkUserPermissions: function(component) {        
        var userDetail = component.get("v.userDetail");
        var passGroup = userDetail.passGroup;
        if(passGroup.toLowerCase().includes("sales manager")){
            component.set('v.havingSalesManagerPermission',true);
        }
        if(passGroup.toLowerCase().includes("field service")){
            component.set('v.havingFieldServicePermission',true);
        }
        if(passGroup.toLowerCase().includes("executive")){
            component.set('v.havingExecutivePermission',true);
        }
        
    }
})