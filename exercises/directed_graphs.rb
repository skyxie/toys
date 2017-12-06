#!/usr/bin/env ruby

require './directed_adjacent_graph'
require './directed_matrix_graph'

[
  DirectedAdjacentGraph.new,
  DirectedMatrixGraph.new
].each do |graph|
  puts "---------------------------------------------"
  puts graph.class.name

  locations = %w{
    Portland Boston NewHaven NYC Philly Pitts
    Cleveland Chicago DC Charleston Nashville Atlanta
  }

  locations.each { |value| graph.add_node(value) }

  graph.link "Portland", "Boston"
  graph.link "Boston", "NewHaven"
  graph.link "Boston", "NYC"
  graph.link "NewHaven", "NYC"
  graph.link "NYC", "Philly"
  graph.link "Philly", "DC"
  graph.link "Philly", "Pitts"
  graph.link "Pitts", "Cleveland"
  graph.link "Cleveland", "Chicago"
  graph.link "Chicago", "Pitts"
  graph.link "DC", "Charleston"
  graph.link "DC", "Nashville"
  graph.link "Charleston", "Nashville"
  graph.link "Charleston", "Atlanta"
  graph.link "Nashville", "Atlanta"
  graph.link "Atlanta", "Charleston"

  puts graph

  puts graph.format_path("Boston", "Boston")
  puts graph.format_path("Boston", "NewHaven")
  puts graph.format_path("Portland", "Atlanta")
  puts graph.format_path("Portland", "Chicago")
  puts graph.format_path("Boston", "Portland")
  puts graph.format_path("Nashville", "Charleston")
  puts graph.format_path("Nashville", "Atlanta")
  puts graph.format_path("Atlanta", "Nashville")
  puts graph.format_path("Chicago", "Cleveland")
  puts graph.format_path("Cleveland", "Chicago")
end


