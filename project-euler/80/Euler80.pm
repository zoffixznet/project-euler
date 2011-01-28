package Euler80;

use strict;
use warnings;

=head1 Project Euler 80 Problem

It is well known that if the square root of a natural number is not an integer, then it is irrational. The decimal expansion of such square roots is infinite without any repeating pattern at all.

The square root of two is 1.41421356237309504880..., and the digital sum of the first one hundred decimal digits is 475.

For the first one hundred natural numbers, find the total of the digital sums
of the first one hundred decimal digits for all the irrational square roots.

=cut

use Math::BigInt (":constant", lib => 'GMP');

my $required_digits = 100;

my $margin = 10;
my $req_digits_with_margin = $required_digits + $margin;

sub square_root
{
    my $n = shift;

    my $n_with_digits = $n * (10 ** ($req_digits_with_margin*2));

    my $min = 0;
    my $max = $n_with_digits;
    my $mid = (($max+$min) >> 1);

    my $epsilon = $n_with_digits / (10 ** $req_digits_with_margin);

    while (1)
    {
        my $square = $mid * $mid;

        # print "Mid = $mid\n";
        # print "Sq = $square\n";

        if (abs($square - $n_with_digits) <= $epsilon)
        {
            return $mid;
        }
        elsif ($square > $n_with_digits)
        {
            $max = $mid;
            $mid = (($max+$min) >> 1);
        }
        else
        {
            $min = $mid;
            $mid = (($max+$min) >> 1);
        }
    }
}

# print "Result == ", square_root(2), "\n";

1;

