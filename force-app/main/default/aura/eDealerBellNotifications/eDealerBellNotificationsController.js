({
    doInit: function(component, event, helper) {
        window.addEventListener('click', $A.getCallback(function(event) {
            const popup = component.find('popupContainer');
            const popupElement = popup ? popup.getElement() : null;

            if (component.get("v.showPopup") && popupElement && !popupElement.contains(event.target)) {
                const bellIcon = component.find("bellIcon");
                if (!bellIcon || !bellIcon.getElement().contains(event.target)) {
                    component.set("v.showPopup", false);
                }
            }
        }));
    },

    togglePopup: function(component, event, helper) {
        const showPopup = component.get("v.showPopup");
        var current = component.get("v.showPopup");
        component.set("v.showPopup", !current);

        if (!showPopup) {
            component.set("v.isLoading", true);
            var action = component.get("c.getRecentAndActiveAnnouncements");

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    component.set("v.notifications", data);
                    component.set("v.showPopup", true);
                } else {
                    console.error("Error fetching notifications:", response.getError());
                }
                component.set("v.isLoading", false); 
            });

            $A.enqueueAction(action);
        }

        component.set("v.showPopup", !showPopup);
    }

})