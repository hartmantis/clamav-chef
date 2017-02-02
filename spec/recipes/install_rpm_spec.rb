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
    ChefSpec::SoloRunner.new(platform) do |node|
      attributes.each { |k, v| node.override[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any platform' do
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

    context 'all default attributes' do
      it 'does not send any restart notifications' do
        packages.each do |p|
          [clamd_service, freshclam_service].each do |s|
            expect(chef_run.package(p)).to_not notify(s).to(:restart)
          end
        end
      end

      it 'leaves the freshclam cron job disabled' do
        expect(chef_run).to render_file('/etc/sysconfig/freshclam')
          .with_content(/^FRESHCLAM_DELAY=disabled/)
      end
    end

    context 'the dev package enabled' do
      let(:attributes) { { clamav: { dev_package: true } } }

      it 'installs the ClamAV dev package' do
        expect(chef_run).to install_yum_package('clamav-devel')
      end
    end

    context 'the package versions overridden' do
      let(:attributes) { { clamav: { version: '42.42.42' } } }

      it 'installs the packages at the specified version' do
        packages.each do |p|
          expect(chef_run).to install_yum_package(p).with(version: '42.42.42')
        end
      end
    end

    context 'the clamd daemon enabled' do
      let(:attributes) { { clamav: { clamd: { enabled: true } } } }

      it 'sends a restart notification to clamd' do
        packages.each do |p|
          expect(chef_run.yum_package(p)).to notify(clamd_service).to(:restart)
        end
      end
    end

    context 'the freshclam daemon enabled' do
      let(:attributes) { { clamav: { freshclam: { enabled: true } } } }

      it 'sends a restart notification to freshclam' do
        packages.each do |p|
          expect(chef_run.yum_package(p)).to notify(freshclam_service)
            .to(:restart)
        end
      end
    end
  end

  context 'the freshclam cron job enabled' do
    let(:attributes) { { clamav: { freshclam: { rhel_cron_disable: false } } } }

    it 'enables the freshclam cron job' do
      expect(chef_run).not_to render_file('/etc/sysconfig/freshclam')
        .with_content(/^FRESHCLAM_DELAY=disabled/)
    end
  end

  context 'CentOS 6' do
    let(:platform) { { platform: 'centos', version: '6.4' } }
    let(:packages) { %w(clamav clamav-db clamd) }

    it_behaves_like 'any platform'
  end

  context 'CentOS 7' do
    let(:platform) { { platform: 'centos', version: '7.0' } }
    let(:packages) { %w(clamav-server clamav clamav-update) }

    it_behaves_like 'any platform'
  end

  context 'an Amazon node' do
    let(:platform) { { platform: 'amazon', version: '2014.09' } }
    let(:packages) { %w(clamav clamav-update clamd) }

    it_behaves_like 'any platform'
  end
end
