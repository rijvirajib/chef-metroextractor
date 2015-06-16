#
# Cookbook Name:: metroextractor
# Recipe:: planet
#

# override tempfile location so the planet download
#   temp file goes somewhere with enough space
ENV['TMP'] = node[:metroextractor][:setup][:basedir]

# fail if someone tries to pull something other than
#   a pbf data file
fail if node[:metroextractor][:planet][:file] !~ /\.pbf$/

remote_file "#{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]}.md5" do
  action    :create_if_missing
  backup    false
  source    "#{node[:metroextractor][:planet][:url]}.md5"
  mode      0644
  notifies  :run, 'execute[download planet]',   :immediately
  notifies  :run, 'ruby_block[verify md5]',     :immediately
  notifies  :run, 'execute[osmconvert planet]', :immediately
end

execute 'download planet' do
  action  :nothing
  user    node[:metroextractor][:user][:id]
  command <<-EOH
    wget --quiet \
      -O #{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]} \
      #{node[:metroextractor][:planet][:url]}
  EOH
end

ruby_block 'verify md5' do
  action :nothing
  block do
    require 'digest'

    planet_md5  = Digest::MD5.file("#{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]}").hexdigest
    md5         = File.read("#{node[:metroextractor][:setup][:basedir]}/#{node[:metroextractor][:planet][:file]}.md5").split(' ').first

    if planet_md5 != md5
      Chef::Log.info('Failure: the md5 of the planet we downloaded does not appear to be correct. Aborting.')
      abort
    end
  end
end

execute 'osmconvert planet' do
  action  :nothing
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  timeout node[:metroextractor][:osmconvert][:timeout]
  command <<-EOH
    osmconvert #{node[:metroextractor][:planet][:file]} -o=planet.o5m \
      >#{node[:metroextractor][:setup][:basedir]}/logs/osmconvert_planet.log 2>&1
  EOH
end

# cron
template "#{node[:metroextractor][:setup][:scriptsdir]}/update_planet.sh" do
  owner   node[:metroextractor][:user][:id]
  mode    0755
  source  'update_planet.sh.erb' 
end

cron 'update planet' do
  command <<-EOH
    #{node[:metroextractor][:setup][:scriptsdir]}/update_planet.sh \
      >#{node[:metroextractor][:setup][:basedir]}/logs/update_planet.log 2>&1
  EOH
  user    node[:metroextractor][:user][:id]
  cwd     node[:metroextractor][:setup][:basedir]
  home    node[:metroextractor][:setup][:basedir]
  time    :midnight
end
