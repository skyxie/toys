
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

  def link src, dest
    @nodes[src].add @nodes[dest]
  end

  # Given a directed graph, find a path between 2 nodes
  def path src, dest
    path = _path srcPaths: [[@nodes[src]]], dest: @nodes[dest]
    if !path.nil?
      path.map(&:value)
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