#
# Cookbook Name:: metroextractor
# Recipe:: extracts
#

execute 'create extracts' do
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  timeout   node[:metroextractor][:osmconvert][:timeout]
  notifies  :run, 'execute[fix osmconvert perms]', :immediately
  command <<-EOH
    parallel -j #{node[:metroextractor][:osmconvert][:jobs]} \
      -a #{node[:metroextractor][:setup][:scriptsdir]}/extracts.sh \
      --joblog #{node[:metroextractor][:setup][:basedir]}/logs/parallel_extracts.log
  EOH
  only_if { node[:metroextractor][:process][:extracts] == true }
end

execute 'fix osmconvert perms' do
  action    :nothing
  user      node[:metroextractor][:user][:id]
  cwd       node[:metroextractor][:setup][:basedir]
  command   'chmod 644 ex/*'
  only_if   { node[:metroextractor][:process][:extracts] == true }
end
