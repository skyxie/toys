#!/usr/bin/env ruby

require './node'

list = 12.times.map do
  Random.rand(100)
end

root = list.inject(nil) do |memo, value|
  node = TreeNode.new(value)
  if memo.nil?
    memo = node
  else
    memo.append(node)
  end
  memo
end

puts "UNSORTED LIST: #{list.join(",")}"
puts "SORTED LIST: #{list.sort.join(",")}"

printer = Proc.new { |node| print "#{node.value}," }

print "ASCENDING:"
root.traverseLeft(&printer)
print "\n"

print "DESCENDING:"
root.traverseRight(&printer)
print "\n"

print "TREE:\n#{root.rows().join("\n")}\n"

print "LINKED LIST:"
list_root = root.toList.farLeft
list_root.traverseRight do |node|
  print node
end
print "\n"

