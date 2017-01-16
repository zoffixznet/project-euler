#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt ( try => 'GMP' );
use 5.016;

my @results;
my $sum       = Math::BigInt->new('0');
my $num_found = 0;
my $MIN       = 2;
my $MAX       = 1_000_000;

while (<>)
{
    chomp;
    if ( my ( $n, $result ) = /\Af\((\d+)\) == (\d+)\z/ )
    {
        if ( $n >= $MIN and $n <= $MAX )
        {
            if ( !defined( $results[$n] ) )
            {
                $results[$n] = $result;
                $sum += $result;
                $num_found++;
            }
            elsif ( $results[$n] != $result )
            {
                die "f[$n] is both $result and $results[$n]!";
            }
        }
    }
}

if ( $num_found == $MAX - $MIN + 1 )
{
    say "Sum == $sum\n";
}
else
{
    die "Could only found $num_found.";
}
