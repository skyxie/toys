#! /usr/bin/env ruby

require 'json'
require 'optparse'
require 'erb'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} reads aws instance descriptions in STDIN and output ssh config"
  opts.on("--bastion-username [bastion_username]", String, "username for bastion server") { |bastion_username| options[:bastion_username] = bastion_username }
  opts.on("--ec2-username [ec2_username]", String, "username for ec2 server") { |ec2_username| options[:ec2_username] = ec2_username }
  opts.on("--identity-file [identity_file]", String, "ssh identity file") { |identity_file| options[:identity_file] = identity_file }
end

begin
  parser.parse!
rescue OptionParser::InvalidOption => e
  puts e.message
  puts parser.help
  exit 0
end

if options.size < 3
  puts parser.help
  exit 0
end

reservations = JSON.parse($stdin.read)

hosts = reservations["Reservations"].inject({}) do |memo, reservation|
  reservation["Instances"].map do |instance|
    name_tag_pair = instance["Tags"].find { |tag| tag["Key"] == "Name" }
    if name_tag_pair
      name = name_tag_pair["Value"]
      memo[name] ||= {
        public_ips: [],
        private_ips: []
      }
      memo[name][:private_ips] << instance["PrivateIpAddress"]
      memo[name][:public_ips] << instance["PublicIpAddress"]
    end
  end
  memo
end

_, bastion_ips = *(hosts.find { |name, ips| name =~ /bastion/ })
bastion_ip = bastion_ips[:public_ips].last
bastion_username = options[:bastion_username]
ec2_username = options[:ec2_username]
identity_file = options[:identity_file]

template = File.read("./config.erb")
puts ERB.new(template).result(binding)
