#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

STDOUT->autoflush(1);

sub solve_for_d
{
    my ($D) = @_;

    # Both 0 and x0 are divisible.
    if ($D == 10)
    {
        return 0;
    }

    my $rec;
    my $total = 0;

    $rec = sub {
        my ($i, $old, $count) = @_;

        if ($i == $D+1)
        {
            if ($count)
            {
                $total++;
            }
        }
        else
        {
            for my $new_d (
                ((($count == 0) && ($i > 1)) ? 0 : 1)
                    ..
                9
            )
            {
                my $n = $old.$new_d;

                my $new_count = $count +
                (grep { substr($n, -$_) % $D == 0 } 1 .. $i)
                ;

                if ($new_count < 2)
                {
                    $rec->($i+1, $n, $new_count);
                }
            }
        }

        return;
    };

    $rec->(1, '', 0);

    return $total;
}

my @sums;

$sums[0] = 0;

for my $d (1 .. 7)
{
    $sums[$d] = $sums[$d-1] + solve_for_d($d);
}

print map { "F(" . 10 ** $_ . ") = " . $sums[$_] . "\n" } keys(@sums);

for my $d (8 .. 19)
{
    print "Calcing d=$d\n";
    $sums[$d] = $sums[$d-1] + solve_for_d($d);
}

print map { "F(" . 10 ** $_ . ") = " . $sums[$_] . "\n" } keys(@sums);
