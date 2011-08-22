Feature: Drag and Drop
  In order to add new resources to a document
  A user
  Should be able to drag and drop resources into the document.

    @javascript
    Scenario: User drags and drops some text onto the document
      Given I am a user named "foo" with an email "admin@test.com" and password "password"
      When I sign in as "admin@test.com/password"
      Then I should be signed in
      Then I create a new document
      When I drag "Drag Me Please" to the document
      Then I should see "Drag Me Please" in the document

