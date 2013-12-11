require_relative "../../lib/brine"
require "capybara/cucumber"

Capybara.default_driver = :selenium

World(Prompt)