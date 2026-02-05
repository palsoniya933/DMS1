({
	doInit : function(component, event, helper) {
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
            //alert('disbale');
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
        
        console.log("currentPageRecs:::"+JSON.stringify(currentPageRecs));
        // setting current page list
        component.set("v.PaginationList", currentPageRecs);
        component.set("v.PageNumber", 1);
        component.set("v.RecordStart", 1);
        component.set("v.RecordEnd", pageSize);
        component.set("v.allPageNumber", allPages);
        //disable previous button when page size change
        component.set("v.disabledprevious", true);
	},
    
    handleNext: function(component, event, helper) {
        // this will svae the current page records
        var currentPageRecs = [];
        
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        
        // start index calc
        var startindex = pageNumber * pageSize;
        var endIndex = startindex + parseInt(pageSize);
        
        // getting total data
        var allRecs = component.get("v.totalRecords");
        
        if(endIndex > allRecs.length){
            endIndex = allRecs.length;
        }
        
        // getting first page data
        for(var i = startindex; i< endIndex; i++){
            currentPageRecs.push(allRecs[i]);
        }
        
        component.set("v.PaginationList", currentPageRecs);
        pageNumber++;
        component.set("v.PageNumber", pageNumber);    
        
        if( pageNumber == 1){
            component.set("v.disabledprevious",true);
        }
        else{
            component.set("v.disabledprevious",false);
        }
        
        // disable next button
        if( pageNumber == component.get("v.TotalPages")){
             component.set("v.disablednext",true);
        }
        else{
            component.set("v.disablednext",false);
        }
        
        component.set("v.RecordStart", (pageSize * (pageNumber -1 ))+1);
        if(allRecs.length < (pageSize * pageNumber)){
            component.set("v.RecordEnd", allRecs.length);
        }else{
            component.set("v.RecordEnd", pageSize * pageNumber);
        }
        
    },
    
    handlePrev: function(component, event, helper) {
        // this will svae the current page records
        var currentPageRecs = [];
        
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        pageNumber--;
        
        // start index calc
        var startindex = (pageNumber - 1) * pageSize;
        if(startindex < 0 ){
            startindex = 0;
        }
        var endIndex = startindex + parseInt(pageSize);
        
        // getting total data
        var allRecs = component.get("v.totalRecords");
        
        // getting first page data
        for(var i = startindex; i< endIndex; i++){
            currentPageRecs.push(allRecs[i]);
        }
        
        component.set("v.PaginationList", currentPageRecs);
        component.set("v.PageNumber", pageNumber);   
        if( pageNumber == 1){
            component.set("v.disabledprevious",true);
        }
        else{
            component.set("v.disabledprevious",false);
        }
        
        // disable next button
        if( pageNumber == component.get("v.TotalPages")){
             component.set("v.disablednext",true);
        }
        else{
            component.set("v.disablednext",false);
        }
        
        component.set("v.RecordStart",(pageSize * (pageNumber -1 ))+1);
        component.set("v.RecordEnd", pageSize * pageNumber);
        
    },
    
    handlePageNumChange : function(component, event, helper) {
        // this will svae the current page records
        var currentPageRecs = [];
        
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");       
        
        // start index calc
        var startindex = (pageNumber - 1) * pageSize;
        if(startindex < 0 ){
            startindex = 0;
        }
        var endIndex = startindex + parseInt(pageSize);
        
       
        
        // getting total data
        var allRecs = component.get("v.totalRecords");
        
         if(endIndex > allRecs.length){
            endIndex = allRecs.length;
        }
        
        // getting first page data
        for(var i = startindex; i< endIndex; i++){
            currentPageRecs.push(allRecs[i]);
        }
        
        component.set("v.PaginationList", currentPageRecs);       
        component.set("v.RecordStart", (pageSize * (pageNumber -1 ))+1);
        if(allRecs.length < (pageSize * pageNumber)){
            component.set("v.RecordEnd", allRecs.length);
        }else{
            component.set("v.RecordEnd", pageSize * pageNumber);
        }
        
        // disable next button
        if( pageNumber == component.get("v.TotalPages")){
             component.set("v.disablednext",true);
        }
        else{
            component.set("v.disablednext",false);
        }
        
        
        // disable previous button
        if( pageNumber == 1){
             component.set("v.disabledprevious",true);
        }
        else{
            component.set("v.disabledprevious",false);
        }
        
    }
    
    
})