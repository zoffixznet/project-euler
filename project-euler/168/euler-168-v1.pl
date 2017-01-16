#!/usr/bin/perl

use strict;
use warnings;

# use Math::BigInt lib => 'GMP', ':constant';

use Math::GMP (':constant');

# use List::Util qw(sum);
# use List::MoreUtils qw();

# $multiplier is "d"
my $sum = 0;
foreach my $multiplier ( 1 .. 9 )
{
    foreach my $L ( 1 .. 99 )
    {
        # $digit is m.
        foreach my $digit ( 1 .. 9 )
        {
            my $n =
                ( ( ( 10**$L - $multiplier ) * $digit ) /
                    ( 10 * $multiplier - 1 ) );

            my $number_to_check = $n * 10 + $digit;
            if ( length($n) == $L
                and ( $multiplier * $number_to_check == $n + $digit * 10**$L ) )
            {
                print "Found $number_to_check\n";
                $sum += $number_to_check;
                print "Sum = $sum\n";
            }
        }
    }
}

print "Last 5 digits of the final sum are: ", substr( "$sum", -5 ), "\n";
