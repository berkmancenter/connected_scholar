Feature: Approve new user
  In order give new users access
  An admin user
  Should be able to approve new users

    Background:
      Given I am not logged in
      And I am on the home page
      And I go to the sign up page
      And I fill in the following:
        | Name                  | Testy McUserton |
        | Email                 | user@test.com   |
        | Password              | please          |
        | Password confirmation | please          |
      And I press "Sign up"

    Scenario: User is approved
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
      Then I follow "Approve"
      And I should see "There are no unapproved users"
      Then I sign out
      When I go to the sign in page
      And I sign in as "user@test.com/please"
      Then I should see "Signed in successfully."

    Scenario: User is rejected
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
      Then I follow "Reject"
      And I should see "There are no unapproved users"
      Then I sign out
      When I go to the sign in page
      And I sign in as "user@test.com/please"
      Then I should see "Invalid email or password."