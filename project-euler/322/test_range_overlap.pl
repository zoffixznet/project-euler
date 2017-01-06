#!/usr/bin/perl

use strict;
use warnings;
use bigint;
use autodie;

use List::Util qw/ min max /;

my $bin_low_s = '100110001001011001110110';
my $bin_high_s = $bin_low_s =~ s#0#1#gr;

my $bin_low = eval"0b$bin_low_s";
my $bin_high = eval"0b$bin_high_s";
my $bin_offsets = $bin_high + 1 - $bin_low;

my $f5_low = $bin_low;
my $f5_high = 1;
while ($f5_high < $f5_low)
{
    $f5_high *= 5;
}

$f5_high--;
my $f5_offsets = $f5_high + 1 - $f5_low;

my @state = ([$bin_low, $bin_high, $bin_high+1], [$f5_low, $f5_high, $f5_high+1]);

sub adv
{
    my $i = shift;
    print "Adv $i\n";
    for my $j (0 .. 1)
    {
        $state[$i][$j] += $state[$i][2];
    }
    return;
}

while (1)
{
    while ($state[0][1] < $state[1][0])
    {
        adv(0);
    }
    while ($state[1][1] < $state[0][0])
    {
        adv(1);
    }

    if ($state[0][0] >= $state[1][0] and $state[0][0] <= $state[1][1])
    {
        print "Overlap $state[0][0] -> ", min($state[1][1], $state[0][1]), "\n";
        adv(0);
    }
    elsif ($state[1][0] >= $state[0][0] and $state[1][0] <= $state[0][1])
    {
        print "Overlap $state[1][0] -> ", min($state[1][1], $state[0][1]), "\n";
        adv(1);
    }
}
