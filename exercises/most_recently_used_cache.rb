
class MostRecentlyUsedCache
  attr_accessor :limit, :head

  Node = Struct.new(:key, :value, :left, :right) do
    def detach
      left.right = right if !left.nil?
      right.left = left if !right.nil?
    end
  end

  def initialize(limit)
    @limit = limit
    @head = nil
    @hash = {}
  end

  def get(key)
    if @hash.has_key?(key)
      node = @hash[key]
      node.detach
      prepend node
      node.value
    end
  end

  def put key, value
    if @hash.has_key?(key)
      @hash[key].value = value
    else
      node = Node.new(key, value)
      @hash[key] = node
      prepend node
    end
  end

  def prune
    _prune(@head, @limit)
  end

  def prepend node
    node.right = @head
    if !@head.nil?
      @head.left = node
    end
    @head = node
  end

  private

  def _prune node, limit
    return if node.nil?

    if limit < 0
      node.detach
      @hash.delete node.key
    end

    _prune(node.right, limit - 1)
  end
end

