({
	createDoughnutGraph : function(cmp, temp) {
        
        var dummyLabels = ['Approvals', 'On Hold', 'Rejections'];
        var dummyData = [58, 20, 22];
        
        var dummyPercentages = [];
        //calculate percentages
        var total  = 0;
        for(var num in dummyData){
            total += dummyData[num];
        }
        
        for(var num in dummyData){
            var percent = (dummyData[num] * 100)/total;
            dummyPercentages.push(percent);
        }
        
        cmp.set("v.dummyLabelsList", dummyLabels);
        cmp.set("v.dummyPercentageList", dummyPercentages);
        
                
	}
})