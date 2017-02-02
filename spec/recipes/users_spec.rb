# Encoding: UTF-8

require 'spec_helper'

describe 'clamav::users' do
  let(:user) { 'clamav' }
  let(:group) { 'clamav' }
  let(:attributes) { {} }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      attributes.each { |k, v| node.override[k] = v }
    end.converge(described_recipe)
  end

  shared_examples_for 'a node with the default clamav user' do
    it 'creates the clamav user' do
      expect(chef_run).to create_user('clamav').with(
        system: true,
        shell: '/sbin/nologin'
      )
    end

    it 'creates the PID file directory' do
      expect(chef_run).to create_directory('/var/run/clamav')
        .with(user: user, group: group, recursive: true)
    end
  end

  context 'an entirely default node' do
    it_behaves_like 'a node with the default clamav user'

    it 'does not create a clamav group' do
      expect(chef_run).to_not create_group('clamav')
    end
  end

  context 'a node with a different user and group' do
    let(:group) { 'other_clamav' }
    let(:attributes) { { clamav: { group: group } } }

    it_behaves_like 'a node with the default clamav user'

    it 'also creates a clamav group' do
      expect(chef_run).to create_group('other_clamav').with(
        members: [user],
        system: true
      )
    end
  end
end
