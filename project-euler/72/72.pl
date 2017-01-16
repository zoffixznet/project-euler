#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt try => "GMP";

my $size = shift(@ARGV);

my @counts = ( 0, 0, ( 1 .. $size - 1 ) );

my $sum       = 0;
my $total_sum = Math::BigInt->new("0");

my $l = int( $size / 2 );
foreach my $d ( 2 .. $l )
{
    print "d=$d\n" if ( $d % 1_000 == 0 );
    foreach my $m ( 2 .. int( $size / $d ) )
    {
        $counts[ $d * $m ] -= $counts[$d];
    }
    if ( ( $sum += $counts[$d] ) > 1_000_000_000 )
    {
        $total_sum += $sum;
        $sum = 0;
    }
}

foreach my $d ( $l + 1 .. $size )
{
    print "d=$d\n" if ( $d % 1_000 == 0 );
    if ( ( $sum += $counts[$d] ) > 1_000_000_000 )
    {
        $total_sum += $sum;
        $sum = 0;
    }
}
$total_sum += $sum;
$sum = 0;

print "tot=$total_sum\n";
