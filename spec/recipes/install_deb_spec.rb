# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::install_deb' do
  let(:packages) { %w(clamav clamav-daemon clamav-freshclam) }
  let(:clamd_service) { 'service[clamav-daemon]' }
  let(:freshclam_service) { 'service[clamav-freshclam]' }
  let(:attributes) { {} }
  let(:platform) { { platform: 'ubuntu', version: '12.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      attributes.each { |k, v| node.override[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any node' do
    it 'installs the pertinent packages' do
      packages.each do |p|
        expect(chef_run).to install_package(p)
      end
    end

    it 'cleans up files left behind by the packages' do
      %w(
        /etc/logrotate.d/clamav-daemon
        /etc/logrotate.d/clamav-freshclam
      ).each do |f|
        expect(chef_run).to delete_file(f)
      end
    end
  end

  shared_examples_for 'a node with all default attributes' do
    it 'does not send any restart notifications' do
      packages.each do |p|
        [clamd_service, freshclam_service].each do |s|
          expect(chef_run.package(p)).to_not notify(s).to(:restart)
        end
      end
    end
  end

  context 'an entirey default node' do
    it_behaves_like 'any node'
    it_behaves_like 'a node with all default attributes'
  end

  context 'a node with the dev package enabled' do
    let(:attributes) { { clamav: { dev_package: true } } }

    it_behaves_like 'any node'

    it 'installs the ClamAV dev package' do
      expect(chef_run).to install_package('libclamav-dev')
    end
  end

  context 'a node with the package versions overridden' do
    let(:attributes) { { clamav: { version: '42.42.42' } } }

    it_behaves_like 'any node'

    it 'installs the packages at the specified version' do
      packages.each do |p|
        expect(chef_run).to install_package(p).with(version: '42.42.42')
      end
    end
  end

  context 'a node with the clamd daemon enabled' do
    let(:attributes) { { clamav: { clamd: { enabled: true } } } }

    it_behaves_like 'any node'

    it 'sends a restart notification to clamd' do
      packages.each do |p|
        expect(chef_run.package(p)).to notify(clamd_service).to(:restart)
      end
    end
  end

  context 'a node with the freshclam daemon enabled' do
    let(:attributes) { { clamav: { freshclam: { enabled: true } } } }

    it_behaves_like 'any node'

    it 'sends a restart notification to freshclam' do
      expect(chef_run.package(packages[0])).to notify(freshclam_service)
        .to(:restart)
    end
  end
end
