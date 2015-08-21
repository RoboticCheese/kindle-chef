# Encoding: UTF-8

directory '/Applications/Kindle.app' do
  recursive true
  action :delete
end

include_recipe 'kindle'
