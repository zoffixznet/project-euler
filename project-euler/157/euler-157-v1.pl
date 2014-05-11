#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

for my $n (9)
{
    my $t_n = (10 ** $n);
    my $B = 1;
    while (1)
    {
        A_LOOP:
        for my $A (1 .. $B)
        {
            my $num = ($A+$B)*$t_n;
            my $denom = $A * $B;
            if ($num % $denom == 0)
            {
                print "Found 1/$A+1/$B = " . ($num/$denom) . "/$t_n\n";
            }
            elsif (($denom << 1) > $num)
            {
                last A_LOOP;
            }
        }
    }
    continue
    {
        $B++;
    }
}
