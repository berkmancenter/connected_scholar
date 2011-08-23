Feature: Drag and Drop
  In order to add new resources to a document
  A user
  Should be able to drag and drop resources into the document.

    @javascript
    Scenario: User drags and drops some text onto the document
      Given I am logged in
      Then I create a new document
      When I drag "Drag Me Please" to the document
      Then I should see "Thanks for dropping me!" in the document

