#! /usr/bin/env ruby

require 'json'
require 'rational'

msg = { "aspect_ratio" => Rational(16,9)}

puts msg.to_json

require 'active_support/core_ext/object'

puts msg.to_json
