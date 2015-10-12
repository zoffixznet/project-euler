#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use List::Util qw(sum);
use POSIX;

sub is_triangle
{
    my $n = shift()*2;

    my $i = int(sqrt($n));

    if ($i * $i == $n)
    {
        return 0;
    }
    else
    {
        return ($n == $i * ($i+1));
    }
}

my $text = io("./words.txt")->slurp();

my @words = ($text =~ m{([A-Z]+)}g);
print scalar(grep { is_triangle(sum(map { ord($_) - ord('A')+1 } split //, $_)) }@words), "\n";
