#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt try => "GMP";
use POSIX qw(floor ceil);

my ( $size, $l_n, $l_d, $u_n, $u_d ) = @ARGV;

my @masks = ( undef, undef, map { "" } ( 2 .. $size ) );

my $sum = 0;

# my $total_sum = Math::BigInt->new("0");

my $l = int( $size / 2 );
foreach my $d ( 2 .. $l )
{
    print "d=$d\n" if ( $d % 1_000 == 0 );
    foreach my $m ( 2 .. int( $size / $d ) )
    {
        my $bits = \$masks[ $d * $m ];
        foreach my $i ( 1 .. $d - 1 )
        {
            vec( $$bits, $i * $m, 1 ) = 1;
        }
    }
    my $bits = \$masks[$d];
    foreach
        my $i ( ceil( ( $d * $l_n ) / $l_d ) .. floor( ( $d * $u_n ) / $u_d ) )
    {
        if ( !vec( $$bits, $i, 1 ) )
        {
            $sum++;
        }
    }
}

foreach my $d ( $l + 1 .. $size )
{
    print "d=$d\n" if ( $d % 1_000 == 0 );
    my $bits = \$masks[$d];
    foreach
        my $i ( ceil( ( $d * $l_n ) / $l_d ) .. floor( ( $d * $u_n ) / $u_d ) )
    {
        if ( !vec( $$bits, $i, 1 ) )
        {
            $sum++;
        }
    }

}

print "tot = ", $sum - 2, "\n";

