#! /usr/bin/env ruby

(0..(ARGV[0].to_i || 10)).inject(0.1) do |sum, i|
  mult = (0.1 * (i+1).to_f)
  diff = (mult - sum).abs
  puts "#{"%2d" % i}) #{"%1.15f" % mult} #{"%1.15f" % sum} #{"%1.15f" % diff}"
  sum + 0.1
end

