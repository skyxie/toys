#!/usr/bin/env ruby

def palindrome?(str)
  n = str.size / 2
  (0..n).all? do |i|
    str[i] == str[str.size-1-i]
  end
end

def smallest_palindrome(str)
  i = 0
  loop do
    x = str.slice(i, str.size - i)
    if palindrome?(x) || i == str.size - 1
      pre = str.slice(0, i)
      return pre + x + pre.reverse
    end
    i += 1
  end
end

%w{
  abcdef
  aabab
  mom
  fumum
  fmum
}.each do |str|
  puts "smallest_palindrome(#{str}) = #{smallest_palindrome(str)} "
end
