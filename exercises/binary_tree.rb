
class BinaryTree
  def initialize value, left=nil, right=nil
    @value = value
    @left = left
    @right = right
  end

  def leaf?
    @left.nil? && @right.nil?
  end

  def full?
    leaf? || !@left.nil? && @left.full? && !@right.nil? && @right.full?
  end

  def complete?
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
