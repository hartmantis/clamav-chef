
require_relative '../../clamav'

describe 'resources::clamav::ubuntu::14_04' do
  include_context 'resources::clamav'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }

  it_behaves_like 'any platform'
end
