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
	  And I ensure "Test Document" pad is new
      And I follow "Manage"
      And I fill in "Title" with "A Test Resource"
      And I fill in "Author" with "Jones"
      And I press "Create Resource"
      And I follow "View Document"
      And I follow "Recommendations"
      And I drag a resource to the document      
      Then I should see "Resource Dropped" in the document