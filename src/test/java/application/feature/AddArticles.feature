@ignore
Feature: Articles

  Background: Define URL
    Given url apiUrl
    * def dataGenerator = Java.type('helpers.DataGenerator')

  Scenario: Create a new article
    * def articleName = dataGenerator.getRandomArticleName()
    Given path 'articles'
    And request
    """
    {
        "article": {
            "tagList": [],
            "title": "#(articleName)",
            "description": "#('description for ' + articleName)",
            "body": "#('body for '+ articleName)"
        }
    }
    """
    When method Post
    Then status 200
    And match response.article.title == articleName
#    * def id = response.article.slug
#    * def favoriteCount = response.article.favoritesCount


