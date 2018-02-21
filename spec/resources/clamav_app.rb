
require_relative '../resources'

shared_context 'resources::clamav_app' do
  include_context 'resources'

  let(:resource) { 'clamav_app' }
  %i[version dev].each { |p| let(p) { nil } }
  let(:properties) { { version: version, dev: dev } }
  let(:name) { 'default' }

  let(:base_packages) { nil }
  let(:dev_packages) { nil }

  shared_examples_for 'any platform' do
    context 'the default action (:install)' do
      shared_examples_for 'any property set' do
        it 'installs all the base packages' do
          base_packages.each do |p|
            expect(chef_run).to install_package(p).with(version: version)
          end
        end

        it 'installs the dev packages if asked' do
          dev_packages.each do |p|
            if dev
              expect(chef_run).to install_package(p).with(version: version)
            else
              expect(chef_run).to_not install_package(p)
            end
          end
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden version property' do
        let(:version) { '1.2.3' }

        it_behaves_like 'any property set'
      end

      context 'an overridden dev property' do
        let(:dev) { true }

        it_behaves_like 'any property set'
      end
    end

    context 'the :upgrade action' do
      let(:action) { :upgrade }

      shared_examples_for 'any property set' do
        it 'upgrades all the base packages' do
          base_packages.each do |p|
            expect(chef_run).to upgrade_package(p).with(version: version)
          end
        end

        it 'upgrades the dev packages if asked' do
          dev_packages.each do |p|
            if dev
              expect(chef_run).to upgrade_package(p).with(version: version)
            else
              expect(chef_run).to_not upgrade_package(p)
            end
          end
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden version property' do
        let(:version) { '1.2.3' }

        it_behaves_like 'any property set'
      end

      context 'an overridden dev property' do
        let(:dev) { true }

        it_behaves_like 'any property set'
      end
    end

    context 'the :remove action' do
      let(:action) { :remove }

      it 'purges all the dev packages' do
        dev_packages.each do |p|
          expect(chef_run).to purge_package(p)
        end
      end

      it 'purges all the base packages' do
        base_packages.each do |p|
          expect(chef_run).to purge_package(p)
        end
      end
    end
  end
end
