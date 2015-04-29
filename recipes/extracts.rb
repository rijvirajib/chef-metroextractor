#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

execute 'create vexdb' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:vex][:db_timeout]
  only_if   { node[:metroextractor][:extracts][:process] == true }
  command <<-EOH
    vex #{node[:metroextractor][:vex][:db]} \
      #{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]} \
      >#{node[:metroextractor][:setup][:basedir]}/logs/create_vexdb.log 2>&1
  EOH
end

execute 'create extracts' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:extracts][:extracts_timeout]
  only_if   { node[:metroextractor][:extracts][:process] == true }
  command <<-EOH
    parallel --jobs #{node[:metroextractor][:vex][:jobs]} \
      -a #{node[:metroextractor][:setup][:scriptsdir]}/extracts.sh \
      --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_extracts.log
  EOH
end
