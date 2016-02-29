#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat;

my $num_turns = shift(@ARGV);

my @B_nums_probs = (1);

foreach my $turn_idx (1 .. $num_turns)
{
    my $this_B_prob = Math::BigRat->new('1/'.($turn_idx+1));

    push @B_nums_probs, (0);

    my @new_B_probs = map {
        my $i = $_;
        $B_nums_probs[$i] * (1-$this_B_prob) +
            (($i == 0) ? 0 : ($B_nums_probs[$i-1] * $this_B_prob))
        } (0 .. $turn_idx);

    @B_nums_probs = @new_B_probs;
}

my $s = Math::BigRat->new('0');

foreach my $idx ( int($num_turns/2)+1 .. $num_turns)
{
    $s += $B_nums_probs[$idx];
}

print "S = $s\n";
print "Int[1/S] = ", int(1/$s), "\n";

