Given(/^I go to the test page$/) do
  visit "http://localhost:4567/index.html"
end

Then(/^I should see Brine Test$/) do
  Prompt(@scenario)
end
