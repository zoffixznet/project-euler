#!/usr/bin/perl

use strict;
use warnings;



use Math::GMP qw(:constant);

my @counts;

$counts[0] = { start_with_block => 0, start_with_square => 1 };
$counts[1] = { start_with_block => 0, start_with_square => 1 };
$counts[2] = { start_with_block => 0, start_with_square => 1 };

for my $len (3 .. 50)
{
    my $with_square = $counts[-1]->{start_with_block} + $counts[-1]->{start_with_square};
    my $with_block = 0;
    for my $block_len (3 .. $len-1)
    {
        $with_block += $counts[-$block_len]->{start_with_square};
    }
    # For $block_len == $len
    $with_block++;
    push @counts, +{
        start_with_block => $with_block,
        start_with_square => $with_square
    };
}

print $counts[-1]->{start_with_block} + $counts[-1]->{start_with_square}, "\n";
