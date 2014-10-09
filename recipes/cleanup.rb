#
# Cookbook Name:: metroextractor
# Recipe:: cleanup
#
# Copyright 2013, Mapzen
#
# All rights reserved - Do Not Redistribute
#

%w(ex shp logs).each do |dir|
  execute 'purge extracts' do
    command "rm -rf #{node[:metroextractor][:setup][:basedir]}/#{dir}/*"
  end
end

execute 'purge vexdb' do
  command "rm -rf #{node[:metroextractor][:vex][:db]}/*"
end

%w(.shapes.lock .extracts.lock .vexdb.lock).each do |lockfile|
  file "#{node[:metroextractor][:setup][:basedir]}/#{lockfile}" do
    action :delete
  end
end
