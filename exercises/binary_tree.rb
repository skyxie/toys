require 'linked_list'

class BinaryTree
  def initialize value, left=nil, right=nil
    @value = value
    @left = left
    @right = right
  end
  attr_reader :value

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
    (@left.nil? || @left.balanced?) &&
    (@right.nil? || @right.balanced?) &&
    ((@left.nil? ? 0 : @left.height) - (@right.nil? ? 0 : @right.height)).abs <= 1
  end

  def size
    1 + (@left.nil? ? 0 : @left.size) + (@right.nil? ? 0 : @right.size)
  end

  def height
    1 + [(@left.nil? ? 0 : @left.height), (@right.nil? ? 0 : @right.height)].max
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

  def bst?
    (@left.nil? || @left.bst? && @left.value <= @value) &&
      (@right.nil? || @right.bst? && @right.value > @value)
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
