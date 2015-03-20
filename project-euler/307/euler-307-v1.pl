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

sub nCr
{
    my $n = Math::BigInt->new(shift());
    my $r = Math::BigInt->new(shift());

    return ($n->copy->bfac / ($r->copy->bfac * ($n-$r)->copy->bfac));
}

sub analytic_solve
{
    my ($k, $n) = @_;

    my $all_singles = $n->copy->bfac / ($n-$k)->copy->bfac;

    my $count = 0;

    for my $num_pairs (1 .. ($k>>1))
    {
        # OK, here's the deal: we have $num_pairs pairs and
        # $g = $k - $num_pairs*2 singles.
        #
        # We choose $num_pairs places out of $n (
        # $n!/($num_pairs!)/($n-$num_pairs)! ) and an extra
        # nCr($n-$num_pairs, $g) places for the placement of the singles.
        #
        # We choose
        #
        my $prod = nCr ( $n, $num_pairs) * nCr( $n-$num_pairs, $k-($num_pairs<<1));

        $prod *= $k->copy->bfac / (1 << Math::BigInt->new($num_pairs));

=begin foo
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

=end foo

=cut

        $count += $prod;
    }

    my $total = ($n ** $k);
    return ($total, $total-($count+$all_singles), $all_singles, $count);
}

sub mytest
{
    my ($k, $n) = @_;

    my $sep = ' ; ';
    my $brute = join($sep, brute_force_solve($k, $n));
    my $an = join($sep, analytic_solve($k, $n));

    print "<<<<\n";
    print "K=$k N=$n\n";
    print "$brute\n";
    print "$an\n";
    print ">>>>\n";
    print "\n\n";

    if ($brute ne $an)
    {
        die "brute_force_solve and analytic_solve differ!";
    }
}

mytest(3,7);
mytest(4,7);
mytest(4,8);
mytest(5,8);
mytest(6,8);
