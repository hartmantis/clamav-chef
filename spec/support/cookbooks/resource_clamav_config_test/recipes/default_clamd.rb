# Encoding: UTF-8

clamav_config 'clamd' do
  config node['clamav']['clamd']['config']
end
