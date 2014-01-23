# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'clamav::default' do
  let(:includes) do
    %w{
      clamav::users
      clamav::logging
      clamav::freshclam
      clamav::clamd
      clamav::freshclam_service
      clamav::clamd_service
      clamav::clamav_scan
    }
  end
  let(:extra_includes) { [] }
  let(:platform) { { platform: nil, version: nil } }
  let(:runner) { ChefSpec::Runner.new(platform) }
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
      includes: %w{clamav::install_deb}
    },
    CentOS: {
      platform: 'centos',
      version: '6.4',
      includes: %w{clamav::install_rpm}
    }
  }.each do |k, v|
    context "a #{k} node" do
      let(:platform) { { platform: v[:platform], version: v[:version] } }
      let(:extra_includes) { v[:includes] }

      it_behaves_like 'any supported platform'
    end
  end

  context 'a node of an unsupported platform' do
    let(:platform) { { platform: 'Windows', version: '2008R2' } }
    it 'raises an exception' do
      Chef::Formatters::Base.any_instance.stub(:file_load_failed)
      expect { chef_run }.to raise_error
    end
  end
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby
