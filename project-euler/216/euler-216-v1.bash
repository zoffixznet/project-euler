#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

seq 2 50000000 | perl -lane 'print +(($_*$_)<<1)-1' | xargs factor |
    perl -Mbytes -lane 'unless (/: [0-9]+ [0-9]/) { $c++; } print "$.: $c"' |
    tee euler_216.dump
