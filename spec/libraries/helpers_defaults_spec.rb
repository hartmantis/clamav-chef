# Encoding: UTF-8

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
end
