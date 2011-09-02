Feature: Add Comment
  In order to communicate with other contributors and the author of the document
  A user
  Should be able to add comments to the document.

    Background:
      Given I am logged in
      And I follow "New Document"
      And I fill in "Name" with "Comment Test Document"
      And I press "Create Document"
      And I follow "Manage"
      And I fill in "Title" with "A Test Resource"
      And I fill in "Author" with "Jones"
      And I press "Create Resource"
      And I follow "View Document"

    @javascript
    Scenario: User adds a comment the document
      And I follow "Comments"
      And I wait 1 seconds
      Then I follow "Add Comment"
      And I should see "Add Comment"
      Then I fill in "comment_comment_text" with "This is a great document"