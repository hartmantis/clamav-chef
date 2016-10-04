# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::clamav_config' do
  include_context 'resources'

  let(:resource) { 'clamav_config' }
  %i(service_name path config).each do |p|
    let(p) { nil }
  end
  let(:properties) do
    { service_name: service_name, path: path, config: config }
  end

  let(:config_dir) { nil }
  let(:user) { nil }
  let(:group) { nil }

  shared_examples_for 'any platform' do
    context 'the default action (:create)' do
      shared_examples_for 'any property set' do
        it 'creates the config directory' do
          expect(chef_run).to create_directory(path || config_dir).with(
            owner: user,
            group: group,
            recursive: true
          )
        end

        it 'creates the config file' do
          expect(chef_run).to create_file(
            "#{path || config_dir}/#{service_name || name}.conf"
          )
        end
      end

      context 'a clamd resource' do
        let(:name) { 'clamd' }

        context 'all default properties' do
          it_behaves_like 'any property set'
        end

        context 'an overridden service_name property' do
          let(:service_name) { 'freshclam' }

          it_behaves_like 'any property set'
        end

        context 'an overridden path property' do
          let(:path) { '/tmp' }

          it_behaves_like 'any property set'
        end

        context 'an overridden config property' do
          let(:config) do
            { max_threads: 42, read_timeout: 200, scan_s_w_f: true }
          end

          it 'renders the expected config file' do
            expected = <<-EOH.gsub(/^ +/, '').strip
              ##############################################
              # This file generated automatically by Chef. #
              # Any local changes will be overwritten.     #
              ##############################################
              LocalSocket /var/run/clamav/clamd.sock
              MaxThreads 42
              ReadTimeout 200
              ScanSWF true
            EOH
            expect(chef_run).to create_file("#{path || config_dir}/clamd.conf")
              .with(content: expected)
          end
        end

        context 'an overridden config property plus some custom ones' do
          let(:config) do
            { max_threads: 42, read_timeout: 200, scan_s_w_f: true }
          end
          let(:properties) do
            super().merge(self_check: 3600, scan_on_access: true)
          end

          it 'renders the expected config file' do
            expected = <<-EOH.gsub(/^ +/, '').strip
              ##############################################
              # This file generated automatically by Chef. #
              # Any local changes will be overwritten.     #
              ##############################################
              LocalSocket /var/run/clamav/clamd.sock
              MaxThreads 42
              ReadTimeout 200
              ScanOnAccess true
              ScanSWF true
              SelfCheck 3600
            EOH
            expect(chef_run).to create_file("#{path || config_dir}/clamd.conf")
              .with(content: expected)
          end
        end
      end

      context 'a freshclam resource' do
        let(:name) { 'freshclam' }

        context 'all default properties' do
          it_behaves_like 'any property set'
        end

        context 'an overridden service_name property' do
          let(:service_name) { 'clamd' }

          it_behaves_like 'any property set'
        end

        context 'an overridden path property' do
          let(:path) { '/tmp' }

          it_behaves_like 'any property set'
        end

        context 'an overridden config property' do
          let(:config) do
            { database_owner: 'clamav', max_attempts: 5 }
          end

          it 'renders the expected config file' do
            expected = <<-EOH.gsub(/^ +/, '').strip
              ##############################################
              # This file generated automatically by Chef. #
              # Any local changes will be overwritten.     #
              ##############################################
              DatabaseMirror db.local.clamav.net
              DatabaseMirror database.clamav.net
              DatabaseOwner clamav
              MaxAttempts 5
            EOH
            expect(chef_run).to create_file(
              "#{path || config_dir}/freshclam.conf"
            ).with(content: expected)
          end
        end

        context 'an overridden config property plus some custom ones' do
          let(:config) do
            { database_owner: 'clamav', max_attempts: 5 }
          end
          let(:properties) do
            super().merge(log_syslog: true, log_facility: 'LOG_LOCAL6')
          end

          it 'renders the expected config file' do
            expected = <<-EOH.gsub(/^ +/, '').strip
              ##############################################
              # This file generated automatically by Chef. #
              # Any local changes will be overwritten.     #
              ##############################################
              DatabaseMirror db.local.clamav.net
              DatabaseMirror database.clamav.net
              DatabaseOwner clamav
              LogFacility LOG_LOCAL6
              LogSyslog true
              MaxAttempts 5
            EOH
            expect(chef_run).to create_file(
              "#{path || config_dir}/freshclam.conf"
            ).with(content: expected)
          end
        end
      end
    end

    context 'the :delete action' do
      let(:action) { :delete }

      shared_examples_for 'any property set' do
        it 'deletes the config file' do
          expect(chef_run).to delete_file(
            "#{path || config_dir}/#{service_name || name}.conf"
          )
        end

        it 'deletes the config directory' do
          expect(chef_run).to delete_directory(path || config_dir)
        end

        it 'deletes the config directory conditionally' do
          pending
          expect(true).to eq(false)
        end
      end

      context 'a clamd resource' do
        let(:name) { 'clamd' }

        context 'all default properties' do
          it_behaves_like 'any property set'
        end

        context 'an overridden service_name property' do
          let(:service_name) { 'freshclam' }

          it_behaves_like 'any property set'
        end

        context 'an overridden path property' do
          let(:path) { '/tmp' }

          it_behaves_like 'any property set'
        end
      end

      context 'a freshclam resource' do
        let(:name) { 'freshclam' }

        context 'all default properties' do
          it_behaves_like 'any property set'
        end

        context 'an overridden service_name property' do
          let(:service_name) { 'clamd' }

          it_behaves_like 'any property set'
        end

        context 'an overridden path property' do
          let(:path) { '/tmp' }

          it_behaves_like 'any property set'
        end
      end
    end
  end
end
