#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

execute 'osmconvert planet' do
  action  :nothing
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  timeout node[:metroextractor][:extracts][:osmconvert_timeout]
  code <<-EOH
    osmconvert #{node[:metroextractor][:planet][:file]} -o=planet.o5m > #{node[:metroextractor][:setup][:basedir]}/logs/osmconvert_planet.log 2>&1
  EOH
end

execute 'osmconvert cities' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    parallel -j #{node[:metroextractor][:extracts][:osmconvert_jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/osmconvert.sh --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_osmconvert.log
  EOH
  timeout   node[:metroextractor][:extracts][:osmconvert_timeout]
  notifies  :run, 'execute[fix osmconvert perms]', :immediately
  only_if   { node[:metroextractor][:extracts][:process] == true }
end

execute 'fix osmconvert perms' do
  action  :nothing
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  code    'chmod 644 ex/*'
end
