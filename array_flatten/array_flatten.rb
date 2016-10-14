#!/usr/bin/env ruby

# recursive
def flatten(input)
  input.reduce([]) do |memo, item|
    if item.is_a? Array
      memo + flatten(item)
    else
      memo << item
    end
  end
end

# iterative
def flatten_it(arr)
  res = []
  stack = []
  stack << arr
  while (stack.size != 0)
    # pop off the stack
    a = stack.shift
    a.each do |i|
      if i.class == Array
        stack << i
      else
        res << i
      end
    end
  end
  res
end

x = [1, [2, [3]], [4, 5]]

puts "x = #{x.inspect}"
puts "flatten(x) = #{flatten(x).inspect}"
puts "flatten_it(x) = #{flatten_it(x).inspect}"

