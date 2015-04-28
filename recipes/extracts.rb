#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

bash 'osmconvert' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    parallel -j #{node[:metroextractor][:extracts][:osmconvert_jobs]} -a #{node[:metroextractor][:setup][:scriptsdir]}/osmconvert.sh --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_osmconvert.log
  EOH
  timeout node[:metroextractor][:extracts][:osmconvert_timeout]
  only_if { node[:metroextractor][:extracts][:process] == true }
end
