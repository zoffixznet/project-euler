#!/bin/bash
perl gen-pascal-tri.pl "$1" | sort | uniq | xargs factor \
    | perl -lne 'print unless /( [0-9]+)\1(?: |\n|\z)/' \
    | perl -lanF/:/ -e 'print $s += $F[0];'
