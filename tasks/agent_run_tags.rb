#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

# Puppet Task Name: agent_run_tags
#
# Triggers a Puppet agent run restricted to the supplied --tags, with any
# optional extra agent flags. Implemented in Ruby so a single file runs
# identically on Linux, macOS and Windows using the Puppet agent's bundled
# Ruby (the agent is a prerequisite of this task on every platform).
#
# Parameters are read as a JSON object on stdin (input_method: stdin).

require 'English'
require 'json'

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

params = JSON.parse($stdin.read)
tags = params['tags']
flags = params['flags'] || []

command = [find_puppet, 'agent', '--test', '--tags', tags, *flags]

# Run the agent, streaming its output, and propagate its exit code so the
# orchestrator reflects the real result of the run.
system(*command)
exit($CHILD_STATUS.nil? ? 1 : ($CHILD_STATUS.exitstatus || 1))
