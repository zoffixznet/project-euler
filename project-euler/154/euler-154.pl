#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $LIM = 200_000;

my $BASE = 5;
my @c5_counts = ((0) x ($LIM+1));

{
    my $base = 1;
    my $power = $BASE;

    while ($power <= $LIM)
    {
        for (my $i = $power; $i <= $LIM ; $i+= $power)
        {
            $c5_counts[$i]++;
        }
    }
    continue
    {
        $base++;
        $power *= $BASE;
    }
}

my $result = 0;
my $x_count = 0;
for my $x (0 .. $LIM)
{
    if ($x % 1_000 == 0)
    {
        print "X=$x\n";
    }
    my $y_count = $x_count;
    my $LIM_min_x = $LIM - $x;
    for my $y (0 .. $LIM_min_x)
    {
        my $z = $LIM_min_x - $y;
        if (($y_count += $c5_counts[$z]-$c5_counts[$y]) >= 12)
        {
            $result++;
        }
        # print $y_count, "\n";
    }

    $x_count += $c5_counts[$LIM_min_x-1]-$c5_counts[$x+1];
}
print "Result == $result\n";
