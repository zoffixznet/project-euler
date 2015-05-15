#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use IO::All;

sub is_special_sum_set
{
    my $A = shift;

    my $recurse;

    $recurse = sub {
        my ($i, $B_sum, $B_count, $C_sum, $C_count) = @_;

        if ($i == @$A)
        {
            if (
                (!$B_count) || (!$C_count)
                    ||
            (
                ($B_sum != $C_sum)
                    &&
                (($B_count > $C_count) ? ($B_sum > $C_sum) : 1)
                    &&
                (($C_count > $B_count) ? ($C_sum > $B_sum) : 1)
            )
            )
            {
                # Everything is OK.
                return;
            }
            else
            {
                die "Not a special subset sum.";
            }
        };

        $recurse->(
            $i+1, $B_sum+$A->[$i], $B_count+1, $C_sum, $C_count
        );
        $recurse->(
            $i+1, $B_sum, $B_count, $C_sum+$A->[$i], $C_count+1
        );
        $recurse->(
            $i+1, $B_sum, $B_count, $C_sum, $C_count
        );

        return;
    };

    eval {
        $recurse->(0, 0, 0, 0, 0);
    };

    return !$@;
}

my $total_sum = 0;
foreach my $l (io("sets.txt")->chomp->getlines())
{
    print "Processing $l\n";
    my @set = split(/,/, $l);
    if (is_special_sum_set(\@set))
    {
        $total_sum += sum(@set);
    }
}
print "Total Sum = $total_sum\n";
