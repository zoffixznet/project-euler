#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

my @s_n = (0);
my @f_n = (0);

STDOUT->autoflush(1);

for my $n ( 1 .. 1_000_000_000_000 )
{
    if ( $n % 1_000_000 == 0 )
    {
        print "Reached $n\n";
    }
    for my $d ( split //, $n )
    {
        $f_n[$d]++;
    }
    foreach my $d ( 1 .. 9 )
    {
        if ( $f_n[$d] == $n )
        {
            $s_n[$d] += $n;
        }
    }
}

print "\@s_n == [@s_n]\nSum == ", sum(@s_n), "\n";
