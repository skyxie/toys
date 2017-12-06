
require 'set'

class DirectedAdjacentGraph
  class Node
    def initialize value
      @nodes = Set.new
      @value = value
    end

    attr_reader :value, :nodes

    def add node
      @nodes.add node
    end

    def linked? node
      @nodes.include? node
    end
  end

  def initialize
    @nodes = {}
  end

  def add_node value
    @nodes[value] = Node.new(value)
  end

  def to_s
    formatter = -> (val) { " %#{_max_str_width}s " % val }

    key_order = @nodes.keys
    vals = ([''] + key_order.map{ |key| @nodes[key].value })
    str = vals.map(&formatter).join('|') + "\n"

    key_order.each do |row_key|
      vals = [@nodes[row_key].value] + key_order.map do |col_key|
        @nodes[row_key].linked?(@nodes[col_key]) ? "1" : "0"
      end
      str += vals.map(&formatter).join('|') + "\n"
    end

    str
  end

  def link src, dest
    @nodes[src].add @nodes[dest]
  end

  def path src, dest
    _path srcPaths: [[@nodes[src]]], dest: @nodes[dest]
  end

  def format_path src, dest
    result = path src, dest
    "Path(#{src} -> #{dest}): #{result.nil? ? 'None' : result.map(&:value).join(' -> ')}"
  end

  private

  def _path srcPaths: , dest:, visited: Set.new
    return nil if srcPaths.empty?

    srcEdge = srcPaths.map(&:last)

    srcNext = []
    srcPaths.each_index do |i|
      return srcPaths[i] if srcEdge[i] == dest
      (srcEdge[i].nodes - visited).each do |node|
        srcNext.push(srcPaths[i] + [node])
        visited.add node
      end
    end

    _path srcPaths: srcNext, dest: dest, visited: visited
  end

  def _max_str_width
    @nodes.values.map { |n| n.value.size }.max
  end
end