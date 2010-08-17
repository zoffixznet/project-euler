#!/usr/bin/perl

use strict;
use warnings;

use integer;
use IO::Handle;

use List::Util qw(sum);

no warnings 'recursion';

sub smallest_product_n
{
    my ($n) = @_;

    my $sum = $n;

    while (1)
    {
        my $recurse;

        $recurse = sub {
            my ($num_left, $min_i, $prod_so_far, $sum_left) = @_;

            if ($prod_so_far > $sum)
            {
                return;
            }
            # print "(num_left=$num_left, min_i=$min_i, prod_so_far=$prod_so_far, sum_left=$sum_left) Sum=$sum\n";

            if ($num_left == 1)
            {
                return ($prod_so_far * $sum_left == $sum);
            }
            else
            {
                I_LOOP:
                for my $i ($min_i .. $sum_left)
                {
                    if ($sum_left < $i * ($num_left-1))
                    {
                        last I_LOOP;
                    }
                    if ($recurse->(
                        $num_left-1, $i, $prod_so_far*$i, $sum_left-$i
                    ))
                    {
                        return 1;
                    }
                }
                return;
            }
        };

        if ($recurse->($n, 1, 1, $sum))
        {
            return $sum;
        }
    }
    continue
    {
        $sum++;
    }
}

my %numbers;

STDOUT->autoflush(1);

for my $n (2 .. 12_000)
{
    my $val = smallest_product_n($n);
    print "Reached $n = $val\n";
    $numbers{$val}++;
}

print "Sum = ", sum(keys(%numbers)), "\n";
