#!/usr/bin/perl

use strict;
use warnings;

use integer;
use IO::Handle;

use List::Util qw(sum);

no warnings 'recursion';

sub find_for_num_product_and_sum
{
    my ($min_i, $num_left, $product_left, $sum_left) = @_;

    if ($product_left < 1) 
    {
        return;
    }
    # print "(num_left=$num_left, min_i=$min_i, prod_so_far=$prod_so_far, sum_left=$sum_left) Sum=$sum\n";

    if ($num_left == 1)
    {
        return ($product_left == $sum_left);
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
            if ($product_left % $i)
            {
                next I_LOOP;
            }
            if (find_for_num_product_and_sum(
                    $i, $num_left-1, $product_left / $i, $sum_left-$i
                ))
            {
                return 1;
            }
        }
        return;
    }
}

sub smallest_product_n
{
    my ($n) = @_;

    my $sum = $n;

    while (1)
    {
        if (find_for_num_product_and_sum(1, $n, $sum, $sum))
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
