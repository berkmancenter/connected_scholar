When /^I drag "([^"]*)" to the document$/ do |arg1|
  drag_name = page.find("#draggable")
  drop_name = page.find "#editorcontainer iframe"
  drag_name.drag_to drop_name
end

Then /^I create a new document$/ do
  visit("/p/newpad123")
end

Then /^I should see "([^"]*)" in the document$/ do |arg1|
  page.driver.browser.switch_to.frame(1)
  page.driver.browser.switch_to.frame(0)
  within("#innerdocbody") do 
    page.should have_content(arg1)
  end
end