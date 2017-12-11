
require 'set'

class DirectedAdjacentGraph
  class Node
    def initialize value
      @nodes = Set.new
      @value = value
    end

    attr_reader :value, :nodes

    def empty?
      @nodes.empty?
    end

    def add node
      @nodes.add node
    end

    def delete node
      @nodes.delete node
    end

    def linked? node
      @nodes.include? node
    end
  end

  def initialize
    @nodes = {}
  end

  def size
    @nodes.size
  end

  def add_node value
    @nodes[value] = Node.new(value)
  end

  def link src, dest
    @nodes[src].add @nodes[dest]
  end

  def remove_link src, dest
    @nodes[src].delete @nodes[dest]
  end

  # Given a directed graph, find a path between 2 nodes
  def path src, dest
    path = _path srcPaths: [[@nodes[src]]], dest: @nodes[dest]
    if !path.nil?
      path.map(&:value)
    end
  end

  # List all nodes in order of layers from outside-to-inside
  def path_layers limit=100
    layers = []

    remaining = @nodes.dup

    loop do
      raise 'Exceeded threshold of 100, graph contains loop!' if limit == 0
      break if remaining.empty?
      layer = []
      DirectedAdjacentGraph.reverse(remaining).each_pair do |dest_val, dest_node|
        if dest_node.empty?
          layer.push dest_val
          remaining.delete dest_val
        end
      end
      layers.push layer
      limit -= 1
    end

    layers
  end

  def self.reverse nodes
    empty_init = Hash[nodes.keys.map { |k| [k, Node.new(k)]}]

    nodes.reduce(empty_init) do |rev_nodes, (src_val, src_node)|
      src_node.nodes.each do |dest_node|
        rev_dest_node = rev_nodes[dest_node.value]
        rev_src_node = Node.new(src_val)
        rev_dest_node.add rev_src_node
        rev_nodes[dest_node.value] = rev_dest_node
      end

      rev_nodes
    end
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
end