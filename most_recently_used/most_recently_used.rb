require 'random-word'

Link = Struct.new(:before, :after, :key, :value) do
  def to_s
    "(#{key}=>#{value})"
  end

  def detach
    if self.before
      self.before.after = self.after
    end

    if self.after
      self.after.before = self.before
    end
  end
end

class Cache
  attr_accessor :limit

  def initialize(limit)
    @limit = limit
    @head = nil
    @hash = {}
  end

  def get(key)
    if @hash.has_key?(key)
      link = @hash[key]

      link.detach
      prepend(link)

      link.value
    end
  end

  def put(key, value)
    if @hash.has_key?(key)
      @hash[key].value = value
    else
      link = Link.new(nil, @head, key, value)
      @hash[key] = link
      prepend(link)
    end
  end

  def prepend(link)
    link.after = @head
    if @head
      @head.before = link
    end
    @head = link
  end

  def prune
    _prune(@head, @limit)
  end

  def to_s
    _stringify(@head)
  end

  private

  def _prune(link, limit)
    if limit < 0
      link.detach
      @hash.delete(link.key)
    end

    if link.after
      _prune(link.after, limit - 1)
    end
  end

  def _stringify(link)
    link.nil? ? "END" : "#{link.to_s}\n->#{_stringify(link.after)}"
  end
end

cache = Cache.new(5)

(1..10).each { |i| cache.put(i, RandomWord.nouns.next) }

puts cache
puts
puts "5 => #{cache.get(5)}"
puts
puts cache
puts
puts "6 => #{cache.get(6)}"
puts
puts cache

cache.prune

puts
puts cache
puts
puts "9 => #{cache.get(9)}"
puts "3 => #{cache.get(3)}"
puts
puts cache

cache.limit = 1
cache.prune

puts
puts cache

