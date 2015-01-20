#!/usr/bin/env ruby

HELP = <<_HELP_
#{$0} <maps file>

Determines the size of memory allocated for every line noted in /proc/<pid>/maps
_HELP_

def exit_with_help msg
  puts msg if msg
  puts HELP
  exit(1)
end

# Reduces size measured in bytes to a human-readable size
def human_size size_bytes
  size = size_bytes
  type = "B"

  %w{KB MB GB}.each do |t|
    if size > 1024
      size = size/1024
      type = t
    else
      break
    end
  end

  "#{size}#{type}"
end

def parse_maps_line line
  maps_line = line.gsub(/\s+/, ' ').split(' ')
  address_range = maps_line[0]

  addresses = address_range.split("-")
  if addresses.length != 2
    exit_with_help("Invalid address format, expects address1-address2")
  end

  int1, int2 = *(addresses.map { |a| a.to_i(16) })
  size = int2 - int1
  
  out = []
  out.push human_size(size)
  out = out.concat(maps_line[0..4])
  out.push(maps_line[5] || "")

  puts "%7s %-33s %4s %8s %5s %8s %-s" % out
end

if !ARGV[0]
  exit_with_help("Invalid number of arguments")
end

if !File.exists?(ARGV[0])
  exit_with_help("maps file not found!")
end

maps_file = ARGV[0]
File.readlines(maps_file).each do |line|
  parse_maps_line line.chomp
end
