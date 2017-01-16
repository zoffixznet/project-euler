#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP;

my $MOD = $ENV{MOD};
my $MAX = $ENV{MAX};

my @counts;
for my $n ( 1 .. $MAX )
{
    $counts[ ( Math::GMP->new($n)->powm_gmp( $n, $MOD ) ) . '' ]++;
}
while ( my ( $mod, $c ) = each @counts )
{
    if ( defined($c) )
    {
        print "$mod: $c\n";
    }
}
