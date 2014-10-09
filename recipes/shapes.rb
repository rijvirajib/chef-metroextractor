#
# Cookbook Name:: metroextractor
# Recipe:: shapes
#

file "#{node[:metroextractor][:setup][:basedir]}/.shapes.lock" do
  action :nothing
end

execute 'create shapes' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  command   "#{node[:metroextractor][:setup][:scriptsdir]}/shapes.sh"
  timeout   node[:metroextractor][:shapes][:osm2pgsql_timeout]
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.shapes.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.shapes.lock") }
end
