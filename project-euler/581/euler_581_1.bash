#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

seq 1 10000000000000000 | factor | \
    perl -lapE '$x = ($F[-1] < 50) ? 1 : 0;s#:.*#\t$x#' | \
    perl -lanE 'use bigint; ($x,$b)=@F; if ($p && $b) {$s += $x-1; $l = $x;} if ($x =~ /00000\z/) { print "Sum[$x] = $s (L = $l )"; } $p = $b;'

