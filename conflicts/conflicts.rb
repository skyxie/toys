#! /usr/bin/env ruby

def naive_conflicts(periods)
  return [] if periods.size <= 1
  conflicts = []
  (0..(periods.size-1)).each do |i|
    ((i+1)..(periods.size-1)).each do |j|
      if (periods[i][0] >= periods[j][0] && periods[i][0] < periods[j][1] ||
          periods[i][1] > periods[j][0] && periods[i][0] < periods[j][1])
        conflicts << [[periods[i][0], periods[j][0]].max, [periods[i][1], periods[j][1]].min]
      end
    end
  end
  conflicts
end

def better_conflicts(periods)
  return [] if periods.size <= 1
  sorted_periods = periods.sort {|a,b| a[0] <=> b[0]}
  max_end = sorted_periods[0][1]
  conflicts = []
  (1..(periods.size-1)).each do |i|
    if (periods[i][0] < max_end)
      conflict_end = [periods[i][1], max_end].min
      if conflicts.empty? || conflicts.last[1] < periods[i][0] 
        conflicts << [periods[i][0], conflict_end]
      else
        conflicts.last[1] = conflict_end
      end
    end
    max_end = [periods[i][1], max_end].max
  end
  conflicts
end

def linear_better_conflicts(periods)
  return [] if periods.size <= 1
  end_pts = []
  periods.each { |p| end_pts << [p[0], true] << [p[1], false] }
  sorted_end_pts = end_pts.sort { |a,b| a[0] <=> b[0] }
  intersections = []
  count = 0 
  sorted_end_pts.each do |p|
    count += (p[1] ? 1 : -1)
    if count > 1
      if intersections.empty? || !intersections[-1][1].nil?
        intersections << [p[0], nil]
      end
    else
      if !intersections.empty? && intersections[-1][1].nil?
        intersections[-1][1] = p[0]
      end
    end
  end
  intersections
end

{
  "simple" => [[1, 3], [2, 5], [4, 6]],
  "enveloping" => [[1, 5], [2, 4]],
  "equal" => [[1, 3], [1, 3]],
  "cont_overlaps" => [[1, 3], [2, 4], [3, 5]],
  "over_overlaps" => [[1, 4], [2, 5], [3, 4]]
}.each_pair do |k, v|
  puts "TEST: #{k} #{v.inspect}"
  puts "naive_conflicts: #{naive_conflicts(v).inspect}"
  puts "better_conflicts: #{better_conflicts(v).inspect}"
  puts "linear_better_conflicts: #{linear_better_conflicts(v).inspect}"
  puts
end



