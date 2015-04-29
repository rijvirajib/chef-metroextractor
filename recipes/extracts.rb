#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

bash 'create vexdb' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:vex][:db_timeout]
  code <<-EOH
    vex #{node[:metroextractor][:vex][:db]} #{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]} >#{node[:metroextractor][:setup][:basedir]}/logs/create_vexdb.log 2>&1
  EOH
  only_if   { node[:metroextractor][:extracts][:process] == true }
end

bash 'create extracts' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:extracts][:extracts_timeout]
  code <<-EOH
    parallel --jobs #{node[:metroextractor][:vex][:jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/extracts.sh --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_extracts.log
  EOH
  only_if   { node[:metroextractor][:extracts][:process] == true }
end
