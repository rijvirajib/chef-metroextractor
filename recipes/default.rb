#
# Cookbook Name:: metroextractor
# Recipe:: default
#

%w(
  apt::default
  metroextractor::postgres
  metroextractor::user
  metroextractor::setup
  metroextractor::planet
).each do |r|
  include_recipe r
end

include_recipe 'metroextractor::extracts'   if node[:metroextractor][:extracts][:process]   == true
include_recipe 'metroextractor::shapes'     if node[:metroextractor][:shapes][:process]     == true
include_recipe 'metroextractor::coastlines' if node[:metroextractor][:coastlines][:process] == true
