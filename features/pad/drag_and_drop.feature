Feature: Drag and Drop
  In order to add new resources to a document
  A user
  Should be able to drag and drop resources into the document.

    @javascript
    Scenario: User drags and drops a resource onto the document
      Given I am logged in
      And I follow "New Document"
      And I fill in "Name" with "Test Document"
      And I press "Create Document"
      And I follow "Manage"
      And I fill in "Title" with "A Test Resource"
      And I fill in "Author" with "Jones"
      And I press "Create Resource"
      And I follow "View Document"
      And I follow "Recommendations"
      And I wait 1 seconds
      And I drag "Drag Resource" to "Welcome to Etherpad Lite!"
      
      Then I should see "Resource Dropped" in the document