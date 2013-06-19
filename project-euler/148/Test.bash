#!/bin/bash
n=98
diff -u <(head -$n dump.txt | perl -lanE 'print $., ": ", y/Y/Y/') \
    <(perl calc-num-Y-in-row.pl $(seq 1 "$n"))

let n=7*7*7+1
while true ; do

    echo "n=$n"
    diff -u <(perl print-row.pl "$n" | perl -lanE "print $n, ': ', y/Y/Y/") \
        <(perl calc-num-Y-in-row.pl "$n")
    let n++
done
