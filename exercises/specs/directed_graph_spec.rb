#!/usr/bin/env ruby

require 'directed_adjacent_graph'
require 'directed_matrix_graph'

shared_examples :directed_graph do
  before do
    locations = %w{
      Portland Boston NewHaven NYC Philadelphia Pittsburgh
      Cleveland Chicago DC Charleston Nashville Atlanta
    }

    locations.each { |value| graph.add_node(value) }

    graph.link 'Portland', 'Boston'
    graph.link 'Boston', 'NYC'
    graph.link 'NewHaven', 'NYC'
    graph.link 'NYC', 'Philadelphia'
    graph.link 'Philadelphia', 'DC'
    graph.link 'Philadelphia', 'Pittsburgh'
    graph.link 'Pittsburgh', 'Cleveland'
    graph.link 'Cleveland', 'Chicago'
    graph.link 'Chicago', 'Pittsburgh'
    graph.link 'DC', 'Charleston'
    graph.link 'DC', 'Nashville'
    graph.link 'Charleston', 'Nashville'
    graph.link 'Charleston', 'Atlanta'
    graph.link 'Atlanta', 'Nashville'
    graph.link 'Nashville', 'Charleston'
  end

  it 'should map a point to itself' do
    expect(graph.path('Boston', 'Boston')).to eql(['Boston'])
  end

  it 'should map a point to a neighboring point' do
    expect(graph.path('Boston', 'NYC')).to eql(['Boston', 'NYC'])
  end

  it 'should map a point to a distant point' do
    expect(graph.path('Portland', 'Atlanta')).to eql([
      'Portland', 'Boston', 'NYC',
      'Philadelphia', 'DC', 'Charleston', 'Atlanta'
    ])
    expect(graph.path('Portland', 'Chicago')).to eql([
      'Portland', 'Boston', 'NYC',
      'Philadelphia', 'Pittsburgh', 'Cleveland', 'Chicago'
    ])
  end

  it 'should not allow an impossible path' do
    expect(graph.path('Portland', 'NewHaven')).to be_nil
  end

  it 'should not be bothered by cycles' do
    expect(graph.path('Charleston', 'Atlanta')).to eql([
      'Charleston', 'Atlanta'
    ])
    expect(graph.path('Atlanta', 'Charleston')).to eql([
      'Atlanta', 'Nashville', 'Charleston'
    ])
    expect(graph.path('Cleveland', 'Chicago')).to eql([
      'Cleveland', 'Chicago'
    ])
    expect(graph.path('Chicago', 'Cleveland')).to eql([
      'Chicago', 'Pittsburgh', 'Cleveland'
    ])
  end

  it 'should allow one-way path' do
    expect(graph.path('Boston', 'Portland')).to be_nil
    expect(graph.path('Portland', 'Boston')).to eql(['Portland', 'Boston'])
  end
end

describe DirectedAdjacentGraph do
  let(:graph) { DirectedAdjacentGraph.new }
  it_behaves_like :directed_graph
end

describe DirectedMatrixGraph do
  let(:graph) { DirectedMatrixGraph.new }
  it_behaves_like :directed_graph
end

