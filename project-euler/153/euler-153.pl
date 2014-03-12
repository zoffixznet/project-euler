#!/usr/bin/perl

use strict;
use warnings;

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

            my $max_cc = int (sqrt( $MAX_SQ / $a_b_mag_sq ) );

            foreach my $cc (1 .. $max_cc)
            {
                my $dd = -(($bb*$cc)/$aa);

                my $c_d_mag_sq = $cc*$cc+$dd*$dd;

                if ($dd == int($dd) and $a_b_mag_sq >= $c_d_mag_sq
                        and $aa*$cc-$bb*$dd <= $MAX)
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
