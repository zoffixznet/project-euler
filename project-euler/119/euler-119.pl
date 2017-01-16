#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::Util qw(sum);

my $power_num_idx = 0;

for ( my $i = 10 ; ; $i++ )
{
    my $s = sum( split //, $i );

    if ( $s == 1 )
    {
        next;
    }
    my $pow = $s * $s;

    while ( $pow < $i )
    {
        $pow *= $s;
    }

    if ( $pow == $i )
    {
        $power_num_idx++;
        print "a[$power_num_idx] = $i\n";
    }
}

