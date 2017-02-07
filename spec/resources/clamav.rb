# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::clamav' do
  include_context 'resources'

  let(:resource) { 'clamav' }
  %i(
    enable_clamd
    enable_freshclam
    clamd_config
    freshclam_config
    version
    dev
  ).each do |p|
    let(p) { nil }
  end
  let(:properties) do
    {
      enable_clamd: enable_clamd,
      enable_freshclam: enable_freshclam,
      clamd_config: clamd_config,
      freshclam_config: freshclam_config,
      version: version,
      dev: dev
    }
  end
  let(:name) { 'default' }

  shared_examples_for 'any platform' do
    context 'the default action (:create)' do
      shared_examples_for 'any attribute set' do
        it 'creates the clamav resource' do
          expect(chef_run).to create_clamav('default')
        end

        it 'installs the ClamAV app' do
          expect(chef_run).to install_clamav_app('default')
            .with(version: version, dev: dev || false)
        end

        it 'configures freshclam' do
          expect(chef_run).to create_clamav_config('freshclam')
            .with(config: defaults[:freshclam_config]
                          .merge(freshclam_config.to_h))
          if enable_freshclam
            expect(chef_run.clamav_config('freshclam'))
              .to notify('clamav_service[freshclam]').to(:restart)
          else
            expect(chef_run.clamav_config('freshclam'))
              .to_not notify('clamav_service[freshclam]').to(:restart)
          end
        end

        it 'configures clamd' do
          expect(chef_run).to create_clamav_config('clamd')
            .with(config: defaults[:clamd_config].merge(clamd_config.to_h))
          if enable_clamd
            expect(chef_run.clamav_config('clamd'))
              .to notify('clamav_service[clamd]').to(:restart)
          else
            expect(chef_run.clamav_config('clamd'))
              .to_not notify('clamav_service[clamd]').to(:restart)
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

        it 'manages the clamd service' do
          if enable_clamd
            expect(chef_run).to start_clamav_service('clamd')
            expect(chef_run).to enable_clamav_service('clamd')
          else
            expect(chef_run).to stop_clamav_service('clamd')
            expect(chef_run).to disable_clamav_service('clamd')
          end
        end
      end

      context 'all default attributes' do
        it_behaves_like 'any attribute set'
      end

      context 'an overridden version attribute' do
        let(:version) { '1.2.3' }

        it_behaves_like 'any attribute set'
      end

      context 'an overridden dev attribute' do
        let(:dev) { true }

        it_behaves_like 'any attribute set'
      end

      context 'an overridden clamd config attribute' do
        let(:clamd_config) { { testopolis: 'abcd' } }

        it_behaves_like 'any attribute set'
      end

      context 'an overridden freshclam config attribute' do
        let(:freshclam_config) { { testopolis: 'abcd' } }

        it_behaves_like 'any attribute set'
      end

      context 'an overridden clamd service attribute' do
        let(:enable_clamd) { true }

        it_behaves_like 'any attribute set'
      end

      context 'an overridden freshclam service attribute' do
        let(:enable_freshclam) { true }

        it_behaves_like 'any attribute set'
      end
    end

    context 'the :remove action' do
      let(:action) { :remove }

      it 'removes the clamav resource' do
        expect(chef_run).to remove_clamav('default')
      end

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
end
