class ScenarioInfo
  attr_accessor :feature_name, :scenario_name, :tags

  def initialize(scenario)
    @scenario = scenario
    # Feature name
    case scenario
      when Cucumber::Ast::Scenario
        @feature_name = scenario.feature.name
      when Cucumber::Ast::OutlineTable::ExampleRow
        @feature_name = scenario.scenario_outline.feature.name
    end

    # Scenario name
    case scenario
      when Cucumber::Ast::Scenario
        @scenario_name = scenario.name
      when Cucumber::Ast::OutlineTable::ExampleRow
        @scenario_name = scenario.scenario_outline.name
    end

    # Tags (as an array)
    @tags = scenario.source_tag_names

    @current_step_number = 0
  end

  def next_step!
    @current_step_number += 1
  end

  def current_step
    steps[@current_step_number]
  end

  def steps
    @steps ||= @scenario.raw_steps.collect{|step| step.name}
  end
end