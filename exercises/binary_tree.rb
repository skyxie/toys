
class BinaryTree
  def initialize value, left=nil, right=nil
    @value = value
    @left = left
    @right = right
  end

  def children
    [@left, @right]
  end

  def leaf?
    @left.nil? && @right.nil?
  end

  def full?
    leaf? || !@left.nil? && @left.full? && !@right.nil? && @right.full?
  end

  def complete?
    last_layer = true # If the previous layer had an empty branch

    each_height do |layer, h|
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

  def perfect?
    complete? && full?
  end

  def balanced?
    ((@left.nil? ? 0 : @left.height) - (@right.nil? ? 0 : @right.height)).abs <= 1 &&
      (@left.nil? || @left.balanced?) &&
      (@right.nil? || @right.balanced?)
  end

  def size
    1 + (@left.nil? ? 0 : @left.size) + (@right.nil? ? 0 : @right.size)
  end

  def height
    1 + [(@left.nil? ? 0 : @left.height), (@right.nil? ? 0 : @right.height)].max
  end

  def each_height &block
    frontier = [self]
    current_height = 0
    loop do
      block.call(frontier, current_height)
      next_layer = frontier.reduce([]) do |acc, n|
        acc + (n.nil? ? [nil, nil] : n.children)
      end
      break if next_layer.all?(&:nil?)
      current_height += 1
      frontier = next_layer
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
