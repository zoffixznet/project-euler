#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $n = 3;

my $found = 0;
while ( $found < 124 )
{
    my @last = ( 1, 1, 1 );
    my %sigs = ( "@last" => undef(), );

L:
    while ( $last[-1] )
    {
        @last = ( @last[ 1, 2 ], ( $last[0] + $last[1] + $last[2] ) % $n );
        if ( exists( $sigs{"@last"} ) )
        {
            $found++;
            print "Found the ${found}'th find - $n\n";
            last L;
        }
        $sigs{"@last"} = undef();
    }
}
continue
{
    $n += 2;
}
