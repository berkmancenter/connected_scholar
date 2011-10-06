Feature: User preferences
  In order to customize the application for each person's needs
  A user
  Should be able to set preferences

   Scenario: A user can set the default citation format
      Given I am logged in
      And I go to the user preferences page
      Then I should see "Default citation format:"
      And "APA" should not be selected for "citation_format"
      Then I select "APA" from "citation_format"
      And I press "Save"
      Then "APA" should be selected for "citation_format"
      And "MLA" should not be selected for "citation_format"

      # TODO check the document page to make sure its set right

