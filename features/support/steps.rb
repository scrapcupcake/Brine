Given(/^I go to google$/) do
  visit "http://google.com"
end

When(/^I search for Brine Test$/) do
  fill_in "q", with: "Brine Test"
  find("#gbqfb").click
end

Then(/^I should see Brine Test in the search results$/) do
  Prompt(@scenario)
end
