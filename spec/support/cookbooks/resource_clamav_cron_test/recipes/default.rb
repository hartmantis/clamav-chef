# Encoding: UTF-8
clamav_cron 'default' do
  minute node['clamav']['cron']['minute']
  hour node['clamav']['cron']['hour']
  day node['clamav']['cron']['day']
  month node['clamav']['cron']['month']
  weekday node['clamav']['cron']['weekday']
  paths node['clamav']['cron']['paths'] if node['clamav']['cron']['paths']
end
