Feature: Manage Citations
  In order to change the citations that are recognized for a resource
  A user
  Should be able to add and remove citations.

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
      When I follow "A Test Resource"
      Then I should see "Recognized Citations:"
      And I should not see "(Jones 2011, pgs 12-13)"
      When I fill in "citation_citation_text" with "(Jones 2011, pgs 12-13)"
      And I press "add"

    @javascript
    Scenario: Add a recognized citation
      When I follow "A Test Resource"
      Then I should see "(Jones 2011, pgs 12-13)"

    @javascript
    Scenario: Delete a recognized citation
      When I follow "A Test Resource"
      Then I should see "(Jones 2011, pgs 12-13)"
      When I preconfirm 
      And I follow "delete"
      And I follow "A Test Resource"
      Then I should not see "(Jones 2011, pgs 12-13)"

