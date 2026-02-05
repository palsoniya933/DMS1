({
    getAnnouncements: function(component) {
        var action = component.get("c.getActiveAnnouncements");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result && result.length > 0) {
                    console.log('result - getAnnouncements : ' + result);
                    this.handleSuccessfulFetch(component, result);
                }
            } else {
                this.handleFetchError(response);
            }
            component.set("v.isLoading", false);
        });
        $A.enqueueAction(action);
    },


    handleSuccessfulFetch: function(component, announcements) {
        component.set("v.announcements", announcements);
        component.set("v.isModalOpen", true);

        var idsToMark = announcements.map(function(ann) {
            return ann.Id;
        });

        if (idsToMark.length > 0) {
            this.markAnnouncementsAsRead(component, idsToMark);
        }
    },
	
	
	markAnnouncementsAsRead: function(component, announcementIds) {
        var markAction = component.get("c.markAnnouncementsAsRead");
        markAction.setParams({ announcementIds: announcementIds });

        markAction.setCallback(this, function(markResponse) {
            if (markResponse.getState() !== "SUCCESS") {
                console.error("Error marking announcements as read: ", markResponse.getError());
            }
        });

        $A.enqueueAction(markAction);
    },

	
    handleFetchError: function(response) {
        console.error("Error fetching announcements: ", response.getError());
    }
})