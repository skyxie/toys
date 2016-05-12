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

sorted_list = list.sort
puts "SORTED LIST: #{sorted_list.join(",")}"

printer = Proc.new { |node| print "#{node.value}," }

print "ASCENDING:"
root.traverseLeft(&printer)
print "\n"

print "DESCENDING:"
root.traverseRight(&printer)
print "\n"

print "TREE:\n#{root.rows().join("\n")}\n"

puts "DEPTH: #{root.depth} SIZE: #{root.size} BALANCED? #{root.balanced?}"

print "LINKED LIST:"
list_root = root.toList.farLeft
list_root.traverseRight do |node|
  print node
end
print "\n\n"

puts "TREE BRANCH SUMS:"
root.traverseMidLeft([]) do |node, memo|
  if node.leaf?
    total = memo.inject(0) do |sum, memo_node|
      sum + memo_node.value
    end
    total += node.value

    puts "#{memo.join(" + ")} + #{node} = #{total}"
  else
    memo << node
  end
  memo
end
puts

puts "TREE COLUMNS:"
cols = []
root.columns(cols)
max_depth = cols.map(&:size).max

(0..max_depth).each do |row|
  cols.each do |col|
    if col.size > row
      printf " %0.2d ", col[row]
    else
      print " " * 4
    end
  end
  print "\n"
end

