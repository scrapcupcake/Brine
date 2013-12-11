require "erb"

module Prompt
  def Prompt(scenario)
    message = scenario.steps.collect do |step|
      step == scenario.current_step ? ">> #{step}<br>" : "#{step}<br>"
    end.join("\n")
    message += "Step passes?<br>"

    iframe = ERB.new(File.read(File.join(File.dirname(__FILE__),"template.erb"))).result(binding)
    iframe = iframe.split("\n").collect{|line| "\"#{line}\"+\n"}.join("")

    script =     <<-eos
      document.lastChild.innerHTML += #{iframe} "";
    eos

    Capybara.current_session.execute_script(script)
    finished = false
    result = nil
    until finished
      sleep 0.1
      finished = Capybara.current_session.evaluate_script("window.finished")
      result = Capybara.current_session.evaluate_script("window.result")
    end

    result.should be_true, "Manual tester failed the test"
  end
end