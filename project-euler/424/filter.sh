#!/bin/sh
perl -lane 'if (/\A\[VERDICT\] == Solved: ([0-9]{10})\z/) { $s += $1; $c++; } END{print "Sum = $s ; c = $c";}'

