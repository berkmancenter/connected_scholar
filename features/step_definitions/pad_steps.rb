When /^I drag "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
  pending
  # draggable = page.find(".draggable")
  #   container = page.find("#editorcontainer iframe")
  #   draggable.drag_to container
  page.execute_script %Q{
    $.getScript("/js/jquery.simulate.js", function(data, textStatus){ 
      var editorcontainer = $('#editorcontainer');      
      var draggable = $(".draggable");
      var dx =  0 - draggable.offset().left + editorcontainer.offset().left;
      var dy =  0 - draggable.offset().top;
      draggable.simulate("drag", {dx: dx, dy: dy});
    });
  }
end

Then /^I should see "([^"]*)" in the document$/ do |arg1|
  page.driver.browser.switch_to.frame(1)
  page.driver.browser.switch_to.frame(0)
  within("#innerdocbody") do 
    page.should have_content(arg1)
  end
end