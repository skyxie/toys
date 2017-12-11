#!/usr/bin/env ruby

require 'directed_adjacent_graph'
require 'directed_matrix_graph'

shared_examples :directed_graph do
  before(:each) do
    locations = %w{
      portland boston newhaven nyc philadelphia pittsburgh
      cleveland chicago dc charleston nashville atlanta
    }

    locations.each { |value| graph.add_node(value) }

    graph.link 'portland', 'boston'
    graph.link 'boston', 'nyc'
    graph.link 'newhaven', 'nyc'
    graph.link 'nyc', 'philadelphia'
    graph.link 'philadelphia', 'dc'
    graph.link 'philadelphia', 'pittsburgh'
    graph.link 'pittsburgh', 'cleveland'
    graph.link 'cleveland', 'chicago'
    graph.link 'chicago', 'pittsburgh'
    graph.link 'dc', 'charleston'
    graph.link 'dc', 'nashville'
    graph.link 'charleston', 'nashville'
    graph.link 'charleston', 'atlanta'
    graph.link 'atlanta', 'nashville'
    graph.link 'nashville', 'charleston'
  end

  describe :path do
    it 'should map a point to itself' do
      expect(graph.path('boston', 'boston')).to eql(['boston'])
    end

    it 'should map a point to a neighboring point' do
      expect(graph.path('boston', 'nyc')).to eql(['boston', 'nyc'])
    end

    it 'should map a point to a distant point' do
      expect(graph.path('portland', 'atlanta')).to eql([
        'portland', 'boston', 'nyc',
        'philadelphia', 'dc', 'charleston', 'atlanta'
      ])
      expect(graph.path('portland', 'chicago')).to eql([
        'portland', 'boston', 'nyc',
        'philadelphia', 'pittsburgh', 'cleveland', 'chicago'
      ])
    end

    it 'should not allow an impossible path' do
      expect(graph.path('portland', 'newhaven')).to be_nil
    end

    it 'should not be bothered by cycles' do
      expect(graph.path('charleston', 'atlanta')).to eql([
        'charleston', 'atlanta'
      ])
      expect(graph.path('atlanta', 'charleston')).to eql([
        'atlanta', 'nashville', 'charleston'
      ])
      expect(graph.path('cleveland', 'chicago')).to eql([
        'cleveland', 'chicago'
      ])
      expect(graph.path('chicago', 'cleveland')).to eql([
        'chicago', 'pittsburgh', 'cleveland'
      ])
    end

    it 'should allow one-way path' do
      expect(graph.path('boston', 'portland')).to be_nil
      expect(graph.path('portland', 'boston')).to eql(['portland', 'boston'])
    end
  end

  describe :path_layers do
    before(:each) do # Remove loops
      graph.remove_link 'nashville', 'charleston'
      graph.remove_link 'atlanta', 'nashville'
      graph.remove_link 'chicago', 'pittsburgh'
    end

    it 'should generate path_layers from outside in' do
      original_size = graph.size
      actual = graph.path_layers
      expected = [
        ['portland', 'newhaven'],
        ['boston'],
        ['nyc'],
        ['philadelphia'],
        ['dc', 'pittsburgh'],
        ['cleveland', 'charleston'],
        ['chicago', 'nashville', 'atlanta']
      ]
      expect(graph.size).to eql(original_size)
      expect(actual.size).to eql(expected.size)
      actual.zip(expected).each do |actual_layer, expected_layer|
        expect(actual_layer).to contain_exactly(*expected_layer)
      end
    end
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

