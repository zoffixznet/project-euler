#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt 'lib' => 'GMP', ':constant';

sub factorize
{
    my ($n) = @_;
    my @ret;

    my $factor = 2;
    while ( $n > 1 )
    {
        if ( $n % $factor == 0 )
        {
            push @ret, $factor;
            $n /= $factor;
        }
        else
        {
            $factor++;
        }
    }
    return \@ret;
}

# l = len or logarithm.
# n = a promise for the number.
my @factors = (
    +{
        l => 2,
        n => sub { return 11; }
    },
    (
        map {
            my $e = $_;
            +{
                l => ( ( 2**$e ) + 1 ),
                n => sub { return 10**( 2**$e ) + 1; },
                }
        } ( 1 .. 9 )
    ),
    (
        map {
            my $e = $_;
            my $ten_e = ( 2**9 ) * ( 5**$e );
            +{
                l => ( 4 * $ten_e + 1 ),
                n => sub {
                    my $x = ( 10**$ten_e );
                    return 1 + $x + ( $x**2 ) + ( $x**3 ) + ( $x**4 );
                },
                }
        } ( 1 .. 9 )
    ),
);

@factors = ( sort { $a->{l} <=> $b->{l} } @factors );

my @primes;

my $LIMIT = 40;

NON_P_FACTORS:
foreach my $fact (@factors)
{
    print "$fact->{l}\n";
    my $n = $fact->{n}->();

    print "N = $n\n";
    my $l = <STDIN>;
    next NON_P_FACTORS;

    push @primes, @{ factorize($n) };

    @primes = sort { $a <=> $b } @primes;

    if ( @primes > $LIMIT )
    {
        splice( @primes, $LIMIT );
    }

    if ( @primes == $LIMIT )
    {
        my $s = 0;

        foreach my $p (@primes)
        {
            $s += $p;
        }
        print "Primes [", join( ',', @primes ), "]\n";
        print "Sum = $s\n";
    }
}
