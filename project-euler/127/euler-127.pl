#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min reduce);
use List::MoreUtils qw(uniq);

use integer;

sub gcd
{
    my ($n, $m) = @_;

    if ($n < $m)
    {
        return gcd($m,$n);
    }

    if ($m == 0)
    {
        return $n;
    }

    return gcd($m,$n % $m);
}

sub radical
{
    my $n = shift;
    my $factors = `factor $n`;
    $factors =~ s{\A[^:]+:}{};
    return reduce { $a * $b } 1, uniq($factors =~ m/(\d+)/g);
}

my %C_s = ();

for my $B (3 .. 120_000-1)
{
    my $rad_B = radical($B);
    for my $A (2 .. min($B-1, (120_000-1)-$B, (2 * $B/$rad_B)))
    {
        if (gcd($B, $A) == 1)
        {
            my $C = $A + $B;
            if (gcd($C, $A) == 1 and gcd($C, $B) == 1 and 
                radical($A*$B*$C) < $C)
            {
                print "Found $C\n";
                $C_s{$C} = 1;
            }
        }
    }
}
