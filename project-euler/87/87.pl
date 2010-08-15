#!/usr/bin/perl

use strict;
use warnings;

use integer;

=head1 DESCRIPTION

The smallest number expressible as the sum of a prime square, prime cube, and
prime fourth power is 28. In fact, there are exactly four numbers below fifty
that can be expressed in such a way:

28 = 2^(2) + 2^(3) + 2^(4)
33 = 3^(2) + 2^(3) + 2^(4)
49 = 5^(2) + 2^(3) + 2^(4)
47 = 2^(2) + 3^(3) + 2^(4)

How many numbers below fifty million can be expressed as the sum of a prime
square, prime cube, and prime fourth power?

=cut

my $limit = 50_000_000;

my $sq_limit = int(sqrt($limit));

my @primes = `primes 2 $sq_limit`;
chomp(@primes);

my $bit_mask = "";

my $count = 0;

foreach my $p_square (@primes)
{
    print "P-Sq = $p_square\n";

    my $sum1 = ($p_square ** 2);

    CUBE:
    foreach my $p_cube (@primes)
    {
        my $sum2 = $sum1 + ($p_cube ** 3);

        if ($sum2 > $limit)
        {
            last CUBE;
        }

        FOURTH:
        foreach my $p_fourth (@primes)
        {
            my $sum3 = $sum2 + ($p_fourth ** 4);

            if ($sum3 > $limit)
            {
                last FOURTH;
            }

            if (! vec($bit_mask, $sum3, 1))
            {
                $count++;
                vec($bit_mask, $sum3, 1) = 1;
            }
        }
    }
}
print "Count = $count\n";
