#!/usr/bin/perl 

use strict;
use warnings;

use List::Util qw(max);
use IO::All;

my $triangle_str = io()->file("triangle.txt")->slurp();

my @lines = (map { [split(/\s+/, $_)] } split(/\n/, $triangle_str));

my @totals_lines = ([ @{$lines[0]} ]);

for my $i (1 .. $#lines)
{
    my $last = $totals_lines[-1];
    my $this = $lines[$i];
    push @totals_lines,
        [
            map
            { 
                $this->[$_] +
                max(
                  (($_ > 0) ? ($last->[$_-1]) : ()),
                  (($_ < $#{$this}) ? ($last->[$_]) : ())
                )
            } (0 .. $#{$this})
        ];
}

printf "Max is %i\n", max(@{$totals_lines[-1]});

