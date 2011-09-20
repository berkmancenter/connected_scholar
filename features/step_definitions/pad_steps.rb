include EtherpadUtil
When /^I drag a resource to the document$/ do 
  page.execute_script(%Q{
    var editorcontainer = $('#editorcontainer');      
    var draggable = $(".draggable");
    var draggable_clone = draggable.clone();
    draggable_clone.appendTo($("#dragzone"));
    draggable_clone.draggable({zIndex: 100, iframeFix: true, start: startDrag });      
  })
  draggable = nil;
  within("#dragzone") do
    draggable = page.find(".draggable")
  end
  container = page.find("#editorcontainer  iframe")
  draggable.drag_to container
  page.execute_script(%Q{
    $(".draggable", "#dragzone").remove();
  })
end

Then /^I should see "([^"]*)" in the document$/ do |arg1|
  page.driver.browser.switch_to.frame(1)
  page.driver.browser.switch_to.frame(0)
  within("#innerdocbody") do 
    page.should have_content(arg1)
  end
end

When /^I ensure "([^"]*)" pad is new$/ do |arg1|
  document = Document.find_by_name(arg1)
  delete_pad(document)
end

Then /^I should see the export "([^"]*)" link for the "([^"]*)" document$/ do |type, doc_name|
  document = Document.find_by_name(doc_name)
  page.should have_content(type)
end

Then /^the resource "(.+)" should be not used$/ do |resource_name|
  resource_elem = find_link(resource_name)
  resource_elem['class'].should == "recommended_resource"
end

Then /^the resource "(.+)" should be used$/ do |resource_name|
  resource_elem = find_link(resource_name)
  resource_elem['class'].should == "active_source"
end