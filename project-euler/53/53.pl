#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt ":constant", lib => "GMP";

for my $n ( 1 .. 100 )
{
    my $C_n_r = 1;
    for my $r ( 1 .. $n - 1 )
    {
        $C_n_r *= $n - $r + 1;
        $C_n_r /= $r;
        if ( $C_n_r > 1_000_000 )
        {
            print $C_n_r, "\n";

            # print "C($n,$r) = " . $C_n_r. "\n";
        }
    }
}
