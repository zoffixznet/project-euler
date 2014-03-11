#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

=head1 DESCRIPTION

Taking three different letters from the 26 letters of the alphabet, character
strings of length three can be formed.

Examples are 'abc', 'hat' and 'zyx'.

When we study these three examples we see that for 'abc' two characters come
lexicographically after its neighbour to the left.

For 'hat' there is exactly one character that comes lexicographically after its
neighbour to the left. For 'zyx' there are zero characters that come
lexicographically after its neighbour to the left.

In all there are 10400 strings of length 3 for which exactly one character
comes lexicographically after its neighbour to the left.

We now consider strings of n ≤ 26 different characters from the alphabet.
For every n, p(n) is the number of strings of length n for which exactly one character comes lexicographically after its neighbour to the left.

What is the maximum value of p(n)?

=cut

my @_cache;

sub lookup
{
    my ($len, $last_letter, $count) = @_;

    return ($_cache[$len][$last_letter][$count] // 0);
}

sub set
{
    my ($len, $last_letter, $count, $new_val) = @_;

    $_cache[$len][$last_letter][$count] = $new_val;

    return;
}

sub add
{
    my ($len, $last_letter, $count, $delta) = @_;

    set ($len, $last_letter, $count,
        (lookup($len, $last_letter, $count) + $delta),
    );

    return;
}

my $COUNT_LETTERS = 26;
my $MAX_LETTER = $COUNT_LETTERS - 1;

# Initialise the letters of length 1.
foreach my $letter (0 .. $MAX_LETTER)
{
    set(1, $letter, 0, 1);
}

foreach my $len (2 .. $COUNT_LETTERS)
{
    my $prev_len = $len - 1;
    foreach my $next_letter (0 .. $MAX_LETTER)
    {
        foreach my $prev_letter (0 .. $MAX_LETTER)
        {
            foreach my $count (0 .. 1)
            {
            }
        }
    }
}
