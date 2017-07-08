#!/bin/bash
perl -Mbigint -E 'for (2 .. 2000000 ) { say $_*$_*$_+1; }' | factor | \
    perl -Mbigint -lanE 'BEGIN {$s = 1;}; say $., "\t", ($s += $F[-1]-1); END{say $s}'
