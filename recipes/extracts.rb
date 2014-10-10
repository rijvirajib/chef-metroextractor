#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

file "#{node[:metroextractor][:setup][:basedir]}/.vexdb.lock" do
  action :nothing
end

bash 'create vexdb' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:vex][:db_timeout]
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.vexdb.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.vexdb.lock") }
  code <<-EOH
    vex #{node[:metroextractor][:vex][:db]} #{node[:metroextractor][:planet][:basedir]}/#{node[:metroextractor][:planet][:file]} >#{node[:metroextractor][:setup][:basedir]}/logs/create_vexdb.log 2>&1
  EOH
end

file "#{node[:metroextractor][:setup][:basedir]}/.extracts.lock" do
  action :nothing
end

bash 'create extracts' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:extracts][:extracts_timeout]
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.extracts.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.extracts.lock") }
  code <<-EOH
    parallel --jobs #{node[:metroextractor][:vex][:jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/extracts.sh --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_extracts.log
  EOH
end
