#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

Concealed Square

Problem 206

Find the unique positive integer whose square has the form 1_2_3_4_5_6_7_8_9_0,
where each “_” is a single digit.

=cut

my $pat = '1_2_3_4_5_6_7_8_9_0';

# If ($s * $s) % 10 == 0 then $s % 10 == 0 so $s *$s % 100 == 0
my $pat2 = '1_2_3_4_5_6_7_8_900';

# If ($s * $s) % 10 == 0 then $s % 10 == 0 so $s *$s % 100 == 0
my $pat3 = '1_2_3_4_5_6_7_8[048]900';

foreach my $d1 (0,4,8)
{
    my $d_suffix = "8${d1}900";

    my $recurse;

    $recurse = sub {
        my ($prefix, $l) = @_;

        if ($l == 8)
        {
            my $n = $prefix . $d_suffix;
            my $sq = int(sqrt($n));
            if ($sq * $sq == $n)
            {
                print "Result == $sq ; Square == $n\n";
                # exit(0);
            }
        }
        else
        {
            foreach my $d (0 .. 9)
            {
                $recurse->($prefix.$l.$d, $l+1);
            }
        }
        return;
    };

    $recurse->('',1);
}

# die "Could not find.";
