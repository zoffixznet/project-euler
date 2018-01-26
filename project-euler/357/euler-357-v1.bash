#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

MAX="$(perl -E 'print 100_000_000')"
if ! test -e factors.txt ; then
    primes 2 "$MAX" | tee primes.txt | perl -lane 'print $_ - 1' | xargs factor > factors.txt
fi
if ! test -e divs.txt ; then
    cat factors.txt | tail --lines=+3 | perl -ln euler-357-v1-enum-divisors.pl > divs.txt
fi
if ! test -e exprs.txt ; then
    cat divs.txt | perl -Minteger -lanE 'my $n = shift(@F); print join " ", $n, map { $_ + $n/$_ } @F' > exprs.txt
fi
if ! test -e exprs-filt.txt ; then
    cat exprs.txt | grep -vE '^[0-9]+ .*[024568]( |$)' > exprs-filt.txt
fi
perl euler-357-v1-primes-filter.pl
