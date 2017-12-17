require 'directed_weighted_graph'

describe DirectedWeightedGraph do
  let(:dijkstra) do
    graph = DirectedWeightedGraph.new()
    %w{a b c d e f g h i}.each do |n|
      graph.add_node n
    end
    graph.add_edge 'a', 'b', 5
    graph.add_edge 'a', 'c', 3
    graph.add_edge 'a', 'e', 2
    graph.add_edge 'b', 'd', 2
    graph.add_edge 'c', 'b', 1
    graph.add_edge 'c', 'd', 1
    graph.add_edge 'd', 'a', 1
    graph.add_edge 'd', 'g', 2
    graph.add_edge 'd', 'h', 1
    graph.add_edge 'e', 'a', 1
    graph.add_edge 'e', 'i', 7
    graph.add_edge 'f', 'b', 3
    graph.add_edge 'f', 'g', 1
    graph.add_edge 'g', 'c', 3
    graph.add_edge 'g', 'i', 2
    graph.add_edge 'h', 'c', 2
    graph.add_edge 'h', 'g', 2
    graph.add_edge 'h', 'f', 2
    graph.dijkstra 'a'
  end

  let(:path_weight) { dijkstra[0] }
  let(:previous) { dijkstra[1] }

  it 'should correctly calculate path weights' do
    expect(path_weight).to eql({
      'a' => 0,
      'b' => 4,
      'c' => 3,
      'd' => 4,
      'e' => 2,
      'f' => 7,
      'g' => 6,
      'h' => 5,
      'i' => 8
    })
  end

  it 'should correctly calculate shortest path back to a' do
    expect(previous).to eql({
      'b' => 'c',
      'c' => 'a',
      'd' => 'c',
      'e' => 'a',
      'f' => 'h',
      'g' => 'd',
      'h' => 'd',
      'i' => 'g'
    })
  end
end
