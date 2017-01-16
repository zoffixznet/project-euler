#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

sub exp_mod
{
    my ( $MOD, $b, $e ) = @_;

    if ( $e == 0 )
    {
        return 1;
    }

    my $rec_p = exp_mod( $MOD, $b, ( $e >> 1 ) );

    my $ret = $rec_p * $rec_p;

    if ( $e & 0x1 )
    {
        ( $ret %= $MOD ) *= $b;
    }

    return ( $ret % $MOD );
}

my $CYCLE_LEN   = 50_000_000;
my $RAINBOW_MOD = 10_000;

my $MOD = 1_000_000_000;

my $sum = 0;

my $count = 0;

STDOUT->autoflush(1);

sub recurse
{
    my ( $exp, $ten_to_exp, $_mod, $filtered ) = @_;

    print "count=$count\n" if ( ( ++$count ) % 1_000 == 0 );

    if ( $exp == 6 )
    {
        my $x = 0;
        my $rainbow_mod = exp_mod( $ten_to_exp, $_mod, $ten_to_exp );
        foreach my $rainbow_val ( keys %$filtered )
        {
            my $e = $rainbow_val;
            my $power = exp_mod( $ten_to_exp, $_mod, $e );
            for ( ; $e < $CYCLE_LEN ; $e += $RAINBOW_MOD )
            {
                # Put the cheaper conditional first.
                if ( ( $power > $x ) && ( $power % $CYCLE_LEN == $e ) )
                {
                    $x = $power;
                }
                ( $power *= $rainbow_mod ) %= $ten_to_exp;
            }
            if ( ( $power > $x ) && ( $power % $CYCLE_LEN == $e ) )
            {
                $x = $power;
            }
        }

        $sum += $x;
        return;
    }
    else
    {
        my $next_ten_to_exp = $ten_to_exp * 10;

        # Avoid (modulo 10) == 0 because it is zero.
        for my $next_digit ( ( ( $exp == 0 ) ? 1 : 0 ) .. 9 )
        {
            my $new_mod = $_mod + ( $next_digit * $ten_to_exp );
            my $exp_MOD_mod =
                exp_mod( $next_ten_to_exp, $new_mod, $ten_to_exp );
            my %possible_mods;
            my $m = $new_mod;

            while ( ( $possible_mods{$m} // 0 ) != 1 )
            {
                $possible_mods{$m}++;

                ( $m *= $new_mod ) %= $next_ten_to_exp;
            }

            my %new_filtered;

            foreach my $m (
                sort { $a <=> $b }
                grep { exists( $filtered->{ $_ % $ten_to_exp } ) }
                keys(%possible_mods)
                )
            {
                my %f;
                my $v = exp_mod( $next_ten_to_exp, $new_mod, $m );
                while ( ( $f{$v} // 0 ) != 1 )
                {
                    $f{$v}++;
                    ( $v *= $exp_MOD_mod ) %= $next_ten_to_exp;
                }

                if ( exists( $f{$m} ) )
                {
                    $new_filtered{$m} = undef();
                }
            }

            # print "mod=$new_mod --> ", join(", ", @new_filtered), "\n";
            # print "mod=$mod mod^100-mod = " , exp_mod($mod,$MOD), "\n";
            recurse( $exp + 1, $next_ten_to_exp, $new_mod, \%new_filtered );
        }
    }
}

recurse( 0, 1, 0, +{ map { $_ => undef() } 0 .. 9 } );

print "Sum == $sum\n";
