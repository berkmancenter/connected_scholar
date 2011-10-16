Given /^no user exists with an email of "(.*)"$/ do |email|
  User.find(:first, :conditions => { :email => email }).should be_nil
end

Given /^I am a user named "([^"]*)" with an email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  user = User.create!(:name => name,
            :email => email,
            :password => password,
            :password_confirmation => password)
  user.approve!
  user.save!
end

Given /^I am an admin named "([^"]*)" with an email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  user = User.create!(:name => name,
            :email => email,
            :password => password,
            :password_confirmation => password)
  user.approve!
  user.promote!
  user.save!
end

Then /^I should be already signed in$/ do
  And %{I should see "Logout"}
end

Given /^I am signed up as "(.*)\/(.*)"$/ do |email, password|
  Given %{I am not logged in}
  When %{I go to the sign up page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I fill in "Password confirmation" with "#{password}"}
  And %{I press "Sign up"}
  Then %{I should see "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."}
  And %{I am logout}
end

Then /^I sign out$/ do
  visit('/users/sign_out')
end

Given /^I am logout$/ do
  Given %{I sign out}
end

Given /^I am not logged in$/ do
  Given %{I sign out}
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  Given %{I am not logged in}
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Sign in"}
end

Then /^I should be signed in$/ do
  Then %{I should see "Signed in successfully."}
end

When /^I return next time$/ do
  And %{I go to the home page}
end

Then /^I should be signed out$/ do
  And %{I should see "SIGN UP"}
  find_button("sign_in_btn").should_not be_nil
  And %{I should not see "Logout"}
end

Given /^I am logged in$?/ do
  Given %{I am a user named "foo" with an email "admin@test.com" and password "password"}
  When %{I sign in as "admin@test.com/password"}
  Then %{I should be signed in}
end

Given /^There is a contributor$/ do
  Given %{I am a user named "contributor" with an email "contributor@test.com" and password "password"}
end

Given /^I log in as the contributor$?/ do
  When %{I sign in as "contributor@test.com/password"}
  Then %{I should be signed in}
end