#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt;
use Math::BigRat;

my %h = ();

foreach my $numer ( 11 .. 99 )
{
    if ( $numer % 10 == 0 )
    {
        next;
    }

    foreach my $denom ( ( $numer + 1 ) .. 99 )
    {
        my $get_my = sub {
            my $digit = shift;
            my ( $n, $d ) = ( $numer, $denom );
            if (   ( $d =~ s{$digit}{} )
                && ( $n =~ s{$digit}{} )
                && ( $d * $numer == $n * $denom ) )
            {
                return ( $n, $d );
            }
            else
            {
                return ();
            }
        };

        foreach my $digit ( $numer % 10, int( $numer / 10 ) )
        {
            if ( my ( $n, $d ) = $get_my->($digit) )
            {
                my $gcd = Math::BigInt::bgcd( $n, $d );
                $n /= "$gcd";
                $d /= "$gcd";

                print "$n/$d\n";
                $h{"$n/$d"}++;
            }
        }
    }
}

print "Results == ", ( join ' , ', keys(%h) ), "\n"

