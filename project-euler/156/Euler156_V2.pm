package Euler156_V2;

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use parent 'Exporter';

our @EXPORT_OK = qw(calc_f_delta_for_leading_digits calc_f_delta f_d_n);

sub calc_f_delta
{
    my ($exp) = @_;

    return ($exp+1) * (10 ** $exp);
}

sub calc_f_delta_for_leading_digits
{
    my ($num_digits_after, $num_leading_d_digits) = @_;

    return $num_leading_d_digits * 10 ** $num_digits_after + (($num_digits_after-1 >= 0) ? calc_f_delta($num_digits_after-1) : 0);
}

sub f_d_n
{
    my ($d, $n) = @_;

    my @digits = reverse(split(//, ($n+1).''));

    my $ret = 0;

    my $num_leading_d_digits = 0;

    foreach my $place (reverse(keys @digits))
    {
        my $place_d = $digits[$place];

        for my $iter_d (0 .. $place_d-1)
        {
            if ($iter_d != $d)
            {
                $ret += calc_f_delta_for_leading_digits($place, $num_leading_d_digits);
            }
            else
            {
                $ret += calc_f_delta_for_leading_digits($place, $num_leading_d_digits+1);
            }
        }
        if ($place_d == $d)
        {
            $num_leading_d_digits++;
        }
    }

    return $ret;
}

1;
