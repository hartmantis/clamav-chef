
require_relative '../resources'

shared_context 'resources::clamav_service' do
  include_context 'resources'

  let(:resource) { 'clamav_service' }
  %i[service_name].each { |p| let(p) { nil } }
  let(:properties) { { service_name: service_name } }

  let(:data_dir) { nil }
  let(:clamd_service) { nil }
  let(:freshclam_service) { nil }

  shared_examples_for 'any platform' do
    context 'the default action (:nothing)' do
      shared_examples_for 'any property set' do
        it 'does nothing' do
          expect(chef_run.clamav_service(name)).to do_nothing
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
      end

      context 'a freshclam resource' do
        let(:name) { 'clamd' }

        context 'all default properties' do
          it_behaves_like 'any property set'
        end

        context 'an overridden service_name property' do
          let(:service_name) { 'clamd' }

          it_behaves_like 'any property set'
        end
      end
    end

    %i[enable disable start stop].each do |a|
      context "the :#{a} action" do
        let(:action) { a }

        shared_examples_for 'any property set' do
          it 'runs freshclam if it needs to' do
            if a == :start && (service_name || name) == 'clamd'
              expect(chef_run).to run_execute(
                'Ensure virus definitions exist so clamd can start'
              ).with(command: 'freshclam',
                     creates: "#{data_dir}/main.cvd")
            end
          end

          it 'passes the action on to a regular service resource' do
            expect(chef_run).to send(
              "#{a}_service", send("#{service_name || name}_service")
            ).with(supports: { status: true, restart: true })
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
        end

        context 'a freshclam resource' do
          let(:name) { 'clamd' }

          context 'all default properties' do
            it_behaves_like 'any property set'
          end

          context 'an overridden service_name property' do
            let(:service_name) { 'clamd' }

            it_behaves_like 'any property set'
          end
        end
      end
    end
  end
end
