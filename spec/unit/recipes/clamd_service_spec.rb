# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav::clamd_service' do
  let(:platform) { { platform: nil, version: nil } }
  let(:service) { nil }
  let(:attributes) { {} }
  let(:runner) do
    ChefSpec::Runner.new(platform) do |node|
      attributes.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any node' do
    it 'creates the PID file directory' do
      expect(chef_run).to create_directory('/var/run/clamav').with(
        user: 'clamav',
        group: 'clamav',
        recursive: true
      )
    end
  end

  shared_examples_for 'a node with the clamd service disabled' do
    it 'disables the service' do
      expect(chef_run).to disable_service(service)
      expect(chef_run).to stop_service(service)
    end
  end

  shared_examples_for 'a node with the clamd service enabled' do
    it 'enables the service' do
      expect(chef_run).to enable_service(service)
      expect(chef_run).to start_service(service)
    end
  end

  {
    Ubuntu: {
      platform: 'ubuntu',
      version: '12.04',
      service: 'clamav-daemon'
    },
    CentOS: {
      platform: 'centos',
      version: '6.4',
      service: 'clamd'
    }
  }.each do |k, v|
    context "a #{k} node" do
      let(:platform) { { platform: v[:platform], version: v[:version] } }
      let(:service) { v[:service] }

      context 'an entirely default node' do
        it_behaves_like 'any node'
        it_behaves_like 'a node with the clamd service disabled'
      end

      context 'a node with the clamd service enabled' do
        let(:attributes) { { clamav: { clamd: { enabled: true } } } }
        it_behaves_like 'any node'
        it_behaves_like 'a node with the clamd service enabled'
      end
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
