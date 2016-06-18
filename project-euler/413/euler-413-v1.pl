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
    # A transposed
    my @T = map { my $d = $_; [ map { $A[$_][$d] } keys@A ] } keys@{$A[0]};

    my $rec;
    my $total = 0;

    # my @S = ((0) x $D);
    # D *M*inus 1.
    my $M = $D-1;

    $rec = sub {
        my ($i, $S, $count) = @_;

        if ($i == $D)
        {
            if ($count)
            {
                if (0)
                {
                    # $_n = scalar reverse$_n;
                    my $_n = scalar reverse @$S[0 .. $D];
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
            foreach my $r (
                @T[
                ((($count == 0) && $i) ? 0 : 1)
                    ..
                9]
            )
            {
                my @N = @$r[@$S, 0];

                # $nc == new_count
                my $nc = $count + (grep { $_ == 0 } @N);
                if ($nc < 2)
                {
                    $rec->($i+1, \@N, $nc);
                }
            }
        }

        return;
    };

    $rec->(0, [], 0);

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
