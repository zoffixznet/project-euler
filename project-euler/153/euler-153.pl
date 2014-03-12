#!/usr/bin/perl

use strict;
use warnings;
use integer;
use bytes;

use List::Util qw(sum);
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

            my $max_cc = $MAX;

            C_LOOP:
            while ($cc < $max_cc)
            {
                my $cc_sq = $cc*$cc;
                if ($cc_sq * $a_b_mag_sq > $MAX_SQ)
                {
                    last C_LOOP;
                }

=begin foo
                $dd += $dd_step;

                while ($dd * $aa > $b_c)
                {
                    # print "DD=$dd AA=$aa BB*CC = $b_c\n";
                    $dd--;
                }
=end foo

=cut

                my $c_d_mag_sq = $cc_sq+$dd*$dd;

                if ($c_d_mag_sq > $a_b_mag_sq
                        or
                    $aa*$cc+$bb*$dd > $MAX
                )
                {
                    last C_LOOP;
                }

                {
                    # my $delta = (($bb == 0 ? 1 : 2) * ($aa+$cc));
                    # my $delta = ($aa+$cc);
                    # my $delta = $aa_cc;

                    my $delta = ($aa + (($cc == $aa) ? 0 : $cc) );
                    if ($bb)
                    {
                        $delta <<= 1;
                    }
                    # print "Found $aa+i$bb ; $cc+i$dd ; Adding: $delta\n";
                    $ret += $delta;
                }
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
