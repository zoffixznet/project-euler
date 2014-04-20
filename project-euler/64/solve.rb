require "code.rb"

puts (2 .. 10_000).find_all { |n| Math.sqrt(n).to_i ** 2 != n }. \
    find_all { |n| n.continued_fraction()[1].length % 2 == 1 }. \
    length
