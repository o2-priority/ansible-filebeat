require '/tmp/kitchen/spec/spec_helper.rb'

filebeat_conf_dir = '/etc/filebeat'
filebeat_data_dir = '/var/lib/filebeat'
filebeat_file_output_path = '/var/tmp/filebeat'

describe package('filebeat') do
  it { should be_installed }
end

describe file(filebeat_data_dir) do
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by 'root' }
end

%W(
  #{filebeat_conf_dir}
  #{filebeat_file_output_path}
).each do |d|
  describe file(d) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
  end
end

describe file("#{filebeat_conf_dir}/filebeat.yml") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

service_startup_file = '/lib/systemd/system/filebeat.service'
if os[:family] =~ /redhat|centos/
  service_startup_file = '/usr/lib/systemd/system/filebeat.service'
elsif os[:family] == 'ubuntu' and os[:release] == '14.04'
  service_startup_file = '/etc/init.d/filebeat'
  describe file(service_startup_file) do
    it { should be_executable }
    it { should be_owned_by 'root' }
  end
end

describe file(service_startup_file) do
  it { should be_file }
  it { should be_owned_by 'root' }
end

describe service('filebeat') do
  it { should be_running }
end
