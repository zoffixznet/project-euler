#!/usr/bin/perl

use strict;
use warnings;
use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

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
            my $a_b_mag_sq = $aa_sq + $bb*$bb;

            if ($a_b_mag_sq > $MAX_SQ)
            {
                last B_LOOP;
            }

            my $dd_step = $bb/$aa+1;
            my $dd = 0;
            C_LOOP:
            foreach my $cc (1 .. $MAX)
            {
                my $cc_sq = $cc*$cc;
                if ($cc_sq * $a_b_mag_sq > $MAX_SQ)
                {
                    last C_LOOP;
                }

                my $b_c = $bb*$cc;
                # my $dd = ($b_c/$aa);
                $dd += $dd_step;

                while ($dd * $aa > $b_c)
                {
                    # print "DD=$dd AA=$aa BB*CC = $b_c\n";
                    $dd--;
                }
                my $c_d_mag_sq = $cc_sq+$dd*$dd;

                if ($c_d_mag_sq > $a_b_mag_sq)
                {
                    last C_LOOP;
                }

                if ($dd*$aa == $b_c
                        and $aa*$cc+$bb*$dd <= $MAX)
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
        }
    }

    return $ret;
}

print calc_sum(shift(@ARGV)), "\n";
