class LinkedList
  def initialize value, next_node=nil
    @value = value
    @next_node = next_node
  end
  attr_reader :value, :next_node

  def leaf?
    @next_node.nil?
  end

  def size
    1 + (@next_node.nil? ? 0 : @next_node.size)
  end

  def eql? other_linked_list
    self.value == other_linked_list.value && self.next_node.eql?(other_linked_list.next_node)
  end
end
