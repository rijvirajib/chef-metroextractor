#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

file "#{node[:metroextractor][:setup][:basedir]}/.extracts.lock" do
  action :nothing
end

bash 'create extracts' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    parallel --jobs #{node[:metroextractor][:vex][:jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/extracts.sh --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_extracts.log
  EOH
  timeout   node[:metroextractor][:extracts][:extracts_timeout]
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.extracts.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.extracts.lock") }
end
