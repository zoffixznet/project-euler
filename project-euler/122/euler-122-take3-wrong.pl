#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::Util qw(min);

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

my @ranks = (undef, 0);
my $sum = 0;

foreach my $n (2 .. 200)
{
    my $r;
    if ($n % 2 == 0)
    {
        $r = $ranks[$n / 2]+1;
    }
    else
    {
        $r = min( map { $ranks[$_]+$ranks[$n-$_]-$ranks[gcd($_,$n-$_)]+1 }
        (1 .. $n/2)
        );
    }

    print "${n}: $r\n";
    push @ranks, $r;

    $sum += $r;
}

print "Sum: $sum\n";
