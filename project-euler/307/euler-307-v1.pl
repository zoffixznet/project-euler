#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP';

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

    my $all_singles = Math::BigInt->new($n)->copy->bfac / Math::BigInt->new($n-$k)->copy->bfac;

    my $count = 0;

    if (1)
    {
        my $num_pairs = 1;

        my $MAX_PAIRS = ($k >> 1);

        my $prod;
        if ($num_pairs <= $MAX_PAIRS)
        {
            $prod = ((nCr ( $n, $num_pairs) * nCr( $n-$num_pairs, $k-($num_pairs<<1))
            * Math::BigInt->new($k)->copy->bfac) >> $num_pairs);

            $count += $prod;

        }

        # my $l = $k - (($num_pairs-1) << 1);
        my $new_num_pairs = $num_pairs+1;
        my $t = ($n - $k + $new_num_pairs);
        my $x = ($k - ($new_num_pairs << 1)) + 1;
        while ($new_num_pairs <= $MAX_PAIRS)
        {
            print "Reached num_pairs=$num_pairs\n";
            $num_pairs = $new_num_pairs;
            $new_num_pairs++;

            my $new_prod = (($prod * $x * ($x + 1) / ($num_pairs) / $t)>>1);

=begin foo
            my $good_prod = nCr ( $n, $num_pairs) * nCr( $n-$num_pairs, $k-($num_pairs<<1));

            $good_prod *= $k->copy->bfac >> Math::BigInt->new($num_pairs);
            if ($good_prod != $new_prod)
            {
                die "good_prod=$good_prod prod=$new_prod!";
            }
=end foo

=cut

            $prod = $new_prod;
        }
        continue
        {
            $count += $prod;
            $x -= 2;
            $t++;
        }

    }
    else
    {
        for my $num_pairs (1 .. ($k>>1))
        {
            print "Reached num_pairs=$num_pairs\n";
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

            # prod = n*(n-1)...*1 * (n-num_pairs) * (n-num_pairs-1) .. *1 / (num_pairs*(num_pairs-1)...*1) /
            # ((n-num_pairs)*(n-num_pairs-1)...1) / ((k-num_pairs*2) * (k- num_pairs*2-1 * ... 1) / ((n-k+num_pairs)*(n-k+num_pairs-1)...*1)
            #             =
            #
            # n! / [ (num_pairs!)*(k-num_pairs*2)!*(n-k+num_pairs)! ]

            $prod *= $k->copy->bfac / (1 << Math::BigInt->new($num_pairs));

            $count += $prod;
        }
    }

    my $total = (Math::BigInt->new($n) ** $k);
    return ($total, $total-($count+$all_singles), $all_singles, $count);
}

my $sep = ' ; ';
sub mytest
{
    my ($k, $n) = @_;

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

if (0)
{
    mytest(3,7);
    mytest(4,7);
    mytest(4,8);
    mytest(5,8);
    mytest(6,8);
}
else
{
    my @sol = analytic_solve(20_000, 1_000_000);
    print "Solution == ", join(' ; ', @sol), "\n";
}
