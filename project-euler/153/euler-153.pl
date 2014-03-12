#!/usr/bin/perl

use strict;
use warnings;
use integer;
use bytes;

use List::Util qw(min sum);
use List::MoreUtils qw();

sub gcd
{
    my ($n, $m) = @_;

    while ($m > 0)
    {
        ($n, $m) = ($m, $n%$m);
    }

    return $n;
}

sub calc_sum
{
    my ($MAX) = @_;

    my $ret = 0;

    my $MAX_SQ = $MAX*$MAX;
    foreach my $aa (1 .. $MAX)
    {
        print "a=$aa\n";
        my $aa_sq = $aa*$aa;

        B_LOOP:
        foreach my $bb (0 .. $MAX)
        {
            # print "a=$aa b=$bb\n";
            my $a_b_mag_sq = $aa_sq + $bb*$bb;

            if ($a_b_mag_sq > $MAX_SQ)
            {
                last B_LOOP;
            }

            # Question: when is ($cc*$bb/$aa) an integer?
            #
            # Answer: when $cc*$bb mod $aa == 0
            # That happens when $cc is a product of $aa/gcd($aa,$bb)

            my $cc_step = $aa / gcd($bb, $aa);
            my $dd_step = $cc_step*$bb/$aa;

            my $cc = $cc_step;
            my $dd = $dd_step;

            my $p = (1 + ($bb/$aa)**2);

            my $max_cc = min(
                sqrt($MAX_SQ/$a_b_mag_sq),
                $aa,
                $MAX/($aa*$p),
            );

            my $cc_ret = 0;

            while ($cc < $max_cc)
            {
                # my $delta = ($aa + $cc);
                # print "Found $aa+i$bb ; $cc+i$dd ; Adding: $delta\n";
                $cc_ret += $aa + $cc;
            }
            continue
            {
                $cc += $cc_step;
                $dd += $dd_step;
            }

            if ($cc == $max_cc)
            {
                $cc_ret += $aa + (($cc == $aa) ? 0 : $cc);
            }

            if ($bb)
            {
                $cc_ret <<= 1;
            }

            $ret += $cc_ret;
        }
    }

    return $ret;
}

print calc_sum(shift(@ARGV)), "\n";
