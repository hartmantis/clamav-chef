require_relative '../../../spec_helper'

describe 'resource_clamav_app::ubuntu::14_04' do
  let(:version) { nil }
  let(:dev) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'clamav_app', platform: 'ubuntu', version: '14.04'
    ) do |node|
      node.set['clamav']['version'] = version
      node.set['clamav']['dev'] = dev
    end
  end
  let(:converge) { runner.converge("resource_clamav_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }

    shared_examples_for 'any attribute set' do
      it 'ensures the APT cache is up to date' do
        expect(chef_run).to include_recipe('apt')
      end

      %w(clamav clamav-daemon clamav-freshclam).each do |p|
        it "installs the #{p} package" do
          expect(chef_run).to install_package(p).with(version: version)
        end
      end
    end

    context 'all default attributes' do
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'does not install the dev package' do
        expect(chef_run).to_not install_package('libclamav-dev')
      end
    end

    context 'an overridden version attribute' do
      let(:version) { '1.2.3' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'does not install the dev package' do
        expect(chef_run).to_not install_package('libclamav-dev')
      end
    end

    context 'an overridden dev attribute' do
      let(:dev) { true }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'installs the dev package' do
        expect(chef_run).to install_package('libclamav-dev')
      end
    end
  end

  context 'the :upgrade action' do
    let(:action) { :upgrade }

    shared_examples_for 'any attribute set' do
      it 'ensures the APT cache is up to date' do
        expect(chef_run).to include_recipe('apt')
      end

      %w(clamav clamav-daemon clamav-freshclam).each do |p|
        it "upgrades the #{p} package" do
          expect(chef_run).to upgrade_package(p).with(version: version)
        end
      end
    end

    context 'all default attributes' do
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'does not upgrade the dev package' do
        expect(chef_run).to_not upgrade_package('libclamav-dev')
      end
    end

    context 'an overridden version attribute' do
      let(:version) { '1.2.3' }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'does not upgrade the dev package' do
        expect(chef_run).to_not upgrade_package('libclamav-dev')
      end
    end

    context 'an overridden dev attribute' do
      let(:dev) { true }
      cached(:chef_run) { converge }

      it_behaves_like 'any attribute set'

      it 'upgrades the dev package' do
        expect(chef_run).to upgrade_package('libclamav-dev')
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    %w(clamav clamav-daemon clamav-freshclam libclamav-dev).each do |p|
      it "removes the #{p} package" do
        expect(chef_run).to remove_package(p)
      end
    end
  end
end
