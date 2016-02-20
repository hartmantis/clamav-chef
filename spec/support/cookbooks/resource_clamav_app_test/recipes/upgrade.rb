# Encoding: UTF-8

clamav_app 'default' do
  version node['clamav']['version']
  dev node['clamav']['dev']
  action :upgrade
end
