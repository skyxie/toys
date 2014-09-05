#! /usr/bin/env python

def naive_conflicts(periods):
  if len(periods) == 0:
    return []
  conflicts = []
  for i in range(len(periods) - 1):
    for j in range(i+1, len(periods)):
      if ((periods[i][0] >= periods[j][0] and periods[i][0] < periods[j][1]) or
          periods[i][1] > periods[j][0] and periods[i][1] < periods[j][1]):
        conflicts.append([max(periods[i][0], periods[j][0]), min(periods[i][1], periods[j][1])])
  return conflicts

def start_cmp(x, y):
  return x[0] - y[0]

def better_conflicts(periods):
  if len(periods) == 0:
    return []
  sorted_periods = sorted(periods, cmp=start_cmp)
  max_end = sorted_periods[0][1]
  conflicts = []
  for i in range(1, len(sorted_periods)):
    if sorted_periods[i][0] < max_end:
      conflict_end = min(periods[i][1], max_end)
      if len(conflicts) == 0 or conflicts[-1][1] < sorted_periods[i][0]:
        conflicts.append([periods[i][0], conflict_end])
      else:
        conflicts[-1][1] = conflict_end
    max_end = max(max_end, sorted_periods[i][1])
  return conflicts

def linear_better_conflicts(periods):
  if len(periods) == 0:
    return []
  end_pts = []
  for i in range(len(periods)):
    end_pts.append([periods[i][0], 1])
    end_pts.append([periods[i][1], -1])
  sorted_end_pts = sorted(end_pts, cmp=start_cmp)
  conflicts = []
  count = 0
  for i in range(len(sorted_end_pts)):
    count += sorted_end_pts[i][1]
    if count > 1:
      if len(conflicts) == 0 or len(conflicts[-1]) != 1:
        conflicts.append([sorted_end_pts[i][0]])
    else:
      if len(conflicts) != 0 and len(conflicts[-1]) == 1:
        conflicts[-1].append(sorted_end_pts[i][0])
  return conflicts


tests = {
  "simple" : [[1, 3], [2, 5], [4, 6]],
  "enveloping" : [[1, 5], [2, 4]],
  "equal" : [[1, 3], [1, 3]],
  "cont_overlaps" : [[1, 3], [2, 4], [3, 5]],
  "over_overlaps" : [[1, 4], [2, 5], [3, 4]]
}

for key in tests:
  print("TEST: " + key + " " + str(tests[key]))
  print("naive_conflicts: " + str(naive_conflicts(tests[key])))
  print("better_conflicts: " + str(better_conflicts(tests[key])))
  print("linear_better_conflicts: " + str(linear_better_conflicts(tests[key])))
  print





