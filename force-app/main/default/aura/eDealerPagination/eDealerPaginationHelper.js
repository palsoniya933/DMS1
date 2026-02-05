({
	setData : function(component, event, helper) {
		// getting total data
        var allRecs = component.get("v.totalRecords");
        
        if($A.util.isUndefinedOrNull(allRecs)){
            return;
        }
        
        
        // this will svae the current page records
        var currentPageRecs = [];
        
        
		// getting page size
		var pageSize = component.get("v.pageSize");        
        
        if(pageSize > allRecs.length){
            pageSize = allRecs.length;
        }
        
        // getting first page data
        for(var i = 0; i< pageSize; i++){
            currentPageRecs.push(allRecs[i]);
        }
        
        var totalPages =   Math.trunc(allRecs.length / pageSize); 	
        var remainder = allRecs.length  % pageSize;   
        if(remainder > 0){
            totalPages += 1;
        }
        
        // if there is only 1 page
        if(totalPages == 0 || totalPages == 1){
            totalPages = 1;
            component.set("v.disablednext", true);
        }else{
            //if more than 1 page
            component.set("v.disablednext", false);
        }
        component.set("v.TotalPages", totalPages);
        
        // this will save all page numbers
        var allPages = [];
        for(var i = 1; i<= totalPages; i ++){
            allPages.push(i);
        }
        
        // if there is only 1 page
        if(allPages.length == 0){
            allPages.push(1);
        }
        
        
        // setting current page list
        component.set("v.PaginationList", currentPageRecs);
        component.set("v.PageNumber", 1);
        component.set("v.RecordStart", 1);
        component.set("v.RecordEnd", pageSize);
        component.set("v.allPageNumber", allPages);
        //disable previous button when page size change
        component.set("v.disabledprevious", true);
	}
})