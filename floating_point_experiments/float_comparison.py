#! /usr/bin/env python

import sys

s = 0.1
print("    {:25s} {:25s} {:25s}".format("sum", "product", "difference"))
for i in range(1, int(sys.argv[1])):
  m = (0.1 * float(i))
  d = abs(m - s)
  print("{:2d}) {:1.23f} {:1.23f} {:1.23f}".format(i,s,m,d))
  s = s + 0.1

