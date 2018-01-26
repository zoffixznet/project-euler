#!/usr/bin/ruby

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

require './clean.rb'

BDB::Env.cleanup "tmp", true

db = BDB::Btree.open "tmp/basic", nil, BDB::CREATE | BDB::TRUNCATE, 0644,
     "set_pagesize" => 1024, "set_cachesize" => [0, 32 * 1024, 0]
base = 1234567891011

step = 1000000
n = 1
prev = 0
this = 1
key = "#{prev};#{this}"
next_n = step
while (not db.has_key?(key)) do
    db[key] = "#{n}"
    prev, this = this, ((prev+this) % base)
    key = "#{prev};#{this}"
    n += 1
    if n == next_n then
        next_n += step
        puts "Reached #{n}"
    end
end
puts "Repeat from #{db[key]} to #{n}\n";
db.close
