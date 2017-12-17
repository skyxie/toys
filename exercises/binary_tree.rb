require 'linked_list'

class BinaryTree
  def initialize value, left=nil, right=nil
    @value = value
    @left = left
    @right = right
  end
  attr_reader :value, :left, :right

  def children
    [@left, @right]
  end

  def leaf?
    @left.nil? && @right.nil?
  end

  def full?
    leaf? || !@left.nil? && @left.full? && !@right.nil? && @right.full?
  end

  def perfect?
    complete? && full?
  end

  # A tree is balanced if the heights of 2 subtrees are not different by more than 1
  # for each subtree
  def balanced?
    height do |left_height, right_height|
      if (left_height - right_height).abs > 1
        return false
      end
    end

    return true
  end

  def size
    1 + (@left.nil? ? 0 : @left.size) + (@right.nil? ? 0 : @right.size)
  end

  def height &block
    left_height = @left.nil? ? 0 : @left.height(&block)
    right_height = @right.nil? ? 0 : @right.height(&block)
    block.call left_height, right_height if !block.nil?
    1 + [left_height, right_height].max
  end

  def each_depth &block
    frontier = [self]
    current_depth = 0
    loop do
      block.call(frontier, current_depth)
      next_layer = frontier.reduce([]) do |acc, n|
        acc + (n.nil? ? [nil, nil] : n.children)
      end
      break if next_layer.all?(&:nil?)
      current_depth += 1
      frontier = next_layer
    end
  end

  # A binary tree is complete if each depth is filled with nodes from the left to the right
  def complete?
    last_layer = true # If the previous layer had an empty branch

    each_depth do |layer, depth|
      return false if !last_layer
      nil_exists = false # If an empty branch exists at the current layer

      layer.each do |n|
        if n.nil?
          nil_exists = true
        elsif nil_exists
          return false
        end
      end

      last_layer = false if nil_exists
    end

    true
  end

  # Generate a linked list at each depth of the tree
  def linked_list_per_depth
    list = Array.new(height)
    each_depth do |layer, depth|
      n = layer.size - 1
      list[depth] = (0..n).reduce(nil) do |acc, i|
        layer[n-i].nil? ? acc : LinkedList.new(layer[n-i].value, acc)
      end
    end
    list
  end

  # A tree is a binary search tree (BST) if for every node,
  # all left nodes have values <= current node value
  # all right nodes have values > current node value
  def bst?
    with_values do |left_vals, value, right_vals|
      left_max, right_min = left_vals.max, right_vals.min
      return false if (!left_max.nil? && left_max > value) ||
                     (!right_min.nil? && right_min <= value)
    end
    true
  end

  def with_values &block
    left_values = @left.nil? ? [] : @left.with_values(&block)
    right_values = @right.nil? ? [] : @right.with_values(&block)
    block.call(left_values, @value, right_values) if !block.nil?
    left_values + [@value] + right_values
  end

  def common_ancestor a, b
    return a if a == b

    a_path = nil
    b_path = nil

    bfs do |node, path|
      a_path = path if node == a
      b_path = path if node == b
      if !a_path.nil? && !b_path.nil?
        (1..([a_path.size, b_path.size].min - 1)).each do |i|
          return a_path[i-1] if a_path[i] != b_path[i]
        end
      end
    end

    return nil # Could not find at least one node
  end

  def bfs &block
    paths = [[self]]
    loop do
      break if paths.empty?

      current_path = paths.shift
      current_node = current_path.last

      block.call current_node, current_path

      paths.push(current_path + [current_node.left]) if !current_node.left.nil?
      paths.push(current_path + [current_node.right]) if !current_node.right.nil?
    end
  end

  def self.create_from_sorted_integers values
    return nil if values.empty?
    m = values.length / 2
    BinaryTree.new(
      values[m],
      create_from_sorted_integers(values.slice(0, m)),
      create_from_sorted_integers(values.slice(m+1, m))
    )
  end
end
