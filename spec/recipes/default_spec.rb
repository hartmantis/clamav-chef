# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::default' do
  let(:includes) do
    %w(
      clamav::users
      clamav::logging
      clamav::freshclam
      clamav::clamd
      clamav::services
      clamav::clamav_scan
    )
  end
  let(:extra_includes) { [] }
  let(:platform) { { platform: nil, version: nil } }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any supported platform' do
    it 'includes all the required recipes' do
      (includes + extra_includes).each do |i|
        expect(chef_run).to include_recipe(i)
      end
    end
  end

  {
    Ubuntu: {
      platform: 'ubuntu',
      version: '12.04',
      includes: %w(clamav::install_deb)
    },
    CentOS: {
      platform: 'centos',
      version: '6.4',
      includes: %w(clamav::install_rpm)
    }
  }.each do |k, v|
    context "a #{k} node" do
      let(:platform) { { platform: v[:platform], version: v[:version] } }
      let(:extra_includes) { v[:includes] }

      context 'with recipes tested in isolation' do
        it_behaves_like 'any supported platform'
      end

      context 'with recipes tested together' do
        before(:each) do
          # Unstub everything intra-cookbook
          allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?)
            .and_call_original
          allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipes)
            .and_call_original

          stub_apt_resources

          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
            .with(/clamav::/).and_call_original
        end

        it_behaves_like 'any supported platform'
      end
    end
  end

  context 'a node of an unsupported platform' do
    let(:platform) { { platform: 'Windows', version: '2008R2' } }
    it 'raises an exception' do
      allow_any_instance_of(Chef::Formatters::Base)
        .to receive(:file_load_failed)
      expect { chef_run }.to raise_error
    end
  end
end
