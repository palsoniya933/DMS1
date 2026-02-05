/**
 Name        : eDealerPricingRebateReport
 Description : This is an JS helpers for eDealer Pricing category rebate report page.
 Developer: Nikhil Nair
*/

({    
    triggerDownload: function(csvData, dealerCode) {
        var blob = new Blob([csvData], { type: 'application/octet-stream' });
        var link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = "RebateReport_" + dealerCode + ".csv";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }


})