#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils (qw(all));

for my $n_proto ( 0 .. 1_000_000 )
{
    # Number must start with 1 because 6x should contain the same digit
    # as it is so it must be the same length.
    my $n = "1$n_proto";

    my $n_sorted = join( "", sort split( //, $n ) );

    if ( all { join( "", sort split( //, $n * $_ ) ) eq $n_sorted } ( 2 .. 6 ) )
    {
        print "$n\n";
    }
}
