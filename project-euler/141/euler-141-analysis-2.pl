#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw(any);

STDOUT->autoflush(1);

my $base = 2;

while (1)
{
    my %d_3 = ( map { ( ( $_ * $_ * $_ ) % $base ) => 1 } ( 0 .. $base - 1 ) );

    for my $n_mod ( 0 .. $base - 1 )
    {
        my $n_sq_mod = ( $n_mod * $n_mod ) % $base;
        print "Base=$base N%base=$n_mod R[s]={" . join(
            ",",
            grep {
                exists( $d_3{ ( $_ * ( $n_sq_mod + $base - $_ ) ) % $base } )
            } ( 0 .. $base - 1 )
        ) . "}\n";
    }
}
continue
{
    $base++;
}
