#!/usr/bin/perl

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

my $A = 5;

for ( my $n = 1 ; $n < 1_000 ; $n++ )
{
    print "$n: ";
    print +(
        ( ( ( ( $A - 1 )**$n ) + ( ( $A + 1 )**$n ) ) % ( $A * $A ) ), "\n",
    );
}
