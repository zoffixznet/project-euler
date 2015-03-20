#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw(all);

STDOUT->autoflush(1);

sub brute_force_solve
{
    my ($k, $n) = @_;

    my $recurse;

    my $count = 0;
    my $all_singles = 0;
    my $with_pairs = 0;

    $recurse = sub {
        my ($depth, $vec, $verdict) = @_;

        if ($depth == $k)
        {
            if ($verdict)
            {
                $count++;
            }
            else
            {
                if (all { $_ <= 1 } @$vec)
                {
                    $all_singles++;
                }
                else
                {
                    $with_pairs++;
                }
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

    return (($n ** $k), $count, $all_singles, $with_pairs);
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
            # $prod *= $x * $x;
            $prod *= $x * ($k - (($pair_idx-1) << 1));
        }

        my $remaining_k = ($k - ($num_pairs << 1));
        my $remaining_n = ($n - $num_pairs);
        $prod *= $remaining_n->copy->bfac / ($remaining_n - $remaining_k)->copy->bfac;
        $count += $prod;
    }

    my $total = ($n ** $k);
    return ($total, $total-($count+$all_singles), $all_singles, $count);
}

sub mytest
{
    my ($k, $n) = @_;

    print "<<<<\n";
    print "K=$k N=$n\n";
    print join(",", brute_force_solve($k, $n));
    print "\n";
    print join(",", analytic_solve($k, $n));
    print "\n";
    print ">>>>\n";
    print "\n\n";
}

mytest(3,7);
mytest(4,7);
