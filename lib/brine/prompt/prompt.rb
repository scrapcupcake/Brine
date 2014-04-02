require "erb"

module Prompt

  def get_javascript_result(value)
    Capybara.current_session.evaluate_script(value)
  end

  def Prompt(scenario)
    message = scenario.steps.collect do |step|
      step == scenario.current_step ? ">> #{step}<br>" : "#{step}<br>"
    end.join("\n")
    message += "Step passes?<br>"

    html_template = ERB.new(File.read(File.join(File.dirname(__FILE__),"template.erb"))).result(binding)
    html_template = html_template.split("\n").collect{|line| "\"#{line}\"+"}.join("")

    script =     <<-eos
      var element = document.createElement('div');
      element.id = "BrineTestPanel";
      element.innerHTML = #{html_template} "";
      document.body.appendChild(element);
    eos

    Capybara.current_session.execute_script(script)

    finished = false
    until finished
      sleep 0.1
      finished = get_javascript_result("window.BrineTestFinished")
    end

    result = get_javascript_result("window.BrineTestResult")
    reason = get_javascript_result("window.BrineTestReason")

    result.should be_true, "Manual tester wrote: #{reason}"
  end
end