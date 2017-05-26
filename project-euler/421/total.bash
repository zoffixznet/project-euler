#!/bin/bash
/home/shlomif/Download/unpack/prog/python/pypy2-v5.7.1-src/pypy/goal/pypy-c gen.py # | factor # | perl -lan -MList::Util=sum -E 'shift@F;my%n;for(@F){if(length>1e8){last}else{$n{$_}=1}};$s+=sum(keys%n); say "$.\t$s" if 1; $. =~ /00\z/; END { say "$.\t$s" }' | tee log1.txt
