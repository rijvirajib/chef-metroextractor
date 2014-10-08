#
# Cookbook Name:: metroextractor
# Recipe:: vex
#

ark 'vex' do
  url               node[:metroextractor][:vex][:url]
  version           node[:metroextractor][:vex][:version]
  owner             node[:metroextractor][:vex][:user]
  prefix_root       node[:metroextractor][:vex][:basedir]
  has_binaries      ['vex']
  strip_components  0
end
