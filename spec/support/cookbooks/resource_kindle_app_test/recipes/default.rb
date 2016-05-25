# Encoding: UTF-8

attrs = node['resource_kindle_app_test']

kindle_app attrs['name'] do
  source attrs['source'] unless attrs['source'].nil?
  action attrs['action'] unless attrs['action'].nil?
end
