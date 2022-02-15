@debug
Feature: Validate favorite and comment function

  Background: Preconditions
    * url apiUrl
    * def isTimeValidator = read('classpath:helpers/TimeValidator.js')
    * configure afterScenario =  function(){ karate.call('Hook.feature'); }
    * def responseForAddArticle = call read('AddArticles.feature')
    * def slugID = responseForAddArticle.article.slug

  Scenario: Favorite articles
    * def favoritesCount = responseForAddArticle.article.favoritesCount
    Given path 'articles', slugID, 'favorite'
    When method Post
    Then status 200
    And match response.article ==
        """
        {
            "id": "#number",
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "createdAt": "#? isTimeValidator(_)",
            "updatedAt": "#? isTimeValidator(_)",
            "authorId": "#number",
             "tagList": "#array",
             "author": {
                "username": "#string",
                    "bio": "#string",
                    "image": "#string",
                    "following": '#boolean'
                },
             "favoritedBy": [
                {
                    "id": "#number",
                    "email": "#string",
                    "username": "#string",
                    "password": "#string",
                    "image": "#string",
                    "bio": "#string",
                    "demo": '#boolean'
                }
             ],
             "favorited": '#boolean',
             "favoritesCount": '#number',
        }
        """
    And match response.article.favoritesCount == favoritesCount + 1
    * def username = response.article.author.username
    Given params {limit: 10, offset: 0, favorited: "#(username)"}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.article ==
        """
        {
            "slug": '#string',
            "title": '#string',
            "description": '#string',
            "body": '#string',
            "createdAt": '#string',
            "updatedAt": '#string',
            "authorId": '#number',
            "director": '#string',
            "tagList": '#array',
            "author":{
                "username": '#string',
                "bio": '#string',
                "image": '#string',
                "following": '#boolean',
            },
            "favoritesCount": '#number',
            "favorited": '#boolean'
         }
        """
    And match response.articles[*].slug contains slugID

  Scenario: Comment articles
    * call read('ArticleComments.feature')
    And match response ==
        """
            {
               "comments": "#array"
            }
        """
    * def articlesCount = response.comments.length
    * def comment = "My comment" + parseInt(Math.random()*9999)
    Given path 'articles', slugID, 'comments'
    And request {"comment": {"body": "#(comment)"}}
    When method Post
    Then status 200
    * def commentID = response.comment.id
    And match response ==
        """
            {
            "comment": {
                "id": '#number',
                "createdAt": "#? isTimeValidator(_)",
                "updatedAt": "#? isTimeValidator(_)",
                "body": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                }
            }
        }
        """
    * call read('ArticleComments.feature')
    And response.comments.length == commentsCount + 1
    * def commentsCount = response.comments.length
    Given path 'articles', slugID, 'comments', commentID
    When method Delete
    Then status 204
    * call read('ArticleComments.feature')
    And response.comments.length == commentsCount - 1