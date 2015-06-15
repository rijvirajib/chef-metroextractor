#
# Cookbook Name:: metroextractor
# Attributes:: default
#

# if you want to pass json directly, rather than use the git repo
default[:metroextractor][:json]                       = nil

# the following are booleans and tell the cookbook whether or not
#   we should produce certain types of data. Note that in order to produce
#   shapes, you MUST procuce extracts, as the former is constructed from
#   the latter.
default[:metroextractor][:shapes][:process]           = false
default[:metroextractor][:extracts][:process]         = false
default[:metroextractor][:coastlines][:process]       = false

# when the planet is updated in full or in part, create a file off of which
#   subsequent processing will be triggered: either recreation of the vex db
#   or conversion of the planet to .o5m dependin on the backend being used.
default[:metroextractor][:data][:trigger_file]        = '/etc/.metroextractor_data_trigger'

# options are 'vex' or 'osmconvert'
default[:metroextractor][:extracts][:backend]         = 'osmconvert'

# setup
default[:metroextractor][:setup][:basedir]            = '/mnt/metro'
default[:metroextractor][:setup][:scriptsdir]         = '/opt/metroextractor-scripts'
default[:metroextractor][:setup][:cities_repo]        = 'https://github.com/mapzen/metroextractor-cities.git'
default[:metroextractor][:setup][:cities_branch]      = 'master'

# user
default[:metroextractor][:user][:id]                  = 'metro'
default[:metroextractor][:user][:shell]               = '/bin/bash'
default[:metroextractor][:user][:manage_home]         = false
default[:metroextractor][:user][:create_group]        = true
default[:metroextractor][:user][:ssh_keygen]          = false

# imposm
default[:metroextractor][:imposm][:version]           = '0.1'
default[:metroextractor][:imposm][:installdir]        = '/usr/local'
default[:metroextractor][:imposm][:url]               = 'http://imposm.org/static/rel/imposm3-0.1dev-20140702-ced9f92-linux-x86-64.tar.gz'

# postgres
default[:metroextractor][:postgres][:db]              = 'osm'
default[:metroextractor][:postgres][:user]            = 'osm'
default[:metroextractor][:postgres][:password]        = 'password'
default[:postgresql][:data_directory]                 = '/mnt/postgres/data'
default[:postgresql][:autovacuum]                     = 'off'
default[:postgresql][:work_mem]                       = '64MB'
default[:postgresql][:temp_buffers]                   = '128MB'
default[:postgresql][:shared_buffers]                 = '8GB'
default[:postgresql][:maintenance_work_mem]           = '512MB'
default[:postgresql][:checkpoint_segments]            = '100'
default[:postgresql][:max_connections]                = '200'

# planet
default[:metroextractor][:planet][:url]               = 'http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf'
default[:metroextractor][:planet][:file]              = node[:metroextractor][:planet][:url].split('/').last
default[:metroextractor][:planet][:update]            = true  # whether to update the downloaded planet pbf with the latest changeset before processing extracts: set to true if so
default[:metroextractor][:planet_update][:timeout]    = 10_800 # 3 hours

# extracts
default[:metroextractor][:vex][:version]              = '0.0.3'
default[:metroextractor][:vex][:installdir]           = '/usr/local'
default[:metroextractor][:vex][:jobs]                 = node[:cpu][:total]
default[:metroextractor][:vex][:db_timeout]           = 7200
default[:metroextractor][:vex][:db]                   = "#{node[:metroextractor][:setup][:basedir]}/vex_db"
default[:metroextractor][:vex][:url]                  = "https://github.com/mapzen/vanilla-extract/archive/#{node[:metroextractor][:vex][:version]}.tar.gz"

default[:metroextractor][:osmconvert][:timeout]       = 172_800
default[:metroextractor][:osmconvert][:jobs]          = node[:cpu][:total]

# shapes: note that the number of jobs below reflects close to the limit of what the
#   local postgres instance can handle in terms of max connections. Not recommended
#   to change.
default[:metroextractor][:shapes][:imposm_jobs]       = 12
default[:metroextractor][:shapes][:osm2pgsql_jobs]    = 8
default[:metroextractor][:shapes][:osm2pgsql_timeout] = 172_800

# coastlines
default[:coastlines][:generate][:timeout]             = 7_200
default[:coastlines][:water_polygons][:url]           = 'http://data.openstreetmapdata.com/water-polygons-split-4326.zip'
default[:coastlines][:land_polygons][:url]            = 'http://data.openstreetmapdata.com/land-polygons-split-4326.zip'
default[:coastlines][:water_polygons][:file]          = node[:coastlines][:water_polygons][:url].split('/').last
default[:coastlines][:land_polygons][:file]           = node[:coastlines][:land_polygons][:url].split('/').last
