package Euler303_Take1;

use strict;
use warnings;

use integer;
use bytes;

use parent 'Exporter';

our @EXPORT_OK = (qw(f_div f_complete));

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub f_div
{
    my ($n) = @_;

    my $digit = 1;

    my $prev_place_products = [];
    my $tens = 10;
    for my $d (1 .. 9)
    {
        my $prod = $d * $n;
        if (($prod % 10) <= 2)
        {
            if ($prod !~ /[^012]/)
            {
                return $d;
            }
            push @$prev_place_products, [$d, ($prod/10)];
        }
    }

    while (1)
    {
        my $next_place_products = [];

        my $d_tens = 0;
        my $d_n = 0;
        for my $d (0 .. 9)
        {
            for my $p (@$prev_place_products)
            {
                my ($prev_factor, $mod) = @$p;
                my $prod = $d_n + $mod;

                if (($prod % 10) <= 2)
                {
                    my $factor = $d_tens + $prev_factor;
                    if ($prod !~ /[^012]/)
                    {
                        return $factor;
                    }
                    push @$next_place_products, [$factor, $prod/10];
                }
            }
        }
        continue
        {
            $d_tens += $tens;
            $d_n += $n;
        }
        $prev_place_products = $next_place_products;
    }
    continue
    {
        $digit++;
        $tens *= 10;
    }
}

sub f_complete
{
    my ($n) = @_;

    return f_div($n) * $n;
}

1;
