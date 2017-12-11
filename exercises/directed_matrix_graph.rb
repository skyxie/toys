
require 'pry'
require 'set'

class DirectedMatrixGraph
  def initialize
    @matrix = {}
  end

  def size
    @matrix.size
  end

  def add_node key
    @matrix[key] = Set.new
  end

  def link src, dest
    @matrix[src].add(dest) if @matrix.has_key?(src) && @matrix.has_key?(dest)
  end

  def remove_link src, dest
    @matrix[src].delete dest
  end

  # Given a directed graph, find a path between 2 nodes
  def path src, dest
    _path srcPaths: [[src]], dest: dest
  end

  # List all nodes in order of layers from outside-to-inside
  def path_layers limit=100
    layers = []

    # Duplicate matrix because it will be modified
    mat = @matrix.dup

    loop do
      raise 'Exceeded threshold of 100, graph contains loop!' if limit == 0
      break if mat.empty?
      layer = []
      DirectedMatrixGraph.transpose(mat).each_pair do |dest, src_set|
        if src_set.empty?
          layer.push dest
          mat.delete dest
        end
      end
      layers.push layer
      limit -= 1
    end

    layers
  end

  def self.transpose matrix
    empty_init = Hash[matrix.keys.map { |k| [k, Set.new]}]

    matrix.reduce(empty_init) do |src_matrix, (src, dest_set)|
      dest_set.each do |dest|
        src_matrix[dest].add src
      end
      src_matrix
    end
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
