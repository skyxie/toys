
require 'pry'

class Node
  attr_accessor :before, :after, :value

  def initialize(value, before=nil, after=nil)
    @value = value
    @before = before
    @after = after
  end

  def traverseLeft(memo=nil, &block)
    memo = block.call(self, memo)
    if before
      before.traverseLeft(memo, &block)
    end
  end

  def traverseRight(memo=nil, &block)
    memo = block.call(self, memo)
    if after
      after.traverseRight(memo, &block)
    end
  end

  def farLeft
    before.nil? ? self : before.farLeft
  end

  def farRight
    after.nil? ? self : after.farRight
  end

  def leaf?
    before.nil? && after.nil?
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

  def traverseLeft(memo=nil, &block)
    if !before.nil?
      before.traverseLeft(memo, &block)
    end

    memo = block.call(self, memo)

    if !after.nil?
      after.traverseLeft(memo, &block)
    end
  end

  def traverseRight(memo=nil, &block)
    if !after.nil?
      after.traverseRight(memo, &block)
    end

    memo = block.call(self, memo)

    if !before.nil?
      before.traverseRight(memo, &block)
    end
  end

  def traverseMidLeft(memo=nil, &block)
    memo = block.call(self, memo)

    if !before.nil?
      before.traverseMidLeft(memo, &block)
    end

    if !after.nil?
      after.traverseMidLeft(memo, &block)
    end
  end

  def columns(cols, root_index = 0, offset = 0)
    if before
      root_index = before.columns(cols, root_index, offset - 1)
    end

    while root_index + offset < 0
      cols.unshift([])
      root_index += 1
    end

    while root_index + offset >= cols.size
      cols.push([])
    end

    cols[root_index + offset].push(value)

    if after
      after.columns(cols, root_index, offset + 1)
    end

    root_index
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

