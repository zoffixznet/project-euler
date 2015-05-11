#!/bin/bash
MAX="$(perl -E 'print 100_000_000')"
if ! test -e factors.txt ; then
    primes 2 "$MAX" | tee primes.txt | perl -lane 'print $_ - 1' | xargs factor > factors.txt
fi
cat factors.txt | tail --lines=+3 | perl -ln euler-357-v1-enum-divisors.pl
