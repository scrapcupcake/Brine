require "erb"

module Prompt

  def exec_script(value)
    Capybara.current_session.evaluate_script(value)
  end

  def require_url
    "//cdnjs.cloudflare.com/ajax/libs/require.js/2.1.11/require.js"
  end

  def brine_url
    "https://gist.githubusercontent.com/scrapcupcake/10428904/raw/fa10ca7a14634ac06167536dc86b72c39164e389/brine.js"
  end

  def add_src(url)
    script = <<-eos
    head = document.getElementsByTagName('head')[0];
    script = document.createElement('script');
    script.src = '#{url}';
    head.appendChild(script);
    eos
  end

  def add_src_exec(url)
    add_src(url).split(/\n/).each { |line| exec_script(line) }
  end

  def Prompt(scenario)
    message = scenario.steps.collect do |step|
      step == scenario.current_step ? ">> #{step}<br>" : "#{step}<br>"
    end.join("\n")
    message += "Step passes?<br>"

    add_src_exec(brine_url)

    finished = false
    until finished
      sleep 0.1
      finished = exec_script("window.BrineTestFinished")
    end

    result = exec_script("window.BrineTestResult")
    reason = exec_script("window.BrineTestReason")

    result.should be_true, "Manual tester wrote: #{reason}"
  end
end