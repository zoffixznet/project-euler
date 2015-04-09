#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my ($MAX) = @ARGV;

my $sum = 0;

sub gcd
{
    my ($n, $m) = @_;

    if ($m > $n)
    {
        ($n, $m) = ($m, $n);
    }

    while ($m > 0)
    {
        ($n, $m) = ($m, $n%$m);
    }

    return $n;
}

my $r2 = 2;
for my $r (1 .. $MAX)
{
    print "R=$r\n";
    # print "R=$r - adding ", int ($MAX / $r) * $r, "\n";
    $sum += int ($MAX / $r) * $r;

    my $x = $r * $r + 1;
    my $i = 1;
    my $inc = 1;
    while ($x <= $MAX)
    {
        if (gcd($i, $r) == 1)
        {
            my $xm = $x;
            my $rm = $r2;

            while ($xm <= $MAX)
            {
                $sum += int ($MAX / $xm) * $rm;
            }
            continue
            {
                $xm += $x;
                $rm += $r2;
            }
        }
    }
    continue
    {
        $i++;
        $x += ($inc += 2);
    }
}
continue
{
    $r2 += 2;
}

print "Sum = $sum\n";
