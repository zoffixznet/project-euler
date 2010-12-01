#!/usr/bin/perl 

use strict;
use warnings;

my %p_counts;

for my $bb (2 .. 500)
{
    A_LOOP:
    for my $aa (1 .. $bb)
    {
        my $sq = $bb*$bb+$aa*$aa;
        my $cc = int(sqrt($sq));
        my $p = $aa+$bb+$cc;
        if ($p >= 1000)
        {
            last A_LOOP;
        }
        elsif ($cc*$cc == $sq)
        {
            $p_counts{$p}++;
        }
    }
}

print map { "$_ => $p_counts{$_}\n" } 
    sort { $p_counts{$a} <=> $p_counts{$b} } keys(%p_counts)
    ;
