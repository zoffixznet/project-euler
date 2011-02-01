#!/usr/bin/perl

use strict;
use warnings;

use Games::Cards::Poker qw(:all);

open I, "<", "../poker.txt";
my $count = 0;
while (<I>)
{
    chomp;
    my @cards = split;
    if (SlowScoreHand(@cards[0..4]) < SlowScoreHand(@cards[5..9]))
    {
        $count++;
    }
}
close(I);
print "$count\n";
