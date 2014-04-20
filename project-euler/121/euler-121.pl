#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

A bag contains one red disc and one blue disc. In a game of chance a player
takes a disc at random and its colour is noted. After each turn the disc is
returned to the bag, an extra red disc is added, and another disc is taken at
random.

The player pays £1 to play and wins if they have taken more blue discs than red
discs at the end of the game.

If the game is played for four turns, the probability of a player winning is
exactly 11/120, and so the maximum prize fund the banker should allocate for
winning in this game would be £10 before they would expect to incur a loss.
Note that any payout will be a whole number of pounds and also includes the
original £1 paid to play the game, so in the example given the player actually
wins £9.

Find the maximum prize fund that should be allocated to a single game in which
fifteen turns are played.

=cut

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

