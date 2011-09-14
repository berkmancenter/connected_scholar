Feature: Promote users to admin
  In order give certain users advanced privilages
  An admin user
  Should be able to promote users to admins

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
      Then I am not logged in
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
      And I sign in as "admin@test.com/please"
      When I go to the user admin page
      Then I should see "Add"
      And I follow "Add"

    Scenario: I promote a user to admin
      Then I should not see "Add"
      And I should see "Remove"
      Then I sign out
      Then I go to the sign in page
      And I sign in as "user@test.com/please"
      When I go to the user admin page
      Then I should see "Pending Users"

    @allow-rescue
    Scenario: I demote an existing admin
      When I follow "Remove"
      Then I should see "Add"
      Then I sign out
      Then I go to the sign in page
      And I sign in as "user@test.com/please"
      When I go to the user admin page
      Then I should not see "Pending Users"
      Then I should not see "Active Users"

