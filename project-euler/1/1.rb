#!/usr/bin/ruby

sum = 0
((1...1000).select {|i| (((i % 3) == 0) || ((i % 5) == 0)) }) \
    .each {|i| sum += i}
puts sum
