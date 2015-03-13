#!/usr/bin/perl

use strict;
use warnings;

my @row = (1);

my $n = shift(@ARGV);

for my $i (1 .. $n)
{
    print join("\n", @row), "\n";

    my @next_row = (1);
    for my $x (0 .. $#row-1)
    {
        push @next_row, $row[$x]+$row[$x+1];
    }
    @row = (@next_row, 1);
}
