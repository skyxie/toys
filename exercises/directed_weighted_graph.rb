require 'set'
require 'weighted_queue'

class DirectedWeightedGraph
  MAX_INT = 2**64 - 1

  def initialize
    @mat = {}
  end
  attr_reader :nodes, :edges

  def add_node node
    @mat[node] = {}
  end

  def add_edge a, b, w
    @mat[a][b] = w
  end

  def edge_weight a, b
    @mat.has_key?(a) && @mat[a].has_key?(b) ? @mat[a][b] : Float::INFINITY
  end

  def dijkstra a
    nodes = @mat.keys
    previous = {}
    path_weight = nodes.reduce({}) { |acc, (n, w)| acc.merge(n => (n == a ? 0 : Float::INFINITY)) }
    remaining = WeightedQueue.new(nodes.size) { |n| path_weight[n] }
    nodes.each { |n| remaining.add(n) }
    src_mat = _src_mat

    loop do
      break if remaining.items.empty?
      n = remaining.shift
      @mat[n].each do |x, w|
        (src_mat[x].to_a + [x]).each do |y|
          alt_path_weight = path_weight[y] + edge_weight(y, x)
          if path_weight[x] > alt_path_weight
            path_weight[x] = alt_path_weight
            previous[x] = y
          end
        end
        remaining.reweigh x
      end
    end

    [path_weight, previous]
  end

  private

  def _src_mat
    src_mat = {}

    @mat.keys.each do |dest|
      src_mat[dest] = Set.new
    end

    @mat.each do |src, dests|
      dests.each do |dest, w|
        src_mat[dest].add src
      end
    end

    src_mat
  end

end
