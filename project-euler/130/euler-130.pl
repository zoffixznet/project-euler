#!/usr/bin/perl

use strict;
use warnings;

sub calc_A
{
    my ($n) = @_;

    my $mod = 1;
    my $len = 1;

    while ($mod)
    {
        $mod = ( ( $mod * 10 + 1 ) % $n );
        $len++;
    }

    return $len;
}

open my $primes_fh, "primes 3|";
my $last_prime = int( scalar(<$primes_fh>) );

my $n     = 3;
my $count = 0;
my $sum   = 0;

while ( $count < 25 )
{
    if ( $n == $last_prime )
    {
        $last_prime = int( scalar(<$primes_fh>) );
    }
    elsif ( $n % 5 )
    {
        my $A = calc_A($n);
        if ( ( $n - 1 ) % $A == 0 )
        {
            $count++;
            $sum += $n;
            print "Found $n ; Sum = $sum ; Count = $count\n";
        }
    }
}
continue
{
    $n += 2;
}
