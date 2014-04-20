#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

my $this_fib = 1;
my $prev_fib = 1;

my $k = 2;
my $count = 1;
while (1)
{
    ($prev_fib, $this_fib) = ($this_fib, $prev_fib+$this_fib);
    $k++;

    if ($k % 2 == 1)
    {
        print "${count}-th Golden Nugget: ", ($prev_fib*$this_fib), "\n";
        $count++;
    }
}

