#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(max min reduce);
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

for my $B (3 .. 1_000-1)
{
    print "B = $B\n";
    my $rad_B = radical($B);

    # rad(A) is at the minimum 2 and since a,b,c are stranger numbers,
    # then C > rad(abc) >= rad(ab) >= 2*rad_B
    # A = C-B >= 2 * rad_B - B
    for my $A
    (
        max(2*$rad_B-$B, 2) 
        ..
        min($B-1, (120_000-1)-$B)
    )
    # for my $A (2 .. min($B-1, (120_000-1)-$B))
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
