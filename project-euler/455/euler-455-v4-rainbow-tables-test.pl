#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

my $MOD = 10000;

sub exp_mod
{
    my ( $b, $e ) = @_;

    if ( $e == 0 )
    {
        return 1;
    }

    my $rec_p = exp_mod( $b, ( $e >> 1 ) );

    my $ret = $rec_p * $rec_p;

    if ( $e & 0x1 )
    {
        ( $ret %= $MOD ) *= $b;
    }

    return ( $ret % $MOD );
}

foreach my $mod ( 0 .. $MOD - 1 )
{
    if ( $mod % 10 != 0 )
    {
        my $exp_MOD_mod = exp_mod( $mod, $MOD );
        my %possible_mods;
        my $m = $mod;

        while ( ( $possible_mods{$m} // 0 ) != 1 )
        {
            $possible_mods{$m}++;

            ( $m *= $mod ) %= $MOD;
        }

        my @filtered;

        foreach my $m ( sort { $a <=> $b } keys(%possible_mods) )
        {
            my %f;
            my $v = exp_mod( $mod, $m );
            while ( ( $f{$v} // 0 ) != 1 )
            {
                $f{$v}++;
                ( $v *= $exp_MOD_mod ) %= $MOD;
            }

            if ( exists( $f{$m} ) )
            {
                push @filtered, $m;
            }
        }
        print "mod=$mod --> ", join( ", ", @filtered ), "\n";

        # print "mod=$mod mod^100-mod = " , exp_mod($mod,$MOD), "\n";
    }
}
