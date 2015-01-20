#! /usr/bin/env ruby

require 'rubygems'
require 'json'
require './a'

puts "ruby version=#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
spec = Gem::Specification.find_by_name("json")
puts "JSON gem version=#{spec.version}"

obj = A.new(1, 2)
serialized = JSON.generate(obj)
deserialized_with_parse = JSON.parse(serialized)
deserialized_with_load = JSON.load(serialized)

puts "obj=#{obj}"
puts "serialized=#{serialized}"
puts "deserialized_with_parse=#{deserialized_with_parse.inspect}"
puts "deserialized_with_load=#{deserialized_with_load.inspect}"
