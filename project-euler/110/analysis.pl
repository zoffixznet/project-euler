#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);
use List::Util qw(reduce);

my @factors = sort { $a <=> $b } @ARGV;

my $n = reduce { $a * $b } 1, map { Math::GMP->new($_) } @factors;

my %counts;
foreach my $f (@factors)
{
    $counts{$f}++;
}

my $rank = reduce { $a * $b } 1, map { $_ * 2 + 1 } values(%counts);

print "N = $n\nRank = ", ( ( $rank + 1 ) / 2 ), "\n";
