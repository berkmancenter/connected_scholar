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
      And I reload the page
      And I set the text "This is the Test Document. This is text. and this is more and more text.  how much text do we need maybe this is enough.  This is some more text." to the "Test Document"
      And I follow "Add"
      And I fill in "Title" with "A Test Resource"
      And I fill in "Creators" with "John Jones"
      And I press "Create Resource"
      When I reload the page
      Then the resource "A Test Resource" should be not used
      When I follow "Sources"
      And I drag a resource to the document 
      Then I should see "(Jones 2011)" in the document
      When I reload the page
      And the resource "A Test Resource" should be used
      When I follow "A Test Resource"
      Then I should see "Title: A Test Resource"
      And I should see "(Jones 2011)"