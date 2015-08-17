#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 20000;

use DivideFsm;

{
    my ($g, $r) = DivideFsm::get_div_fsms(7);

    for my $i (1 .. 10000)
    {
        my @d = reverse split//, $i;

        my $s = 0;
        for my $digit (@d)
        {
            $s = $r->[$s]->[$digit];
        }

        # TEST*10000
        is (($s == 0) ? 1 : 0, ($i % 7 == 0) ? 1 : 0, "Num matches");
    }

    for my $i (1 .. 10000)
    {
        my @d = split//, $i;

        my $s = 0;
        for my $digit (@d)
        {
            $s = $g->[$s]->[$digit];
        }

        # TEST*10000
        is (($s == 0) ? 1 : 0, ($i % 7 == 0) ? 1 : 0, "Num matches");
    }
}

