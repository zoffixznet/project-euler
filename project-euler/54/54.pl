#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Games::Cards::Poker qw(:all);

open my $in, '<', '../poker.txt';
my $count = 0;
while (<$in>)
{
    chomp;
    my @cards = split;
    if (SlowScoreHand(@cards[0..4]) < SlowScoreHand(@cards[5..9]))
    {
        $count++;
    }
}
close($in);
print "$count\n";
