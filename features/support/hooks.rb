
Before do |scenario|
  @scenario = ScenarioInfo.new(scenario)
end

AfterStep do
  @scenario.next_step!
end