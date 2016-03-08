# Encoding: UTF-8
clamav 'default' do
  version node['clamav']['version']
  dev node['clamav']['dev']
  enable_clamd node['clamav']['clamd']['enabled']
  enable_freshclam node['clamav']['freshclam']['enabled']
  clamd_config node['clamav']['clamd']['config']
  freshclam_config node['clamav']['freshclam']['config']
end
