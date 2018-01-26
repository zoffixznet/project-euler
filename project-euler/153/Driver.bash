#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

my_f()
{
    echo "Testing B=$1 A=$2"
    perl gcd-test.pl "$1" "$2" | grep -nvE '^(T T)|(F F)$'
}

for x in $(seq 1 99999) ; do
    for y in $(seq 1 "$x") ; do
        my_f "$x" "$y"
        my_f "$y" "$x"
    done
done
