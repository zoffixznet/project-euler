#!/usr/bin/perl

use strict;
use warnings;

use integer;

use IO::All;

# use Math::BigInt lib => 'GMP';

sub is_square
{
    my $n = shift;

    # my $root = int($n->copy->bsqrt());
    my $root = int( sqrt($n) );

    return ( $root * $root == $n );
}

my $e = ( 1 + 1 )**2 + 4 * 1**2;

my $count = 0;
foreach my $n ( 1 .. 4e9 )
{
    if ( is_square($e) )
    {
        $count++;
        print "${count}-th Golden nugget is $n\n";
    }

    $e += 10 * $n + 7;
}
