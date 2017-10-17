# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../libraries/helpers_defaults'

describe ClamavCookbook::Helpers::Defaults do
  let(:platform) { nil }
  let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
  let(:test_class) do
    Class.new do
      include ClamavCookbook::Helpers::Defaults
    end
  end
  let(:test_obj) { test_class.new }

  before(:each) do
    allow(test_obj).to receive(:node).and_return(node)
  end

  describe '#clamd_service_name' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct service name' do
        expect(test_obj.clamd_service_name).to eq('clamav-daemon')
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct service name' do
        expect(test_obj.clamd_service_name).to eq('clamav-daemon')
      end
    end
  end

  describe '#freshclam_service_name' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct service name' do
        expect(test_obj.freshclam_service_name).to eq('clamav-freshclam')
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct service name' do
        expect(test_obj.freshclam_service_name).to eq('clamav-freshclam')
      end
    end
  end

  describe '#freshclam_config' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct config' do
        expect(test_obj.freshclam_config).to eq(
          DatabaseMirror: %w(db.local.clamav.net database.clamav.net)
        )
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct config' do
        expect(test_obj.freshclam_config).to eq(
          DatabaseMirror: %w(db.local.clamav.net database.clamav.net)
        )
      end
    end
  end

  describe '#clamd_config' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct config' do
        expect(test_obj.clamd_config).to eq(
          LocalSocket: '/var/run/clamav/clamd.sock'
        )
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct config' do
        expect(test_obj.clamd_config).to eq(
          LocalSocket: '/var/run/clamav/clamd.sock'
        )
      end
    end
  end

  describe '#clamav_data_dir' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct path' do
        expect(test_obj.clamav_data_dir).to eq('/var/lib/clamav')
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct path' do
        expect(test_obj.clamav_data_dir).to eq('/var/lib/clamav')
      end
    end
  end

  describe '#clamav_conf_dir' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct path' do
        expect(test_obj.clamav_conf_dir).to eq('/etc/clamav')
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct path' do
        expect(test_obj.clamav_conf_dir).to eq('/etc/clamav')
      end
    end
  end

  describe '#clamav_user' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct user' do
        expect(test_obj.clamav_user).to eq('clamav')
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct user' do
        expect(test_obj.clamav_user).to eq('clamav')
      end
    end
  end

  describe '#clamav_group' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct group' do
        expect(test_obj.clamav_group).to eq('clamav')
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct group' do
        expect(test_obj.clamav_group).to eq('clamav')
      end
    end
  end

  describe '#base_packages' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct package list' do
        expect(test_obj.base_packages).to eq(
          %w(clamav clamav-daemon clamav-freshclam)
        )
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct package list' do
        expect(test_obj.base_packages).to eq(
          %w(clamav clamav-daemon clamav-freshclam)
        )
      end
    end
  end

  describe '#dev_packages' do
    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns the correct package list' do
        expect(test_obj.dev_packages).to eq(%w(libclamav-dev))
      end
    end

    context 'Debian 8.2' do
      let(:platform) { { platform: 'debian', version: '8.2' } }

      it 'returns the correct package list' do
        expect(test_obj.dev_packages).to eq(%w(libclamav-dev))
      end
    end
  end
end
