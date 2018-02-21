
require_relative '../spec_helper'

describe 'clamav::default' do
  let(:version) { nil }
  %w[
    version
    dev
    clamd_config
    freshclam_config
    clamd_enabled
    freshclam_enabled
  ].each { |a| let(a) { nil } }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::ServerRunner.new(platform) do |node|
      %w[version dev].each do |a|
        node.normal['clamav'][a] = send(a) unless send(a).nil?
      end
      %w[config enabled].each do |a|
        %w[clamd freshclam].each do |s|
          unless send("#{s}_#{a}").nil?
            node.normal['clamav'][s][a] = send("#{s}_#{a}")
          end
        end
      end
    end
  end
  let(:converge) { runner.converge(described_recipe) }

  context 'all default attributes' do
    cached(:chef_run) { converge }

    it 'installs ClamAV' do
      expect(chef_run).to create_clamav('default')
    end
  end

  context 'an overridden version attribute' do
    let(:version) { '1.2.3' }
    cached(:chef_run) { converge }

    it 'installs ClamAV with the desired version' do
      expect(chef_run).to create_clamav('default').with(version: '1.2.3')
    end
  end

  context 'an overridden dev attribute' do
    let(:dev) { true }
    cached(:chef_run) { converge }

    it 'installs ClamAV with the dev packages' do
      expect(chef_run).to create_clamav('default').with(dev: true)
    end
  end

  context 'an overridden clamd config attribute' do
    let(:clamd_config) { { 'thing1' => 'test1', 'thing2' => 'test2' } }
    cached(:chef_run) { converge }

    it 'installs ClamAV with the desired config' do
      expect(chef_run).to create_clamav('default')
        .with(clamd_config: clamd_config)
    end
  end

  context 'an overridden freshclam config attribute' do
    let(:freshclam_config) { { 'thing1' => 'test1', 'thing2' => 'test2' } }
    cached(:chef_run) { converge }

    it 'installs ClamAV with the desired config' do
      expect(chef_run).to create_clamav('default')
        .with(freshclam_config: freshclam_config)
    end
  end

  context 'an overridden clamd enabled attribute' do
    let(:clamd_enabled) { true }
    cached(:chef_run) { converge }

    it 'installs ClamAV with clamd enabled' do
      expect(chef_run).to create_clamav('default')
        .with(enable_clamd: true)
    end
  end

  context 'an overridden freshclam enabled attribute' do
    let(:freshclam_enabled) { true }
    cached(:chef_run) { converge }

    it 'installs ClamAV with freshclam enabled' do
      expect(chef_run).to create_clamav('default')
        .with(enable_freshclam: true)
    end
  end
end
