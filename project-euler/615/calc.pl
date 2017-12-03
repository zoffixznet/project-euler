#!/usr/bin/perl

use strict;
use warnings;

no warnings 'recursion';

use Math::GMP ();

use integer;
use bytes;

STDOUT->autoflush(1);

sub exp_mod
{
    my ( $base, $exp, $mod ) = @_;

    if ( $exp == 0 )
    {
        return 1;
    }
    my $rec = exp_mod( $base, $exp >> 1, $mod );
    my $ret = ( $rec * $rec ) % $mod;
    if ( $exp & 1 )
    {
        $ret = ( ( $ret * $base ) % $mod );
    }
    return $ret;
}

my $MOD = 123454321;
print( ( exp_mod( 2, 999999, $MOD ) * 17 * 18617 % $MOD ), "\n" );
