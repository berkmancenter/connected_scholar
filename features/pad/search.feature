Feature: Search for Resources
  In order find resources that can be used as references
  A user
  Should be able to enter keywords in a Google style search.

    Background:
      Given I am logged in
      And I follow "New Document"
      And I fill in "Name" with "Comment Test Document"
      And I press "Create Document"
      And I follow "Sources"
      And I wait 1 seconds
      And I follow "Add"
      And I fill in "Title" with "A Test Resource"
      And I fill in "Creators" with "Jones"
      And I press "Create Resource"
      And I wait 1 seconds

    @javascript
    Scenario: User executes a Simple Search for a resource and recommends it
      When I fill in "query" with "Cars"
      And I press "Go"
      And I wait 3 seconds
      Then I should see "Title:"
      And I should see "Creator"
      And I should see "Recommend"
      And I should see "Links:"
      Then I follow "Recommend"
#      And I follow "Sources"
#      And I wait 1 seconds
#      Then I should see "Drag Resource"

    @javascript
    Scenario: User executes an Advanced Search for a resource and recommends it
      When I follow "Advanced Search"
      And I fill in "advanced_query" with "Cars"
      And I select "Title Keyword" from "search_type"
      And I press "Search"
      And I wait 3 seconds
      Then I should see "Title:"
      And I should see "Creator"
      And I should see "Recommend"
      And I should see "Links:"
      And I press "Close"
#      And I follow "Sources"
#      And I wait 1 seconds
#      Then I should see "Drag Resource"

    @javascript
    Scenario: User resets the search dialog
      When I follow "Advanced Search"
      And I fill in "advanced_query" with "Cars"
      And I select "Title Keyword" from "advanced_search_type"
      And I press "Search"
      Then I wait 3 seconds
      And I should see "Title:"
      And I should see "Creator"
      And I should see "Recommend"
      And I should see "Links:"
#      Then I press "advanced_search_reset"
#      And I should not see "Title:"
#      And I should not see "Creator"
#      And I should not see "Recommend"
#      And I should not see "Links:"
#      And the "Query" field should be empty
#      And I follow "Sources"
#      And I wait 1 seconds
