#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 170000;

use DivideFsm;

for my $BASE (grep { $_ != 10 } 2 .. 19)
{
    my ($g, $r) = DivideFsm::get_div_fsms($BASE);

    # for my $i (1 .. 10000)
    for my $i (())
    {
        my @d = reverse split//, $i;

        my $s = 0;
        for my $digit (@d)
        {
            $s = $r->[$s]->[$digit];
        }

        #+TEST*10000*17
        is (($s == 0) ? 1 : 0, ($i % $BASE == 0) ? 1 : 0, "Num matches");
    }

    for my $i (1 .. 10000)
    {
        my @d = split//, $i;

        my $s = 0;
        for my $digit (@d)
        {
            $s = $g->[$s]->[$digit];
        }

        # TEST*10000*17
        is (($s == 0) ? 1 : 0, ($i % $BASE == 0) ? 1 : 0, "Num matches");
    }
}

