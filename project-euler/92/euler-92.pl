#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

=head1 DESCRIPTION

A number chain is created by continuously adding the square of the digits in a number to form a new number until it has been seen before.

For example,

44 → 32 → 13 → 10 → 1 → 1
85 → 89 → 145 → 42 → 20 → 4 → 16 → 37 → 58 → 89

Therefore any chain that arrives at 1 or 89 will become stuck in an endless loop. What is most amazing is that EVERY starting number will eventually arrive at 1 or 89.

How many starting numbers below ten million will arrive at 89?

=cut

my $count = 0;

foreach my $n (2 .. 10_000_000)
{
    if ($n % 10_000 == 0)
    {
        print "$n [$count]\n";
    }
    my $i = $n;
    while (($i != 1) && ($i != 89))
    {
        $i = (sum map { $_ * $_ } split//,$i)
    }
    if ($i == 89)
    {
        $count++;
    }
}

print "Count = $count\n";
