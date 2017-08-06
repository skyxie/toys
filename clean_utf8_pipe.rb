#! /usr/bin/env ruby

#
# This script accepts lines of inputs from STDIN
# and outputs lines to STDOUT
# filtering out lines with invalid UTF-8 characters to STDERR
#
# Example:
# ./clean_utf8_pipe.rb < inputfile.txt > outputfile.txt
#

lineNum = 1
loop do
  line = STDIN.gets
  break if line.nil? # EOF
  begin
    line.unpack('U*')
    STDOUT.write(line)
  rescue Exception => e
    STDERR.puts "Error [#{e.class.name}] #{e.message} (#{lineNum}) #{line}"
  ensure
    lineNum += 1
  end
end
