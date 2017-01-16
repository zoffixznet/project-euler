#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

{
    # TEST
    is(
qx/python euler_333_v1_step1.py 100 | sort | uniq -c | sort -n | perl -lanE 'say if s#^ *1\\s+## and `primes 2 100` =~ m#^\$_\$#ms' | perl -lanE '\$s += \$_ ; END {print\$s}'/,
        "233\n",
        "100 test case",
    );
}
