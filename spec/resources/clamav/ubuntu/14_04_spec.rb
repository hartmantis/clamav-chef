require_relative '../../../spec_helper'

describe 'resource_clamav::ubuntu::14_04' do
  %i(
    enable_clamd
    enable_freshclam
    clamd_config
    freshclam_config
    version
    dev
    action
  ).each do |a|
    let(a) { nil }
  end
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'clamav', platform: 'ubuntu', version: '14.04'
    ) do |node|
      node.set['clamav']['clamd']['enabled'] = enable_clamd
      node.set['clamav']['freshclam']['enabled'] = enable_freshclam
      node.set['clamav']['clamd']['config'] = clamd_config
      node.set['clamav']['freshclam']['config'] = freshclam_config
      node.set['clamav']['version'] = version
      node.set['clamav']['dev'] = dev
    end
  end
  let(:converge) { runner.converge("resource_clamav_test::#{action}") }

  context 'the default action (:create)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'installs the ClamAV app' do
        expect(chef_run).to install_clamav_app('default')
          .with(version: version, dev: dev || false)
      end

      it 'configures clamd' do
        expect(chef_run).to create_clamav_config('clamd')
          .with(config: Mash.new(clamd_config))
      end

      it 'configures freshclam' do
        expect(chef_run).to create_clamav_config('freshclam')
          .with(config: Mash.new(freshclam_config))
      end

      it 'manages the clamd service' do
        if enable_clamd
          expect(chef_run).to start_clamav_service('clamd')
          expect(chef_run).to enable_clamav_service('clamd')
        else
          expect(chef_run).to stop_clamav_service('clamd')
          expect(chef_run).to disable_clamav_service('clamd')
        end
      end

      it 'manages the freshclam service' do
        if enable_freshclam
          expect(chef_run).to start_clamav_service('freshclam')
          expect(chef_run).to enable_clamav_service('freshclam')
        else
          expect(chef_run).to stop_clamav_service('freshclam')
          expect(chef_run).to disable_clamav_service('freshclam')
        end
      end
    end

    context 'all default attributes' do
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'an overridden version attribute' do
      let(:version) { '1.2.3' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'an overridden dev attribute' do
      let(:dev) { true }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'an overridden clamd config attribute' do
      let(:clamd_config) { { test: 'abcd' } }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'an overridden freshclam config attribute' do
      let(:freshclam_config) { { test: 'abcd' } }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'an overridden clamd service attribute' do
      let(:enable_clamd) { true }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end

    context 'an overridden freshclam service attribute' do
      let(:enable_freshclam) { true }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'stops and disables the clamd service' do
      expect(chef_run).to stop_clamav_service('clamd')
      expect(chef_run).to disable_clamav_service('clamd')
    end

    it 'stops and disables the freshclam service' do
      expect(chef_run).to stop_clamav_service('freshclam')
      expect(chef_run).to disable_clamav_service('freshclam')
    end

    it 'deletes the clamd config' do
      expect(chef_run).to delete_clamav_config('clamd')
    end

    it 'deletes the freshclam config' do
      expect(chef_run).to delete_clamav_config('freshclam')
    end

    it 'removes the ClamAV app' do
      expect(chef_run).to remove_clamav_app('default')
    end
  end
end
