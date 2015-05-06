# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::services' do
  let(:platform) { { platform: nil, version: nil } }
  let(:services) { { clamd: nil, freshclam: nil } }
  let(:attributes) { {} }
  let(:ruby_block) { 'dummy service notification block' }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      attributes.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'with anything' do
    it 'does nothing with the services themselves' do
      [:clamd, :freshclam].each do |s|
        expect(chef_run.service(services[s])).to be
        expect(chef_run).to_not start_service(services[s])
        expect(chef_run).to_not stop_service(services[s])
        expect(chef_run).to_not enable_service(services[s])
        expect(chef_run).to_not disable_service(services[s])
      end
    end

    it 'creates a dummy Ruby block' do
      expect(chef_run).to run_ruby_block('dummy service notification block')
    end
  end

  shared_examples_for 'with the freshclam service disabled' do
    it 'disables the service' do
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:freshclam]}]").to(:disable)
    end

    it 'stops the service' do
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:freshclam]}]").to(:stop)
    end
  end

  shared_examples_for 'with the freshclam service enabled' do
    it 'enables the service' do
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:freshclam]}]").to(:enable)
    end

    it 'starts the service' do
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:freshclam]}]").to(:start)
    end
  end

  shared_examples_for 'with the clamd service disabled' do
    it 'stops and disables the service' do
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:clamd]}]").to(:disable)
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:clamd]}]").to(:stop)
    end
  end

  shared_examples_for 'with the clamd service enabled' do
    it 'enables and starts the service' do
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:clamd]}]").to(:enable)
      expect(chef_run.ruby_block(ruby_block))
        .to notify("service[#{services[:clamd]}]").to(:start)
    end
  end

  {
    Ubuntu: {
      platform: 'ubuntu',
      version: '12.04',
      clamd_service: 'clamav-daemon',
      freshclam_service: 'clamav-freshclam'
    },
    CentOS: {
      platform: 'centos',
      version: '6.4',
      clamd_service: 'clamd',
      freshclam_service: 'freshclam'
    }
  }.each do |k, v|
    context "a #{k} node" do
      let(:platform) { { platform: v[:platform], version: v[:version] } }
      let(:services) do
        { clamd: v[:clamd_service], freshclam: v[:freshclam_service] }
      end

      context 'with all default attributes' do
        it_behaves_like 'with anything'
        it_behaves_like 'with the clamd service disabled'
        it_behaves_like 'with the freshclam service disabled'
      end

      context 'with the clamd service enabled' do
        let(:attributes) { { clamav: { clamd: { enabled: true } } } }

        it_behaves_like 'with anything'
        it_behaves_like 'with the clamd service enabled'
        it_behaves_like 'with the freshclam service disabled'
      end

      context 'with the freshclam service enabled' do
        let(:attributes) { { clamav: { freshclam: { enabled: true } } } }

        it_behaves_like 'with anything'
        it_behaves_like 'with the clamd service disabled'
        it_behaves_like 'with the freshclam service enabled'
      end

      context 'with both services enabled' do
        let(:attributes) do
          {
            clamav: { clamd: { enabled: true }, freshclam: { enabled: true } }
          }
        end

        it_behaves_like 'with anything'
        it_behaves_like 'with the clamd service enabled'
        it_behaves_like 'with the freshclam service enabled'
      end
    end
  end
end
