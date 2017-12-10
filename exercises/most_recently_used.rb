
class Cache
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

describe Cache do
  let(:cache) { Cache.new(5) }

  before(:each) do
    %w{Boston NYC Philadelphia Pittsburgh DC Cleveland Chicago}.each_with_index do |city, i|
      cache.put(i, city)
    end
  end

  it 'should update recency on lookup' do
    expect(cache.head.value).to eql('Chicago')
    expect(cache.get(0)).to eql('Boston')
    expect(cache.head.value).to eql('Boston')
  end

  it 'should keep data until pruning' do
    expect(cache.get(0)).to eql('Boston')
    cache.prune
    expect(cache.get(1)).to be_nil
  end
end
