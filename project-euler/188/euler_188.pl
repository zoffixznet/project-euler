#!/usr/bin/perl

use strict;
use warnings;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

no warnings 'recursion';

sub hyperexp_modulo
{
    my ( $base, $exp, $mod ) = @_;

    if ( $exp == 1 )
    {
        return ( $base % $mod );
    }

    my $mod1 = $base;
    my $e    = 1;

    while ( $mod1 != 1 )
    {
        ( $mod1 *= $base ) %= $mod;
        $e++;
    }

    my $mod_recurse = hyperexp_modulo( $base, $exp - 1, $e );

    my $ret = 1;
    for my $i ( 1 .. $mod_recurse )
    {
        ( $ret *= $base ) %= $mod;
    }

    return $ret;
}

# print hyperexp_modulo(3, 3, 1000), "\n";

printf "Result == %08d\n", hyperexp_modulo( 1777, 1855, 100_000_000 );
