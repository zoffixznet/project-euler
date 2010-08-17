#!/usr/bin/perl

use strict;
use warnings;

use integer;
use IO::Handle;

use List::Util qw(sum min max);

no warnings 'recursion';

sub find_for_num_product_and_sum
{
    my ($max_i, $num_left, $product_left, $sum_left) = @_;

    # print "(num_left=$num_left, min_i=$min_i, prod_so_far=$prod_so_far, sum_left=$sum_left) Sum=$sum\n";

    if ($num_left == 1)
    {
        return ($product_left == $sum_left);
    }
    # Pad with 1's
    elsif ($product_left == 1)
    {
        return ($sum_left == $num_left);
    }
    else
    {
        # 1*1*1*1*1*$product_left
        if ($product_left+$num_left-1 == $sum_left)
        {
            return 1;
        }

        my $loop_max = min($max_i, ($product_left>>1));
        my $loop_min = max(2, $sum_left / $num_left);

        I_LOOP:
        for my $i (reverse($loop_min .. $loop_max))
        {
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
        if (find_for_num_product_and_sum(($sum >> 1), $n, $sum, $sum))
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
