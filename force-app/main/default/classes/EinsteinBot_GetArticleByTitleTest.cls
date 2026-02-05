@IsTest
private class EinsteinBot_GetArticleByTitleTest {

    @IsTest static void validateGetArticleByTitle() {
        String articleTitle = 'Test Article';
        String articleBody = 'Test Body';
        String articleUrlName = 'test-ps-test-18';
        String language = 'en_US';

        Knowledge__kav article = new Knowledge__kav(
                Title = articleTitle,
                Summary = articleBody,
                UrlName = articleUrlName,
                Language = language,
                IsVisibleInCsp = true
        );

        insert article;

        Knowledge__kav currentArticleDetail = [
                SELECT Id, ArticleCreatedDate, ArticleNumber
                FROM Knowledge__kav
                WHERE Id = :article.Id
        ];

        Id [] fixedSearchResults = new Id[]{currentArticleDetail.Id};
        Test.setFixedSearchResults(fixedSearchResults);

        System.debug('#KP#1 ' + currentArticleDetail.ArticleNumber);

        KnowledgeArticle knowledgeArticle = [
                SELECT Id
                FROM KnowledgeArticle
                WHERE ArticleNumber = :currentArticleDetail.get('ArticleNumber').toString()
        ];

        KbManagement.PublishingService.publishArticle(knowledgeArticle.Id, true);

        KnowledgeArticleVersion theArticle = [
                SELECT Title, ArticleCreatedDate
                FROM KnowledgeArticleVersion
                WHERE Id = :article.Id
                AND PublishStatus = 'Online'
        ];

        System.debug(theArticle);

        EinsteinBot_GetArticleByTitle.KnowledgeSearchInput
                sInput = new EinsteinBot_GetArticleByTitle.KnowledgeSearchInput();
        sInput.sArticleTitle = 'Test Article';

        List<EinsteinBot_GetArticleByTitle.KnowledgeSearchInput> inputList = new List<EinsteinBot_GetArticleByTitle.KnowledgeSearchInput>();
        inputList.add(sInput);

        Test.startTest();
        List<EinsteinBot_GetArticleByTitle.KnowledgeSearchOutput>
                response = EinsteinBot_GetArticleByTitle.searchKnowledge(inputList);
        Test.stopTest();

        System.debug('#KP# ' + response);


        System.assert(response[0].sSearchResult.contains('Title: ' + articleTitle));
    }
}