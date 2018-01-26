#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

cat e | perl -lanE 'BEGIN { %h = map { $_ => 1 } do { @x=`primes 2 1000000`; chomp@x;@x} } say if exists$h{$_}' | sort | uniq -c | perl -lanE 'print if s#^\s*1\s+##' | perl -lanE '$s += $_ ; END {print$s}'
