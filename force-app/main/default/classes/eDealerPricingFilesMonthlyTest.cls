@isTest
public class eDealerPricingFilesMonthlyTest {
    @isTest
    private static void fetchMonthlyPriceFilesURLs(){
        // setting mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatus('OK');
        mockResponse.setStatusCode(200); 
        mockResponse.setHeader('Content-Type', 'application/json');
        mockResponse.setBody('{"Urls":[{"Fileurl":"https://s3.us-west-2.amazonaws.com/ppd.dev.paricefile.bucket/Custom/Dealer/Monthly/A875/2023/12/DEMAND.csv?AWSAccessKeyId=ASIAT7LJPKWNZEZHHLM3&Signature=IYwNjBmEupndmZI227%2F%2BKRDLgrk%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEKv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJIMEYCIQDwzedsRJ6J4fd7eq7vTA63O3FlXwaaSOaVMtsuRq9nLQIhAKMhwTZZeODc0i2iw5IByXMLfgqol9FixveQlyOUlB2QKo8DCDQQAxoMMjczNDg4NTAwMTIzIgxcg320wSG1oXhspRUq7AIDIEeS%2B%2B5GAQXjC6kHT6nquDbYN83o80G%2BOHi4AqfbujfP5bpFeeTl8II5i3HxVl41VWC53Icxz0NUCsO1QZyy6GhnZ9dsF2mjdfV7%2BGVsDrROaJaT0lHp3S1z8lCtY9EnLxdvbgRJe8BQyzNLdRobfItVlJ22J2jmv5l%2BOO8PJjxMdad1CHfr%2BDXbCIWTHeg8JBnBDleDGSYDtKvmhunKKMXHUikh2DSrzmIBGu%2FIy0qoKdJCHcxmQvx8b5BVA%2Fi9S6%2FZr0kQ%2Bgclf6%2BBiaNIdrby4euHSN5%2FkD17k1O2DMhZU6VrYc92DHolHyd6DKXtu2Sco8kX5MDtz8u4hhs%2Fg5Mo%2BuomqS2%2FYmlKuZXo%2FGFzkrY%2BQmVueXABbU4iskjsDay2O3cY4H2XMT1N8uz93%2Foz6aYSP3IRRNRgmr%2BTufKyFCBvSO6PXbSnyWoPHJATpeP11bOMOnyOtUhSWZ5FQn1ke%2F3jFDDu8puUMOW2l6wGOpwBxxbY4%2Fdp0lthzPysqhfCsNYtlcmBwBd3brDfn2YeLPNFLJ4wgEFS9X%2F%2Fu%2FrKpU%2BFR9sgvgSpc54fUpi%2BpN%2BrMaGNXLYWGNVpO34U8Q%2FpmfdxbfeVROTQobtKlmmfAFpSxh2qauMMOukXLlL%2Ft29WRdzBZM48R8dSHUp%2B7%2Bym5RUPGP0kP8LFxEaob8dBypr2GzSE9Q0Dlk5v7lgN&Expires=1703274870"}]}');
        // setting mock apex class
        Test.setMock(HttpCalloutMock.class, new EDealerHTTPMockResponseTest(mockResponse));
        
        // calling apex class method
        Test.startTest();
        eDealerPricingFilesMonthly.fetchMonthlyPriceFilesURLs('A875','2023');
        Test.stopTest();
    }
}