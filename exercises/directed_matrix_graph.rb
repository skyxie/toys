
require 'set'

class DirectedMatrixGraph
  def initialize
    @matrix = {}
  end

  def add_node key
    @matrix[key] = Set.new
  end

  def link src, dest
    @matrix[src].add(dest) if @matrix.has_key?(src) && @matrix.has_key?(dest)
  end

  # Given a directed graph, find a path between 2 nodes
  def path src, dest
    _path srcPaths: [[src]], dest: dest
  end

  private

  def _path srcPaths: , dest:, visited: Set.new
    return nil if srcPaths.empty?

    srcEdge = srcPaths.map(&:last)

    srcNext = []
    srcPaths.each_index do |i|
      return srcPaths[i] if srcEdge[i] == dest
      (@matrix[srcEdge[i]] - visited).each do |node|
        srcNext.push(srcPaths[i] + [node])
        visited.add node
      end
    end

    _path srcPaths: srcNext, dest: dest, visited: visited
  end
end
