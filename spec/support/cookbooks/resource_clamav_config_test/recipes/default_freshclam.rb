# Encoding: UTF-8

clamav_config 'freshclam' do
  config node['clamav']['freshclam']['config']
end
