# frozen_string_literal: true

require 'spec_helper'
require_relative '../../tasks/agent_run_tags'

describe AgentRunTags do
  before(:each) do
    allow(Gem).to receive(:win_platform?).and_return(false)
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/opt/puppetlabs/bin/puppet').and_return(true)
  end

  describe '.find_puppet' do
    it 'prefers the all-in-one install path' do
      expect(described_class.find_puppet).to eq('/opt/puppetlabs/bin/puppet')
    end

    it 'falls back to PATH when no install path exists' do
      allow(File).to receive(:exist?).with('/opt/puppetlabs/bin/puppet').and_return(false)
      allow(File).to receive(:exist?).with('/opt/puppetlabs/puppet/bin/puppet').and_return(false)
      expect(described_class.find_puppet).to eq('puppet')
    end

    context 'on Windows' do
      let(:bat) { File.join('C:\\Program Files', 'Puppet Labs', 'Puppet', 'bin', 'puppet.bat') }

      before(:each) do
        allow(Gem).to receive(:win_platform?).and_return(true)
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('ProgramFiles').and_return('C:\\Program Files')
        allow(File).to receive(:exist?).with(bat).and_return(true)
      end

      it 'uses puppet.bat under Program Files' do
        expect(described_class.find_puppet).to eq(bat)
      end
    end
  end

  describe '.build_command' do
    it 'passes tags and flags as discrete arguments' do
      expect(described_class.build_command('tags' => 'profile::ntp,profile::ssh', 'flags' => ['--noop', '--debug']))
        .to eq(['/opt/puppetlabs/bin/puppet', 'agent', '--test', '--tags', 'profile::ntp,profile::ssh', '--noop', '--debug'])
    end

    it 'treats flags as optional' do
      expect(described_class.build_command('tags' => 'profile::ntp'))
        .to eq(['/opt/puppetlabs/bin/puppet', 'agent', '--test', '--tags', 'profile::ntp'])
    end

    it 'requires tags' do
      expect { described_class.build_command({}) }.to raise_error(KeyError)
    end
  end

  describe '.run' do
    it 'runs the agent and propagates its exit code' do
      allow(described_class).to receive(:system)
        .with('/opt/puppetlabs/bin/puppet', 'agent', '--test', '--tags', 'profile::ntp') { system('exit 2') }
      expect(described_class.run('{"tags":"profile::ntp"}')).to eq(2)
    end
  end
end
