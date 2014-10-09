#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

bash 'create vexdb' do
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  timeout node[:metroextractor][:vex][:db_timeout]
  code <<-EOH
    rm -rf #{node[:metroextractor][:vex][:db]}/*
    vex #{node[:metroextractor][:vex][:db]} #{node[:metroextractor][:planet][:basedir]}/#{node[:metroextractor][:planet][:file]}
  EOH
end

bash 'create extracts' do
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  timeout node[:metroextractor][:extracts][:extracts_timeout]
  code <<-EOH
    parallel --jobs #{node[:metroextractor][:vex][:jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/extracts.sh --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_extracts.log
  EOH
end
