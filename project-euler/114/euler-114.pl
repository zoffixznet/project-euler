#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

A row measuring seven units in length has red blocks with a minimum length of
three units placed on it, such that any two red blocks (which are allowed to be
different lengths) are separated by at least one black square. There are
exactly seventeen ways of doing this

How many ways can a row measuring fifty units in length be filled?

NOTE: Although the example above does not lend itself to the possibility, in
general it is permitted to mix block sizes. For example, on a row measuring
eight units in length you could use red (3), black (1), and red (4).

=cut

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
