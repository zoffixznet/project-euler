#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

my @counts;

my $min_len = 50;

foreach my $len (0 .. $min_len-1)
{
    push @counts, { start_with_block => 0, start_with_square => 1 };
}

LEN_LOOP:
for my $len ($min_len .. 1_000_000)
{
    my $with_square = $counts[-1]->{start_with_block} + $counts[-1]->{start_with_square};
    my $with_block = 0;
    for my $block_len ($min_len .. $len-1)
    {
        $with_block += $counts[-$block_len]->{start_with_square};
    }
    # For $block_len == $len
    $with_block++;
    push @counts, +{
        start_with_block => $with_block,
        start_with_square => $with_square
    };

    if ($with_block + $with_square > 1_000_000)
    {
        print "Found $len\n";
        last LEN_LOOP;
    }
}
