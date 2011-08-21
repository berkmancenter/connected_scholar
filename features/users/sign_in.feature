Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Scenario: User is not signed up
      Given I am not logged in
      And no user exists with an email of "admin@test.com"
      When I go to the sign in page
      And I sign in as "admin@test.com/password"
      Then I should see "Invalid email or password."
      And I go to the home page
      And I should be signed out

    Scenario: User enters wrong password
      Given I am not logged in
      And I am a user named "foo" with an email "admin@test.com" and password "please"
      When I go to the sign in page
      And I sign in as "admin@test.com/wrongpassword"
      Then I should see "Invalid email or password."
      And I go to the home page
      And I should be signed out

    Scenario: User signs in successfully with email
      Given I am not logged in
      And I am a user named "foo" with an email "admin@test.com" and password "password"
      When I go to the sign in page
      And I sign in as "admin@test.com/password"
      Then I should see "Signed in successfully."
      And I should be signed in
      When I return next time
      Then I should be already signed in
