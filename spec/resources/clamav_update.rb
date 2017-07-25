# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::clamav_update' do
  include_context 'resources'

  let(:resource) { 'clamav_update' }
  %i[source].each { |p| let(p) { nil } }
  let(:properties) { { source: source } }
  let(:name) { 'default' }

  shared_examples_for 'any platform' do
    context 'the default action (:run)' do
      shared_examples_for 'any property set' do
        it 'runs a clamav_update resource' do
          expect(chef_run).to run_clamav_update(name)
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'

        it 'shells out to run freshclam' do
          expect(chef_run).to run_execute('freshclam')
        end
      end

      context 'an overridden source property' do
        let(:source) { :direct }

        it_behaves_like 'any property set'

        %w[main.cvd daily.cvd bytecode.cvd].each do |f|
          it "downloads #{f} from database.clamav.net" do
            expect(chef_run).to create_remote_file("/var/lib/clamav/#{f}")
              .with(source: "http://database.clamav.net/#{f}")
          end
        end
      end

      context 'another overridden source property' do
        let(:source) { 'file:///tmp/cache' }

        it_behaves_like 'any property set'

        %w[main.cvd daily.cvd bytecode.cvd].each do |f|
          it "downloads #{f} from the custom source" do
            expect(chef_run).to create_remote_file("/var/lib/clamav/#{f}")
              .with(source: "file:///tmp/cache/#{f}")
          end
        end
      end
    end
  end
end
