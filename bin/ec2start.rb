#!/usr/bin/env ruby

require 'optparse'
require 'pp'
require 'shellwords'
require 'base64'
require 'aws-sdk-core'
def prompt(*args)
    print(*args)
    gets
end
options = {
  :instance_type => 'c3.large',
  :runlist => 'recipe[tsr-base]',
  :ami => nil,
  :env => 'tsr-prod',
  :placement => 'us-east-1e',
  :prefix => 'tsr',
  :ssh_key => 'fileserver',
  :iam_role => 'provision',
  :action => 'start',
  :name => nil,
  :verbose => false,
  :profile => 'default',
  :region => 'us-east-1'

}
OptionParser.new do |opts|
  opts.banner = "Usage: ec2start [options]"

  opts.on("-a", "--ami AMI_ID", "Use the supplied ami-id") do |ami|
    options[:ami] = ami
  end
  opts.on("-l", "--create-launch-configuration") do
    options[:action] = 'launchconfig'
  end
  opts.on("-t", "--instance-type TYPE") do |type|
    options[:instance_type] = type
  end
  opts.on("-e", "--environment ENV") do |env|
    options[:env] = env
  end
  opts.on("-s", "--security-groups GROUPS") do |security_group|
    options[:security_group] = security_group
  end
  opts.on("-i", "--iam-role ROLE") do |iam_role|
    options[:iam_role] = iam_role
  end
  opts.on("-r", "--run-list RUNLIST", "Example: -r 'recipe[cookbook:recipe], role[rolename]'") do |runlist|
    options[:runlist] = runlist
  end
  opts.on("-p", "--profile AWS_PROFILE") do |profile|
    options[:profile] = profile
  end
  opts.on("--subnet SUBNET") do |subnet|
    options[:subnet] = subnet
  end
  opts.on("-k", "--keypair SSH_PEM") do |keypair|
    options[:ssh_key] = keypair
  end
  opts.on("-z", "--region REGION") do |region|
    options[:region] = region
  end
  opts.on("-c", "--prefix PREFIX") do |prefix|
    options[:prefix] = prefix
  end
  opts.on("-n", "--name NAME") do |name|
    options[:name] = name
  end
  opts.on("-v", "--verbose") do 
    options[:verbose] = true
  end
end.parse!

abort("An ami is required") unless options[:ami]
abort("A name is required for creating a launch configuration") unless options[:action] == "start" || options[:name]

@instance_name = options[:name] || "noname"

Aws.config[:credentials] = Aws::SharedCredentials.new(profile_name:options[:profile])
Aws.config[:region] = options[:region]

def create_bootscript(options)
  puts "Creating bootscript" if options[:verbose]
  bootscript = <<eos
#!/bin/bash
# User data to configure a golden image instance.
CHEF_SERVER_URL="https://api.opscode.com/organizations/ibibi"
NODE_NAME="#{@instance_name}-`curl -s http://169.254.169.254/1.0/meta-data/instance-id/`"
BOOTLOG="/var/log/bootstrap.log"
RUNLIST='recipe[#{options[:prefix]}-base::default],#{options[:runlist]},recipe[#{options[:prefix]}-base::chef-client]'
INIT_RUNLIST='"recipe[#{options[:prefix]}-base::chef-client]"'
CHEF_ENVIRONMENT="#{options[:env]}"

test $UID == 0 || (echo "Error: must run as root"; exit 1)
#mkdir /etc/chef
mkdir -p /etc/chef/ohai/hints
touch /etc/chef/ohai/hints/iam.json
mkdir /var/log/chef

######### STEP 3: CONFIGURE CHEF CLIENT
# Write chef-client config
echo "Writing client configuration..." >>$BOOTLOG
rm -f /etc/chef/client.rb
cat >> /etc/chef/client.rb <<EOF
Encoding.default_external = Encoding::UTF_8
client_fork true
ssl_verify_mode :verify_peer
verify_api_cert true
log_level        :info
log_location     "/var/log/chef/client.log"
validation_client_name "ibibi-validator"
encrypted_data_bag_secret "/etc/chef/encrypted_data_bag_secret"

Ohai::Config[:plugin_path] << "/etc/chef/ohai_plugins"
  
Dir.glob(File.join("/etc/chef", "client.d", "*.rb")).each do |conf|
  Chef::Config.from_file(conf)
end

