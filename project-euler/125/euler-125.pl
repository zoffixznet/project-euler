#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => "GMP", ":constant";

=head1 DESCRIPTION

The palindromic number 595 is interesting because it can be written as the sum
of consecutive squares: 6^2 + 7^2 + 8^2 + 9^2 + 10^2 + 11^2 + 12^2.

There are exactly eleven palindromes below one-thousand that can be written as
consecutive square sums, and the sum of these palindromes is 4164. Note that 1
= 02 + 12 has not been included as this problem is concerned with the squares
of positive integers.

Find the sum of all the numbers less than 108 that are both palindromic and can
be written as the sum of consecutive squares.

=cut

# my $limit = shift(@ARGV);

my $limit = 100_000_000;

my $sqrt_limit = int(sqrt($limit));

my %found;
my $sum_found = 0;

foreach my $start (1 .. $sqrt_limit)
{
    my $sum = $start ** 2;

    SUM_LOOP:
    foreach my $end (($start+1) .. $sqrt_limit)
    {
        $sum += $end ** 2;
        if ($sum > $limit)
        {
            last SUM_LOOP;
        }

        if (scalar(reverse("$sum")) eq "$sum")
        {
            if (! $found{"$sum"}++)
            {
                print "Found $sum\n";
                $sum_found += $sum;
            }
        }
    }
}

print "Sum found = $sum_found\n";
