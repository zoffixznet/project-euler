#!/usr/bin/perl

use strict;
use warnings;
use integer;

use List::Util qw(reduce);

my @Cache = ( undef, [] );

sub factorize_helper
{
    my ( $n, $start_from ) = @_;

    my $limit = int( sqrt($n) );

    if ( !defined( $Cache[$n] ) )
    {
        my $d = $n;
        while ( $d % $start_from )
        {
            if ( ++$start_from > $limit )
            {
                return $Cache[$n] = [ [ $n, 1 ] ];
            }
        }

        $d /= $start_from;

        my @n_factors =
            ( map { [@$_] } @{ factorize_helper( $d, $start_from ) } );

        if ( @n_factors && $n_factors[0][0] == $start_from )
        {
            $n_factors[0][1]++;
        }
        else
        {
            unshift @n_factors, ( [ $start_from, 1 ] );
        }

        $Cache[$n] = \@n_factors;
    }
    return $Cache[$n];
}

sub factorize
{
    my ($n) = @_;
    return factorize_helper( $n, 2 );
}

sub count_divisors
{
    return reduce { $a * $b } map { $_->[1] + 1 } @{ factorize(shift) };
}

my $START   = 2;
my $n_count = count_divisors($START);
my $result  = 0;
for my $n_plus ( ( $START + 1 ) .. 10_000_000 )
{
    if ( $n_plus % 10_000 == 0 )
    {
        print "N-plus == $n_plus\n";
    }
    my $new_count = count_divisors($n_plus);
    if ( $new_count == $n_count )
    {
        $result++;
    }
    $n_count = $new_count;
}

print "Result: $result\n";