chef_server_url "$CHEF_SERVER_URL"
node_name              '$NODE_NAME'
environment             '$CHEF_ENVIRONMENT'
EOF

echo "Running chef-client first time..." >>$BOOTLOG
LC_ALL=en_US.utf8 chef-client --once -S $CHEF_SERVER_URL -K /etc/chef/ibibi-validator.pem -r "$RUNLIST" >> $BOOTLOG 2>&1

echo "All done " >>$BOOTLOG
eos
  return bootscript
end

bootscript = create_bootscript options
puts bootscript if options[:verbose]

puts "Launch command: " if options[:verbose]
#launch_command =<<eos
#aws --output text ec2 run-instances --instance-type #{options[:instance_type]} --image-id #{options[:ami]} --iam-instance-profile Name="#{options[:iam_role]}" --key-name #{options[:ssh_key]} --security-groups "#{options[:security_group]}" --placement AvailabilityZone="#{options[:placement]}" --user-data #{bootscript.shellescape}
#eos


def run_instance(options, bootscript)
  puts launch_command if options[:verbose]
  puts "I'm about to launch a #{options[:instance_type]} instance using ami id #{options[:ami]} in environment #{options[:env]} with the following run list: #{options[:runlist]}"
  puts "Security group: #{options[:security_group] || 'none'}, ssh key: #{options[:ssh_key]}, iam role: #{options[:iam_role]}"
  puts "AWS Profile: #{options[:profile]}, region: #{options[:region]}, subnet: #{options[:subnet]}"
  continue = prompt "Go ahead? (Y/N): "
  abort "Aborted" unless continue.strip =~ /y/i 
  #ec2 = Aws.ec2
  ec2 = Aws::EC2::Client.new(region: options[:region])
  launchOpts = {
    dry_run: false,
    image_id: options[:ami],
    min_count: 1,
    max_count: 1,
    key_name: options[:ssh_key],
    instance_type: options[:instance_type],
    placement: {
      availability_zone: options[:placement]
    },
    monitoring: {
      enabled: true
    },
    iam_instance_profile: {
      name: options[:iam_role]
    },
    user_data: Base64.encode64(bootscript)
  }
  if(options[:subnet]) 
    launchOpts['subnet_id'] = options[:subnet] if options[:subnet]
    launchOpts['security_group_ids'] = options[:security_group].split(",")
  else 
    launchOpts['security_group_ids'] = options[:security_group].split(",")
  end
  resp = ec2.run_instances(launchOpts)
  #puts `#{launch_command}`
  instance_id = resp.instances[0].instance_id
  puts "Instance id: #{instance_id} starting, waiting for public IP"
  public_ip = nil
  while !public_ip do
    sleep 5
    info = ec2.describe_instances(instance_ids: [ instance_id ])
    public_ip = info.reservations[0].instances[0].public_dns_name
  end
  if options[:name]
    puts "Tagging with name #{options[:name]}"
    ec2.create_tags(:resources => [instance_id], :tags => [
      { :key => 'Name', :value => options[:name] }
    ])
  end
  puts "Public dns name: #{public_ip}"
end

def create_launch_configuration(options, bootscript)
  puts launch_command if options[:verbose]
  puts "I'm about to create a launch configuration with instance type #{options[:instance_type]} instance using ami id #{options[:ami]} in environment #{options[:env]} with the following run list: #{options[:runlist]}"
  puts "Security group: #{options[:security_group] || 'none'}, ssh key: #{options[:ssh_key]}"
  puts "AWS Profile: #{options[:profile]}, region: #{options[:region]}"
  continue = prompt "Go ahead? (Y/N): "
  abort "Aborted" unless continue.strip =~ /y/i 
  autoscaling = Aws::AutoScaling::Client.new(region: options[:region])
  resp = autoscaling.create_launch_configuration(
    launch_configuration_name: options[:name],
    image_id: options[:ami],
    key_name: options[:ssh_key],
    user_data: Base64.encode64(bootscript),
    instance_type: options[:instance_type],
    instance_monitoring: {
      enabled: true,
    },
    iam_instance_profile: options[:iam_role],
    security_groups: options[:security_group] ? options[:security_group].split(",") : []
  )
  pp resp
end

run_instance(options, bootscript) if options[:action] == "start"
create_launch_configuration(options, bootscript) if options[:action] == "launchconfig"
