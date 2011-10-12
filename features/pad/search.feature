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
      Then I should see "Title"
      And I should see "Creator"
      And I should see "Links"
      And I should see "Showing 1 to 25"
      And I should see ">"
      When I follow ">"
      Then I should see "Title"
      And I should see "Creator"
      And I should see "Links"
      And I should see "Showing 26 to 50"
      When I follow ">"
      And I should see "Showing 51 to 75"
      When I follow ">"
      And I should see "Showing 76 to 100"
      When I follow "<"
      And I should see "Showing 51 to 75"
      When I follow "<<"
      And I should see "Showing 1 to 25"

    @javascript
    Scenario: User executes an Advanced Search for a resource and recommends it
      When I follow "Advanced Search"
      And I fill in "advanced_query" with "aspect-oriented programming with the e verification language"
      And I select "Exact Title" from "search_type"
      And I press "Search"
      And I wait 3 seconds
      Then I should see "Aspect-oriented programming with the e verification language"
      And I should see "Robinson, David."
      And I should see "Links"
      And I should see "Showing 1 of 1 result"
      And I should see "Hollis"
      When I follow "Hollis"
      Then it should open a new window on the hollis page for "012099054"
      Then I follow "Aspect-oriented programming with the e verification language"
      And I should see "Recommend"
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
      And I should see "Title"
      And I should see "Creator"
      And I should see "Links"
#      Then I press "advanced_search_reset"
#      And I should not see "Title:"
#      And I should not see "Creator"
#      And I should not see "Recommend"
#      And I should not see "Links:"
#      And the "Query" field should be empty
#      And I follow "Sources"
#      And I wait 1 seconds

    @javascript
    Scenario: User executes an Google Search for a resource and recommends it
      When I follow "Advanced Search"
      And I follow "Google Scholar"
      And I fill in "google_query" with "goto considered harmful"
      And I press "google_search"
      And I wait 3 seconds
      Then I should see "Letters to the editor: go to statement considered harmful"
      And I should see "EW Dijkstra"
      And I should see "Links"
      And I should see "Showing 1 to 25"
      And I should see "portal.acm.org"
      When I follow "portal.acm.org"
      Then it should open a new window with the domain of the ACM Digital Library
      Then I follow "Letters to the editor: go to statement considered harmful"
      And I should see "Recommend"
      When I follow "Recommend"
      And I wait 1 seconds
      Then I should see "Letters to the editor: go to statement considered harmful"
      And the resource "Letters to the editor: go to statement considered harmful" should be not used
      When I follow "Letters to the editor: go to statement considered harmful"
      Then I should see "1968-01-01"
      And I should see "EW Dijkstra"
      And I should see "Communications of the ACM"
      And I should see "portal.acm.org"
      When I follow "portal.acm.org"
      Then it should open a new window with the domain of the ACM Digital Library
