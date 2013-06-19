#!/bin/bash
n=98
diff -u <(head -$n dump.txt | perl -lanE 'print $., ": ", y/Y/Y/') \
    <(perl calc-num-Y-in-row.pl $(seq 1 "$n"))

