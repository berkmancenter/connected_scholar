Feature: Refresh Used Sources
  In order to keep the list of sources accurate
  A user
  Should be able to refresh the list of sources
  So that only the used ones appear as "Used"

    Background:
      Given I am logged in
      And I follow "New Document"
      And I fill in "Name" with "Test Document"
      And I press "Create Document"
      And I ensure "Test Document" pad is new
      And I reload the page
      And I set the text "This is the Test Document. This is text. and this is more and more text (Jones 2011).  how much text do we need maybe this is enough.  This is some more text." to the "Test Document"
      And I follow "Add"
      And I fill in "Title" with "A Test Resource"
      And I fill in "Creators" with "Jones"
      And I press "Create Resource"
      And I wait 1 seconds
      When I follow "A Test Resource"
      Then I should see "Recognized Citations:"
      When I fill in "citation_citation_text" with "(Jones 2011)"
      And I press "add"

    @javascript
    Scenario: Refresh the sources so the unused becomes used
      Given the resource "A Test Resource" should be not used
      When I follow "Refresh Sources"
      And I wait 1 seconds
      Then the resource "A Test Resource" should be used

    @javascript
    Scenario: Refresh the sources so the used becomes unused
      Given I follow "Refresh Sources"
      And I wait 1 seconds
      Then the resource "A Test Resource" should be used
      Then I set the text "This is the Test Document. This is text. and this is more and more text.  how much text do we need maybe this is enough.  This is some more text." to the "Test Document"
      And I follow "Refresh Sources"
      And I wait 1 seconds
      Then the resource "A Test Resource" should be not used