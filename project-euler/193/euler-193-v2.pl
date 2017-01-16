#!/usr/bin/perl

use strict;
use warnings;

use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $SQRT_LIMIT = ( $ENV{MAX} || ( 1 << 25 ) );
my $LIMIT = ( $SQRT_LIMIT * $SQRT_LIMIT );

my @p_sq = ( map { $_ * $_ } `primes 2 $SQRT_LIMIT` );

my $SQRT_IDX = sub {
    for my $i ( keys(@p_sq) )
    {
        if ( $p_sq[$i] > $SQRT_LIMIT )
        {
            return $i - 1;
        }
    }
    die "Foo!";
    }
    ->();

my $count = 0;

sub recurse
{
    my ( $min_i, $parity, $prod ) = @_;

    my $x = int( $LIMIT / $prod );

    if ($parity)
    {
        $count += $x;
    }
    else
    {
        $count -= $x;
    }

    my $np = ( $parity ^ 0x1 );
I:
    for my $i ( $min_i .. $#p_sq )
    {
        my $new_prod = $prod * $p_sq[$i];

        if ( $new_prod > $LIMIT )
        {
            last I;
        }
        recurse( $i + 1, $np, $new_prod );
    }

    return;
}

for my $i ( 0 .. $SQRT_IDX )
{
    print "Checking $p_sq[$i]\n";
    recurse( $i + 1, 1, $p_sq[$i] );
}

for my $p ( @p_sq[ ( $SQRT_IDX + 1 ) .. $#p_sq ] )
{
    $count += int( $LIMIT / $p );
}

print "Count = $count\n";
print "Remaining = ", ( $LIMIT - $count ), "\n";
