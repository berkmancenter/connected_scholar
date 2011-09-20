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

    @javascript
    Scenario: User executes an Advanced Search for a resource and recommends it
      When I follow "Advanced Search"
      And I fill in "advanced_query" with "aspect-oriented programming with the e verification language"
      And I select "Exact Title" from "search_type"
      And I press "Search"
      And I wait 3 seconds
      Then I should see "Title: Aspect-oriented programming with the e verification language"
      And I should see "Creator: Robinson, David."
      And I should see "Recommend"
      And I should see "Links:"
      And I should see "Hollis"
      When I follow "Hollis"
      Then it should open a new window on the hollis page for "012099054"
      When I follow "Recommend"
      Then I should see "Aspect-oriented programming with the e verification language"
      And the resource "Aspect-oriented programming with the e verification language" should be not used

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
