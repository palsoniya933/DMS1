({
    doInit: function(component, event, helper) {
        helper.getAnnouncements(component);
    },

    closeModal: function(component, event, helper) {
        component.set("v.isModalOpen", false); 
    }

})