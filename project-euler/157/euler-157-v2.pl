#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %l = (
    ''          => 1,
    '0'         => 2,
    '00'        => 3,
    '000'       => 4,
    '0000'      => 5,
    '00000'     => 6,
    '000000'    => 7,
    '0000000'   => 8,
    '00000000'  => 9,
    '000000000' => 9,
);

my $base = 1_000_000_000;
my $t;
for my $p ( 1 .. ( $base << 2 ) )
{
    # Start
    my $S = $base / $p;

    # Limit
    my $L = ( $S << 1 );

    # Count;
    my $c = 0;

    # 1/B numerator / denom
    my $Bd = $base * $S;
    my $Bn = $p * $S - $base;

    if ( $Bn > 0 )
    {
        if ( $Bd % $Bn == 0 )
        {
            $c++;
            print "A=$S c++\n";
        }
    }

    $Bd += $base;
    $Bn += $p;
A:
    for my $A ( $S + 1 .. $L )
    {
        if ( $Bd % $Bn == 0 )
        {
            $c++;
            print "A=$A c++\n";
        }
    }
    continue
    {
        $Bd += $base;
        $Bn += $p;
    }

    # Zeros
    my ($z) = ( $p =~ /(0*)\z/ );
    $t += $c * $l{$z};
    print "p=$p t=$t\n";
}
