@javascript
Feature: View editbar functionality
  In order to view the editbar functionality
  A user
  Should be able to select editbar features

    Background:
      Given I am logged in
      And I follow "New Document"
      And I fill in "Name" with "Test Document"
      And I press "Create Document"

    Scenario: User selects readonly and views the readonly link
      And I click "#readonlylink"  
      Then I should see "Use this link to share a read-only version of your pad:"

    Scenario: User selects Import/Export and views different types of exports
  	  And I click "#exportlink" 
      Then I should see "Export current pad as:"

    Scenario: User selects embed and views the embed link
	  And I click "#embedlink"
	  Then I should see "Embed code:"

    Scenario: User selects timeslider and views the timeslider
      And I click "#timesliderlink"
  	  Then I should see "Return to pad"