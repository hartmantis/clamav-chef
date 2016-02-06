# Encoding: UTF-8

require_relative '../spec_helper'

describe 'clamav::default' do
  let(:version) { nil }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::ServerRunner.new(platform) do |node|
      node.set['clamav']['version'] = version unless version.nil?
    end
  end

  shared_examples_for 'any attribute set' do
    it 'installs the ClamAV app' do
      expect(chef_run).to install_clamav_app('default').with(version: version)
    end
  end

  context 'all default attributes' do
    cached(:chef_run) { runner.converge(described_recipe) }

    it_behaves_like 'any attribute set'
  end

  context 'an overridden version attribute' do
    let(:version) { '1.2.3' }
    cached(:chef_run) { runner.converge(described_recipe) }

    it_behaves_like 'any attribute set'
  end
end
