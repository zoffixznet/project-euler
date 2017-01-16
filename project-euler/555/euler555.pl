#!/usr/bin/perl

# This program is based on euler-179.pl and on a solution of Euler no. 555
# from the forums by "Mohammad_Ali_B". It is quite fast but consumes a lot
# of RAM due to the caching.
use strict;
use warnings;
use integer;

use List::Util qw(reduce);

sub factorize_helper
{
    my ( $n, $start_from ) = @_;

    my $limit = int( sqrt($n) );

    if ( $n == 1 )
    {
        return [];
    }

    my $d = $n;
    while ( $d % $start_from )
    {
        if ( ++$start_from > $limit )
        {
            return [ [ $n, 1 ] ];
        }
    }

    $d /= $start_from;

    my @n_factors = ( map { [@$_] } @{ factorize_helper( $d, $start_from ) } );

    if ( @n_factors && $n_factors[0][0] == $start_from )
    {
        $n_factors[0][1]++;
    }
    else
    {
        unshift @n_factors, ( [ $start_from, 1 ] );
    }

    return \@n_factors;
}

sub factorize
{
    my ($n) = @_;
    return factorize_helper( $n, 2 );
}

sub divisors
{
    my $ret = [1];
    foreach my $f ( @{ factorize(shift) } )
    {
        my ( $b, $e ) = @$f;
        my @d = (1);
        for my $i ( 1 .. $e )
        {
            push @d, $d[-1] * $b;
        }
        $ret = [
            map {
                my $x = $_;
                map { $_ * $x } @d
            } @$ret
        ];
    }
    return $ret;
}

sub faulhaber1
{
    my ($n) = @_;

    return ( ( $n * ( $n + 1 ) ) >> 1 );
}

sub sum
{
    my ( $p, $m ) = @_;
    my $total = 0;

    foreach my $s ( 1 .. $p - 1 )
    {
        foreach my $d ( @{ divisors($s) } )
        {
            my $k = $s + $d;
            if ( $k <= $p )
            {
                $total +=
                    faulhaber1( $m + $k - ( $s << 1 ) ) - faulhaber1( $m - $s );
            }
        }
    }

    return $total;
}

sub print_sum
{
    my ( $p, $m ) = @_;

    printf "Sum(p=%d,m=%d) = %d\n", $p, $m, sum( $p, $m );
}

print_sum( 1000,    1000 );
print_sum( 1000000, 1000000 );
