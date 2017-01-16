#!/usr/bin/perl

use strict;
use warnings;

sub get_valid_n_mods_for_base
{
    my ($base) = @_;

    my %valid_L_squared_mods;

    for my $L ( 0 .. $base - 1 )
    {
        $valid_L_squared_mods{ ( $L * $L ) % $base } = 1;
    }

    my @valid_n_mods;
    for my $n ( 0 .. $base - 1 )
    {
        my $modulo = ( ( 1 + $n * ( 4 + $n * 5 ) ) % $base );
        if ( exists( $valid_L_squared_mods{$modulo} ) )
        {
            push @valid_n_mods, $n;
        }
    }

    return \@valid_n_mods;
}

my $min = undef;
for my $base ( reverse( 2 .. 100_000 ) )
{
    my $mods = get_valid_n_mods_for_base($base);
    if ( !defined $min or @$mods < $min )
    {
        $min = @$mods;
        print "Num Valid 'n's for $base: $min\n";
    }
}
