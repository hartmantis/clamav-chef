# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::install_rpm' do
  let(:packages) { %w(clamav clamav-db clamd) }
  let(:clamd) { 'clamd' }
  let(:freshclam) { 'freshclam' }
  let(:clamd_service) { "service[#{clamd}]" }
  let(:freshclam_service) { "service[#{freshclam}]" }
  let(:attributes) { {} }
  let(:platform) { { platform: 'centos', version: '6.4' } }
  let(:runner) do
    ChefSpec::Runner.new(platform) do |node|
      attributes.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any node' do
    it 'includes the EPEL cookbook' do
      expect(chef_run).to include_recipe('yum-epel')
    end

    it 'installs the pertinent packages' do
      packages.each do |p|
        expect(chef_run).to install_yum_package(p)
      end
    end

    it 'adds in init scripts' do
      [clamd, freshclam].each do |s|
        expect(chef_run).to create_template("/etc/init.d/#{s}")
      end
    end

    it 'cleans up the bad user the RPMs create' do
      expect(chef_run).to remove_user('clam')
    end
  end

  shared_examples_for 'a node with all the default attributes' do
    it 'does not send any restart notifications' do
      packages.each do |p|
        [clamd_service, freshclam_service].each do |s|
          expect(chef_run.package(p)).to_not notify(s).to(:restart)
        end
      end
    end
  end

  context 'an entirely default node' do
    it_behaves_like 'any node'
    it_behaves_like 'a node with all the default attributes'
  end

  context 'a node with the dev package enabled' do
    let(:attributes) { { clamav: { dev_package: true } } }

    it_behaves_like 'any node'

    it 'installs the ClamAV dev package' do
      expect(chef_run).to install_yum_package('clamav-devel')
    end
  end

  context 'a node with the package versions overridden' do
    let(:attributes) { { clamav: { version: '42.42.42' } } }

    it_behaves_like 'any node'

    it 'installs the packages at the specified version' do
      packages.each do |p|
        expect(chef_run).to install_yum_package(p).with(version: '42.42.42')
      end
    end
  end

  context 'a node with the clamd daemon enabled' do
    let(:attributes) { { clamav: { clamd: { enabled: true } } } }

    it 'sends a restart notification to clamd' do
      packages.each do |p|
        expect(chef_run.yum_package(p)).to notify(clamd_service).to(:restart)
      end
    end
  end

  context 'a node with the freshclam daemon enabled' do
    let(:attributes) { { clamav: { freshclam: { enabled: true } } } }

    it 'sends a restart notification to freshclam' do
      packages.each do |p|
        expect(chef_run.yum_package(p)).to notify(freshclam_service)
          .to(:restart)
      end
    end
  end
end
