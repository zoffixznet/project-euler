#!/usr/bin/perl

use strict;
use warnings;

my $prev_row_count = 1;
my $prev_row = '';
my $next_row = '';

my $result_count = 0;
# while ($row_count++ <= 1_000_000_000)
vec($prev_row, 0, 4) = 1;
$result_count++;
while ($prev_row_count < 1_000_000_000)
{
    if ($prev_row_count % 1_000 == 0)
    {
        print "Reached $prev_row_count\n";
    }
    vec($next_row, 0, 4) = 1;
    for my $i (1 .. $prev_row_count-1)
    {
        if (
        vec($next_row, $i, 4) =
            ((vec($prev_row, $i-1, 4) + vec($prev_row, $i, 4)) % 7)
        )
        {
            $result_count++;
        }
    }
    vec($next_row, $prev_row_count, 4) = 1;
    # For the two 1s on the sides of the row.
    $result_count += 2;
}
continue
{
    $prev_row = $next_row;
    $next_row = '';
    $prev_row_count++;
}

print "Result count = $result_count\n";
