#
# Cookbook Name:: metroextractor
# Recipe:: coastlines
#

file "#{node[:metroextractor][:setup][:basedir]}/.coastlines.lock" do
  action :nothing
end

bash 'wget water polygons' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    wget #{node[:coastlines][:water_polygons][:url]} && unzip #{node[:coastlines][:water_polygons][:file]}
  EOH
end

bash 'wget land polygons' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    wget #{node[:coastlines][:land_polygons][:url]} && unzip #{node[:coastlines][:land_polygons][:file]}
  EOH
end

bash 'generate coastlines' do
  user node[:metroextractor][:user][:id]
  cwd  node[:metroextractor][:setup][:basedir]
  code <<-EOH
    #{node[:metroextractor][:setup][:scriptsdir]}/coastlines.sh >#{node[:metroextractor][:setup][:basedir]}/logs/coastlines.log 2>&1
  EOH
  notifies  :create, "file[#{node[:metroextractor][:setup][:basedir]}/.coastlines.lock]", :immediately
  not_if    { ::File.exist?("#{node[:metroextractor][:setup][:basedir]}/.coastlines.lock") }
end
