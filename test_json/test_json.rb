#! /usr/bin/env ruby

require 'rubygems'
require 'json'

spec = Gem::Specification.find_by_name("json")
puts "JSON gem version=#{spec.version}"

method = ARGV[-1] == 'parse' ? :parse : :load

class A
  def initialize a, b
   @a = a
   @b = b
  end

  def to_json(*args)
    {'json_class' => self.class.name, 'a' => @a, 'b' => @b}.to_json(args)
  end

  def self.json_create(o)
    new(o['a'], o['b'])
  end

  def inspect
    "Hey, I'm an object! a=#{@a} b=#{@b}"
  end
end

puts JSON.send(method, JSON.generate({"b" => {"a" => 1, "b" => 2}, "a" => A.new(1,2)})).inspect
