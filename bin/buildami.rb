#!/usr/bin/env ruby
require 'rubygems'
require 'ubuntu_ami'

#family = "trusty"
family = ARGV[2] || "trusty"
virt = ARGV[3] || "paravirtual"
instance_type = virt == "paravirtual" ? 't1.micro' : 't2.micro'
#subnet = ARGV[4] || "subnet-fb919cd3"
ami = "ami-0021766a"
#
#  Ubuntu.release(family).amis.find do |find_ami|
#  find_ami.arch == "amd64" and
#  find_ami.root_store == "ebs" and
#  find_ami.virtualization_type == virt and
#  find_ami.region == "us-east-1"
#end
puts "Using ami #{ami} #{family} #{instance_type} (#{virt})"
puts "Saved as #{ARGV[0]}"
`berks install`
`mkdir dist`
puts "Berks package"
`berks package dist/dist.tar.gz`
puts "Extracting archive"
`tar -xvz -C dist -f dist/dist.tar.gz`
puts "Copying data bags"
`cp -r data_bags dist/`
#packer_cmd = "packer build -var 'ami=#{ami.name}' -var 'family=#{family}' -var \"run_list=#{ARGV[0]}\" packer/builders/vmware.json"
packer_cmd = "packer build -var 'ami=#{ami}' -var 'instance_type=#{instance_type}' -var 'ami-name=#{ARGV[0]}' -var 'family=#{family}' -var \"run_list=#{ARGV[1]}\" packer/builders/ec2-ebs.json"
puts "Running packer with"
puts packer_cmd
output = []
IO.popen(packer_cmd).each do |line|
  print line
  output << line.chomp
end
`rm -Rf dist`
puts "Done"
