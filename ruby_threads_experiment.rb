#! /usr/bin/env ruby

require 'benchmark'

def factorial(x)
  return 1 if x == 0
  x * factorial(x-1)
end

puts "Without threads:"
puts Benchmark.measure {
  1000.times.each do |i|
    factorial(i)
  end
}

puts "With threads:"
puts Benchmark.measure {
  1000.times.map do |i|
    Thread.new do
      factorial(i)
    end
  end.join
}

