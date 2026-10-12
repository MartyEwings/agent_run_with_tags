#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

# Puppet Task Name: agent_run_tags
#
# Triggers a Puppet agent run restricted to the supplied --tags, with any
# optional extra agent flags. Implemented in Ruby so a single file runs
# identically on Linux, macOS and Windows using the Puppet agent's bundled
# Ruby (the agent is a prerequisite of this task on every platform). Kept
# free of non-default gems so it runs on every agent Ruby from 2.7 to 4.x.
#
# Parameters are read as a JSON object on stdin (input_method: stdin).

require 'json'

# Wraps the task logic so it can be loaded and unit tested without running.
module AgentRunTags
  module_function

  # Locate the puppet executable. The agent's Ruby and the puppet binary do not
  # share a directory on Windows, so probe the standard all-in-one install paths
  # per platform before falling back to PATH.
  def find_puppet
    candidates =
      if Gem.win_platform?
        [File.join(ENV['ProgramFiles'] || 'C:\\Program Files', 'Puppet Labs', 'Puppet', 'bin', 'puppet.bat')]
      else
        ['/opt/puppetlabs/bin/puppet', '/opt/puppetlabs/puppet/bin/puppet']
      end
    candidates.find { |path| File.exist?(path) } || 'puppet'
  end

  def build_command(params)
    [find_puppet, 'agent', '--test', '--tags', params.fetch('tags'), *(params['flags'] || [])]
  end

  # Run the agent, streaming its output, and return its exit code so the
  # orchestrator reflects the real result of the run.
  def run(input)
    system(*build_command(JSON.parse(input)))
    status = Process.last_status
    status&.exitstatus || 1
  end
end

exit(AgentRunTags.run($stdin.read)) if $PROGRAM_NAME == __FILE__
