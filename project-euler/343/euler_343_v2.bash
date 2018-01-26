#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

perl -Mbigint -E 'for (2 .. 2000000 ) { say $_*$_*$_+1; }' | factor | \
    perl -Mbigint -lanE 'BEGIN {$s = 1;}; $s += $F[-1]-1;say $., "\t", $s if $. % 1_000 == 0 ; END{say $s}'
