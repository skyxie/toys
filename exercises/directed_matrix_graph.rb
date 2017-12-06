
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

  def to_s
    formatter = -> (val) { " %#{_max_str_width}s " % val }

    key_order = @matrix.keys
    str = ([''] + key_order).map(&formatter).join('|') + "\n"

    key_order.each do |row_key|
      vals = [row_key] + key_order.map do |col_key|
        @matrix[row_key].include?(col_key) ? "1" : "0"
      end
      str += vals.map(&formatter).join('|') + "\n"
    end

    str
  end

  def path src, dest
    _path srcPaths: [[src]], dest: dest
  end

  def format_path src, dest
    result = path src, dest
    "Path(#{src} -> #{dest}): #{result.nil? ? 'None' : result.join(' -> ')}"
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

  def _max_str_width
    @matrix.keys.map(&:size).max
  end
end
