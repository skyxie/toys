
require 'pry'

class Node
  attr_accessor :before, :after, :value

  def initialize(value, before=nil, after=nil)
    @value = value
    @before = before
    @after = after
  end

  def traverseLeft(&block)
    block.call(self)
    if before
      before.traverseLeft(&block)
    end
  end

  def traverseRight(&block)
    block.call(self)
    if after
      after.traverseRight(&block)
    end
  end

  def farLeft
    before.nil? ? self : before.farLeft
  end

  def farRight
    after.nil? ? self : after.farRight
  end

  def to_s
    "[%0.2d]" % value
  end
end

class TreeNode < Node
  def append(node)
    if value < node.value
      if before.nil?
        @before = node
      else
        before.append(node)
      end
    else
      if after.nil?
        @after = node
      else
        after.append(node)
      end
    end
  end

  def traverseLeft(&block)
    if !before.nil?
      before.traverseLeft(&block)
    end

    block.call(self)

    if !after.nil?
      after.traverseLeft(&block)
    end
  end

  def traverseRight(&block)
    if !after.nil?
      after.traverseRight(&block)
    end

    block.call(self)

    if !before.nil?
      before.traverseRight(&block)
    end
  end

  def toList
    new_node = Node.new(value)

    if before
      _before = before.toList.farRight
      _before.after = new_node
      new_node.before = _before
    end

    if after
      _after = after.toList.farLeft
      _after.before = new_node
      new_node.after = _after
    end

    new_node
  end

  def rows(lines = [''], index = 0, filler = ' ')
    if lines.size <= index + 1
      lines << ' ' * lines[index].size
    end

    if before.nil?
      lines[index+1] << '  '
    else
      before.rows(lines, index + 1)
      lines[index+1] << '_/'
    end

    if lines[index].size + 2 < lines[index+1].size
      lines[index] << filler * (lines[index+1].size - lines[index].size - 2)
    end

    lines[index] << to_s
    lines[index+2, lines.size].each do |line|
      if line.size < lines[index].size
        line << ' ' * (lines[index].size - line.size)
      end
    end

    if after.nil?
      lines[index+1] << '  '
    else
      lines[index+1] << '\_'
      after.rows(lines, index + 1, '_')
    end

    lines
  end
end

class Entry < Node
  attr_accessor :key

  def initialize(key, value, before, after)
    @key = key
    super(value, before, after)
  end

  def to_s
    "(#{key}=>#{value})"
  end

  def detach
    if @before
      @before.after = @after
    end

    if @after
      @after.before = @before
    end
  end
end

