#
# Cookbook Name:: metroextractor
# Recipe:: setup
#

include_recipe 'osm2pgsql::default'

%w(
  build-essential
  osmctools
  gdal-bin
  parallel
  pbzip2
  zip
  git
).each do |p|
  package p
end

# imposm
ark 'imposm3' do
  owner         'root'
  url           node[:metroextractor][:imposm][:url]
  version       node[:metroextractor][:imposm][:version]
  prefix_root   node[:metroextractor][:imposm][:installdir]
  has_binaries  ['imposm3']
end

# scripts basedir
directory node[:metroextractor][:setup][:scriptsdir] do
  owner node[:metroextractor][:user][:id]
end

# cities
file "#{node[:metroextractor][:setup][:scriptsdir]}/cities.json" do
  owner     node[:metroextractor][:user][:id]
  content   node[:metroextractor][:json]
  only_if   { node[:metroextractor][:json] }
end

# scripts
%w(extracts.sh shapes.sh coastlines.sh).each do |t|
  template "#{node[:metroextractor][:setup][:scriptsdir]}/#{t}" do
    owner   node[:metroextractor][:user][:id]
    source  "#{t}.erb"
    mode    0755
    only_if { ::File.exist?("#{node[:metroextractor][:setup][:scriptsdir]}/cities.json") }
  end
end

%w(osm2pgsql.style merge-geojson.py mapping.json).each do |f|
  cookbook_file "#{node[:metroextractor][:setup][:scriptsdir]}/#{f}" do
    owner   node[:metroextractor][:user][:id]
    source  f
    mode    0644
  end
end

%w(ex logs shp coast).each do |d|
  directory "#{node[:metroextractor][:setup][:basedir]}/#{d}" do
    owner node[:metroextractor][:user][:id]
  end
end
