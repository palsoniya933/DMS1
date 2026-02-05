public class EinsteinBot_GetArticleByTitle {

    /** Inputs */
    public class KnowledgeSearchInput{
        @InvocableVariable(required=true)
        public String sArticleTitle;
    }

    /** Outputs */
    public class KnowledgeSearchOutput{
        @InvocableVariable(required=true)
        public String sSearchResult;
    }

    /** Invocable Method */
    @InvocableMethod(label='Get Article by Title')
    public static List<KnowledgeSearchOutput> searchKnowledge(List<KnowledgeSearchInput> knowledgeSearchInput)
    {
        String sArticleBaseUrl = getCommunityArticleBaseUrl();
        String sKeyword = escapeSosl(knowledgeSearchInput[0].sArticleTitle);

        // Build the SOSL query
        String sQuery = 'FIND \'' + sKeyword
               + '\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, Title, UrlName WHERE  PublishStatus = \'Online\' AND Language = \'en_US\' AND IsVisibleInCsp = true) WITH SNIPPET (target_length=255) LIMIT 1';

        // Perform the SOSL search 
        Search.SearchResults searchResults = Search.find(sQuery);

        // Use search results to get the list of articles
        List<Search.SearchResult> articlelist = searchResults.get('KnowledgeArticleVersion');

        String sKnowledgeSearchResult = '';

        // Loop through all the articles to get article info
        for (Search.SearchResult searchResult : articlelist)
        {
            KnowledgeArticleVersion article = (KnowledgeArticleVersion) searchResult.getSObject();
            String sArticleSummary = summarizeArticleForBot(sArticleBaseUrl, article);
            sKnowledgeSearchResult = sKnowledgeSearchResult + sArticleSummary;
        }

        if (sKnowledgeSearchResult == '') sKnowledgeSearchResult = 'No results found.';

        // Build the output structure containing the results
        List<KnowledgeSearchOutput> knowledgeSearchOutputs = new List<KnowledgeSearchOutput>();
        KnowledgeSearchOutput faqSearchOutput = new KnowledgeSearchOutput();
        faqSearchOutput.sSearchResult = sKnowledgeSearchResult;
        knowledgeSearchOutputs.add(faqSearchOutput);
        return knowledgeSearchOutputs;
    }



    /** Helper method that summarizes the article */
    public static String summarizeArticleForBot(String sArticleBaseUrl,
            KnowledgeArticleVersion article)
    {
        String sSummary, sURL;
        sURL = sArticleBaseUrl + article.UrlName;

        sSummary = 'Title: ' + article.Title + '\n'+
                'Url: ' + sURL + '\n\n';

        return sSummary;
    }

    /** Helper method to get the base URL for the community */
    public static string getCommunityArticleBaseUrl()
    {

        // Gets the network for your community
        List<Network> communityNetworks =
        [SELECT Id FROM Network WHERE Name ='support'];

        String sArticleBaseUrl = '';
        if (communityNetworks.size()>0)
        {
            Network communityNetwork = communityNetworks[0];
            String sLoginUrl = Network.getLoginUrl(communityNetwork.id);
            System.debug('##KP##URL ' + Network.getLoginUrl(communityNetwork.id));
            sLoginUrl = sLoginUrl.replace('/s/login', '');
            sLoginUrl = sLoginUrl.replace('/login', '');
            sLoginUrl = sLoginUrl.replace('/s/TCSLogin', '');
            sLoginUrl = sLoginUrl.replace('/TCSLogin', '');
            sArticleBaseUrl += sLoginUrl + '/s/article/';
        }
        return sArticleBaseUrl;
    }

    public static String escapeSosl( String text ) {
        String escapedText;
        if ( String.isBlank( text ) ) {
            escapedText = null;
        } else {
            escapedText = String.escapeSingleQuotes( text ) ;
            escapedText = escapedText.replaceAll( '(?i)( AND NOT | AND | OR )', ' ' );
            Pattern myPattern = Pattern.compile( '(\\?|\\&|\\||\\!|\\{|\\}|\\[|\\]|\\(|\\)|\\^|\\~|\\*|\\:|\\"|\\+|\\-)' );
            Matcher myMatcher = myPattern.matcher( escapedText );
            escapedText = myMatcher.replaceAll( '\\\\\\\\$1' );
            escapedText = escapedText.replaceAll( '( )+', ' ' ).trim();
        }
        return escapedText;
    }



}