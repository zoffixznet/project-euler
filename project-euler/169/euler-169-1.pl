#!/usr/bin/perl

use strict;
use warnings;

use 5.014;
use Math::BigInt lib => 'GMP', ':constant';

STDOUT->autoflush(1);

my %cache;

sub recurse
{
    my ( $n, $max_factor ) = @_;

    if ( $n == 0 )
    {
        return 1;
    }

    if ( $max_factor == 0 )
    {
        return 0;
    }

    if ( ( ( ( $max_factor << 1 ) - 1 ) << 1 ) < $n )
    {
        return 0;
    }

    my $ret = (
        $cache{"$n;$max_factor"} //=
            do
        {

            my $ret = 0;

        COUNT:
            for my $count ( 0 .. 2 )
            {
                my $sub_n = $n - $max_factor * $count;
                if ( $sub_n < 0 )
                {
                    last COUNT;
                }
                $ret += recurse( $sub_n, ( $max_factor >> 1 ) );
            }

            $ret;
            }
    );

    return $ret;
}

my ( $msb, $next_msb );

if (1)
{
    my $N = ( 10**25 );
    $msb      = 1;
    $next_msb = ( $msb << 1 );
    while ( $next_msb < $N )
    {
        $msb = $next_msb->copy;
        $next_msb <<= 1;
    }
    print "N=$N Count=< ", recurse( $N, $msb ), " >\n";
}
else
{
    my $i = 1;
    $msb      = 1;
    $next_msb = ( $msb << 1 );
    while (1)
    {
        print "I=$i Count=", recurse( $i, $msb ), "\n";
    }
    continue
    {
        $i++;
        if ( $i == $next_msb )
        {
            $msb = $next_msb;
            $next_msb <<= 1;
        }
    }
}
