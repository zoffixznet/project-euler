#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum min max);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $PI = atan2( 1, 1 ) * 4;
my $MIN_COS = cos( 120 * $PI / 180 );
for my $c ( 1 .. 120_000 )
{
    print "C=$c\n";
    for my $aa ( 1 .. $c )
    {
        my $numer = $aa * $aa - $c * $c;
        my $denom = 1 / ( 2 * $aa );

        # $c < $aa + $bb
        # $bb > $c - $aa
    B:
        for my $bb ( reverse( max( $c - $aa + 1, 1 ) .. $aa ) )
        {
            my $cos_C = ( $numer / $bb + $bb ) * $denom;
            if ( $cos_C <= $MIN_COS )
            {
                # print "Skipping [$c,$aa,$bb]\n";
                last B;
            }
            else
            {
                # print "Not skipping [$c,$aa,$bb]\n";
            }
        }
    }
}
