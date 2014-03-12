#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use List::MoreUtils qw();

sub calc_sum
{
    my ($MAX) = @_;

    my $ret = 0;

    foreach my $aa (1 .. $MAX)
    {
        my $max_bb = int( sqrt($MAX**2-$aa**2) );
        foreach my $bb (-$max_bb .. $max_bb)
        {
            my $a_b_mag_sq = $aa*$aa+$bb*$bb;

            my $max_cc = int (sqrt( $MAX**2-$a_b_mag_sq ) );
            foreach my $cc (1 .. $max_cc)
            {
                my $dd = -(($bb*$cc)/$aa);

                my $c_d_mag_sq = $cc*$cc+$dd*$dd;

                if ($dd == int($dd) and $a_b_mag_sq >= $c_d_mag_sq
                        and $aa*$cc-$bb*$dd <= $MAX)
                {
                    my $delta = (($bb == 0 ? 1 : 2) * ($aa+$cc));
                    print "Found $aa+i$bb ; $cc+i$dd ; Adding: $delta\n";
                    $ret += $delta;
                }
            }
        }
    }

    return $ret;
}

print calc_sum(shift(@ARGV)), "\n";
