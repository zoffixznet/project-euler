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
                $MAX,
                sqrt($MAX_SQ/$a_b_mag_sq),
                $a_b_mag_sq / $p,
                $MAX/($aa*$p),
            );

            C_LOOP:
            while ($cc <= $max_cc)
            {
=begin foo
                $dd += $dd_step;

                while ($dd * $aa > $b_c)
                {
                    # print "DD=$dd AA=$aa BB*CC = $b_c\n";
                    $dd--;
                }

                if (
                    $aa*$cc+$bb*$dd > $MAX
                )
                {
                    last C_LOOP;
                }
=end foo

=cut

                my $delta = ($aa + (($cc == $aa) ? 0 : $cc) );
                if ($bb)
                {
                    $delta <<= 1;
                }
                # print "Found $aa+i$bb ; $cc+i$dd ; Adding: $delta\n";
                $ret += $delta;
            }
            continue
            {
                $cc += $cc_step;
                $dd += $dd_step;
            }
        }
    }

    return $ret;
}

print calc_sum(shift(@ARGV)), "\n";
