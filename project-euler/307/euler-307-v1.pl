#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub brute_force_solve
{
    my ($k, $n) = @_;

    my $recurse;

    my $count = 0;

    $recurse = sub {
        my ($depth, $vec, $verdict) = @_;

        if ($depth == $k)
        {
            if ($verdict)
            {
                $count++;
            }
        }
        else
        {
            foreach my $choice (0 .. $n-1)
            {
                my @new = @$vec;
                my $new_verdict = ((++$new[$choice] >= 3) || $verdict);
                $recurse->($depth+1, \@new, $new_verdict);
            }
        }
    };

    $recurse->(0, [map { 0 } 1 .. $n], 0);

    return (($n ** $k), $count);
}

sub analytic_solve
{
    my ($k, $n) = @_;

    my $all_singles = $n->copy->bfac / ($n-$k)->copy->bfac;

    my $count = 0;

    for my $num_pairs (1 .. ($k>>1))
    {
        my $prod = 1;

        for my $pair_idx (1 .. $num_pairs)
        {
            my $x = ($n-($pair_idx-1));
            $prod *= $x * $x;
        }

        my $remaining_k = ($k - ($num_pairs << 1));
        my $remaining_n = ($n - $num_pairs);
        $prod *= $remaining_n->copy->bfac / ($remaining_n - $remaining_k)->copy->bfac;
        $count += $prod;
    }

    return (($n ** $k), $count+$all_singles);
}

print join(",", brute_force_solve(3, 7));
print "\n";
print join(",", analytic_solve(3, 7));
print "\n";
