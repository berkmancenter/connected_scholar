Feature: Recommend a Resources
  In to help the document owner
  A user
  Should be able to add recommended resources to the sources list.

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
    Scenario: Recommend a resource
      Then I should see "A Test Resource"
      Then the resource "A Test Resource" should be not used
      When I follow "A Test Resource"
      Then I should see "Title: A Test Resource"
      And I should see "Delete this Resource"

    @javascript
    Scenario: Delete a recommended resource
      When I follow "A Test Resource"
      And I preconfirm
      And I follow "Delete this Resource"
      Then I should not see "A Test Resource"

    @javascript
    Scenario: View a recommended resource
#      When I follow "Hollis"
#      And I preconfirm
#      And I follow "Delete this Resource"
#      Then I should not see "A Test Resource"