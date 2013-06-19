#!/bin/bash
n=49
diff -u <(head -$n dump.txt | perl -lanE 'print $., ": ", y/Y/Y/') \
    <(seq 1 "$n" | (while read i ; do echo "$i: $(perl calc-num-Y-in-row.pl "$i")" ; done))

