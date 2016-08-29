# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::clamav_config' do
  include_context 'resources'

  let(:resource) { 'clamav_config' }
  %i(service path config).each do |p|
    let(p) { nil }
  end
  let(:properties) { { service: service, path: path, config: config } }

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
            "#{path || config_dir}/#{service || name}.conf"
          )
        end
      end

      context 'a clamd resource' do
        let(:name) { 'clamd' }

        context 'all default properties' do
          it_behaves_like 'any property set'
        end

        context 'an overridden service property' do
          let(:service) { 'freshclam' }

          it_behaves_like 'any property set'
        end

        context 'an overridden path property' do
          let(:path) { '/tmp' }

          it_behaves_like 'any property set'
        end

        context 'an overridden config property' do
          let(:config) { { test: 'test' } }

          it 'does something' do
            pending
            expect(true).to eq(false)
          end
        end
      end

      context 'a freshclam resource' do
        let(:name) { 'freshclam' }

        context 'all default properties' do
          it_behaves_like 'any property set'
        end

        context 'an overridden service property' do
          let(:service) { 'clamd' }

          it_behaves_like 'any property set'
        end

        context 'an overridden path property' do
          let(:path) { '/tmp' }

          it_behaves_like 'any property set'
        end

        context 'an overridden config property' do
          let(:config) { { test: 'test' } }

          it 'does something' do
            pending
            expect(true).to eq(false)
          end
        end
      end
    end

    context 'the :delete action' do
      let(:action) { :delete }


      shared_examples_for 'any property set' do
        it 'deletes the config file' do
          expect(chef_run).to delete_file(
            "#{path || config_dir}/#{service || name}.conf"
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

        context 'an overridden service property' do
          let(:service) { 'freshclam' }

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

        context 'an overridden service property' do
          let(:service) { 'clamd' }

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
