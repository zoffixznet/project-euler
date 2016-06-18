#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use DivideFsm;

STDOUT->autoflush(1);

sub solve_for_d
{
    my ($D) = @_;

    # Both 0 and x0 are divisible.
    if ($D == 10)
    {
        return 0;
    }

    my ($g) = DivideFsm::get_div_fsms($D);
    my @A = @$g;

    my $rec;
    my $total = 0;

    my @S = ((0) x $D);
    # D *M*inus 1.
    my $M = $D-1;

    $rec = sub {
        my ($i, $count) = @_;

        if ($i == $D)
        {
            if ($count)
            {
                if (0)
                {
                    # $_n = scalar reverse$_n;
                    my $_n = scalar reverse @S[0 .. $D];
                    if ((map { my $s = $_; grep { my $e = $_; substr($_n, $s, $e-$s+1) % $D == 0 } $s .. length($_n)-1 } 0 .. length($_n)-1) != 1)
                    {
                        print "False $_n\n";
                    }
                }
                $total++;
            }
        }
        else
        {
            NEW:
            for my $new_d (
                ((($count == 0) && ($i < $M)) ? 0 : 1)
                    ..
                9
            )
            {
                $S[$i] = $new_d;

                # $nc == new_count
                my $nc = $count;
                # State.
                my $s = 0;
                for my $d (@S[reverse (0 .. $i)])
                {
                    if (($s = $A[$s][$d]) == 0)
                    {
                        if (++$nc >= 2)
                        {
                            next NEW;
                        }
                    }
                }
                $rec->($i+1, $nc);
            }
        }

        return;
    };

    $rec->(0, 0);

    return $total;
}

my @sums;

$sums[0] = 0;

for my $d (1 .. 7)
{
    $sums[$d] = $sums[$d-1] + solve_for_d($d);
    print "F(" . 10 ** $d . ") = " . $sums[$d] . "\n";
}

for my $d (8 .. 19)
{
    print "Calcing d=$d\n";
    $sums[$d] = $sums[$d-1] + solve_for_d($d);
}

print map { "F(" . 10 ** $_ . ") = " . $sums[$_] . "\n" } keys(@sums);
