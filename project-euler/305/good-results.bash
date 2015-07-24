#!/bin/bash
export A="$1"
shift
export MAX_ITERS="$1"
shift
perl -lanE 'my $m = $ENV{A}; $p = -1; my $s = $_; while($c < $ENV{MAX_ITERS} && (($p = index($s, $m, $p+1)) >= 0)) { print $p+1; $c++;}' < buf.txt
