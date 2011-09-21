Feature: Manage Users
  In order mange who uses the system
  An admin user
  Should be able go to a page with options to manage users

    Scenario: I can get to the Admin page as an admin user
      Given I am an admin named "foo" with an email "admin@test.com" and password "please"
      When I go to the sign in page
      And I sign in as "admin@test.com/please"
      Then I should see "Signed in successfully."
      And I go to the home page
      Then I should see "Manage Users"
      When I follow "Manage Users"
      Then I should be on the user admin page

    Scenario: I cannot get to the Admin page as a regular user
      Given I am a user named "foo" with an email "user@test.com" and password "please"
      When I go to the sign in page
      And I sign in as "user@test.com/please"
      Then I should see "Signed in successfully."
      When I go to the home page
      Then I should not see "Manage Users"
#      And I should not have access to the user admin page