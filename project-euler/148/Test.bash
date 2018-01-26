#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

n=147
diff -u <(head -$n dump.txt | perl -lanE 'print $., ": ", y/Y/Y/') \
    <(perl calc-num-Y-in-row-ORIG-2.pl $(seq 1 "$n"))

let n=7*7*7+1
while true ; do

    echo "n=$n"
    diff -u <(perl print-row.pl "$n" | perl -lanE "print $n, ': ', y/Y/Y/") \
        <(perl calc-num-Y-in-row-ORIG-2.pl "$n")
    let n++
done
