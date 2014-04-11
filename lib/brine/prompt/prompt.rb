require "erb"

module Prompt

  def exec_script(value)
    Capybara.current_session.evaluate_script(value)
  end

  def require_url
    "//cdnjs.cloudflare.com/ajax/libs/require.js/2.1.11/require.js"
  end

  def brine_url
    "//rawgithub.com/brine.js"
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
      step == scenario.current_step ? ">> #{step}" : "#{step}"
    end.join("\n")
    message += "Step passes?"

    add_src_exec(require_url)
    sleep 0.2
    add_src_exec(brine_url)

    exec_script("Brine.displayPrompt()")

    finished = false
    until finished
      sleep 0.1
      status = exec_script("window.Brine.status")
      require "pry"; binding.pry
      finished = status.finished
    end

    result = status.result
    reason = status.reason

    result.should be_true, "Manual tester wrote: #{reason}"
  end
end