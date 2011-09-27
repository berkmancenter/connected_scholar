Feature: Delete user
  In order to remove users from the system
  An admin user
  Should be able to delete other users

    Scenario: I delete an existing user
      Given I am not logged in
      And I am on the home page
      And I go to the sign up page
      And I fill in the following:
        | Name                  | Testy McUserton |
        | Email                 | user@test.com   |
        | Password              | please          |
        | Password confirmation | please          |
      And I press "Sign up"
      Given I am not logged in
      And I am an admin named "foo" with an email "admin@test.com" and password "please"
      When I go to the sign in page
      And I sign in as "admin@test.com/please"
      Then I should see "Signed in successfully."
      When I go to the user admin page
      Then I should see "Pending Users"
      And I should see "Testy McUserton"
      And I should see "user@test.com"
      And I should not see "There are no unapproved users"
      And I follow "Approve"
      And I should see "There are no unapproved users"
      Then I go to the user admin page
      And I should see "Active Users"
      And I should see "Testy McUserton"
      And I should see "user@test.com"
      Then I follow "Delete"
      And I should not see "Testy McUserton"
      And I should not see "user@test.com"

    Scenario: I try to delete my own user
      Given I am not logged in
      And I am an admin named "foo" with an email "admin@test.com" and password "please"
      When I go to the sign in page
      And I sign in as "admin@test.com/please"
      Then I should see "Signed in successfully."
      And I go to the user admin page
      Then I should see "Active Users"
      And I should see "foo"
      And I should see "admin@test.com"
      And I should not see "Delete"

