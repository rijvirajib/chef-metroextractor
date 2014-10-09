require 'spec_helper'

describe 'metroextractor::extracts' do
  before do
    stub_command('pgrep postgres').and_return(true)
    stub_command('test -f /var/lib/postgresql/9.3/main/PG_VERSION').and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osmuser'\" | grep osmuser").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c 'SELECT lanname FROM pg_catalog.pg_language' osm | grep '^ plpgsql$'").and_return(true)
    stub_command("psql -c \"SELECT rolname FROM pg_roles WHERE rolname='osm'\" | grep osm").and_return(true)
    stub_command("psql -c \"SELECT datname from pg_database WHERE datname='osm'\" postgres | grep osm").and_return(true)
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic[:memory][:total] = '2048kB'
    end.converge(described_recipe)
  end

  it 'should define the vexdb lockfile' do
    expect(chef_run).to_not create_file '/mnt/metro/.vexdb.lock'
  end

  it 'should create vexdb' do
    expect(chef_run).to run_bash('create vexdb').with(
      user:     'metro',
      cwd:      '/mnt/metro',
      timeout:  7200,
      code:     "    vex memory /mnt/metro/planet-latest.osm.pbf >/mnt/metro/logs/create_vexdb.log 2>&1\n"
    )
  end

  it 'should define the extracts lockfile' do
    expect(chef_run).to_not create_file '/mnt/metro/.extracts.lock'
  end

  it 'should run extracts' do
    expect(chef_run).to run_bash('create extracts').with(
      user:         'metro',
      cwd:          '/mnt/metro',
      code:         "    parallel --jobs 1 -a /opt/metroextractor-scripts/extracts.sh --joblog /mnt/metro/logs/parallel_extracts.log\n",
      timeout:      172_800
    )
  end

end
