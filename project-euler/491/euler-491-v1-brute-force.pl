#!/usr/bin/perl

use strict;
use warnings;

my ($MAX_DIGIT) = @ARGV;

my $num_half_digits = $MAX_DIGIT + 1;
my $num_digits      = $num_half_digits * 2;

my $start = 10**( $num_digits - 1 );
my $end   = ( $MAX_DIGIT + 1 ) * $start - 1;

my $count = 0;

my $id = join( "", sort { $a cmp $b } ( ( 0 .. $MAX_DIGIT ) x 2 ) );

for my $n ( $start .. $end )
{
    if ( join( "", sort { $a cmp $b } split //, $n ) eq $id
        and ( $n % 11 == 0 ) )
    {
        print "Found $n\n";
        $count++;
    }
}

print "Count = $count\n";
