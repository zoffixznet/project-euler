#!/bin/sh

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl -lane 'if (/\A\[VERDICT\] == Solved: ([0-9]{10})\z/) { $s += $1; $c++; } END{print "Sum = $s ; c = $c";}'

