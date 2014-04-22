#
# Cookbook Name:: metroextractor
# Recipe:: previews
#

file node[:metroextractor][:previews][:lock] do
  action  :nothing
end

execute "python compose-city-previews.py #{node[:metroextractor][:setup][:basedir]}/previews" do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:scriptsdir]
  notifies :create, "file[#{node[:metroextractor][:previews][:lock]}]", :immediately
  not_if { ::File.exist?(node[:metroextractor][:previews][:lock]) }
end
