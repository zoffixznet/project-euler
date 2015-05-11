#!/usr/bin/perl

use strict;
use warnings;

use bytes;

STDOUT->autoflush(1);
STDERR->autoflush(1);

use Math::GMPf qw(:mpf);
Rmpf_set_default_prec(1000);

# Math::GMPf->precision(50);
# Math::GMPf->accuracy(50);
# my $sum = Math::GMPf->new('0');
my $eps = Math::GMPf->new('1e-10');
for my $n (1 .. 30)
{
    print STDERR "Evaulating $n\n";
    my $top_pivot = Math::GMPf->new(2) ** $n;
    my $exp2 = $top_pivot;
    my $delta = Math::GMPf->new('0.00000001');

    my $calc = sub {
        my ($x) = @_;

        return +($x ** 2) * ($x - $exp2) + $n;
    };

    my $bottom_pivot = $top_pivot - $delta;
    my $bottom_val = $calc->($bottom_pivot);
    while ($bottom_val > 0)
    {
        $delta *= 2;
        $bottom_pivot = $top_pivot - $delta;
        $bottom_val = $calc->($bottom_pivot);
    }

    my $mid = ($top_pivot + $bottom_pivot) / 2;
    my $mid_val = $calc->($mid);
    while (abs($mid_val) > $eps)
    {
        # print "top=$top_pivot; bottom=$bottom_pivot ; mid=$mid ; mid_val=$mid_val\n";
        if ($mid_val > 0)
        {
            $top_pivot = $mid;
        }
        else
        {
            $bottom_pivot = $mid;
        }
        $mid = ($top_pivot + $bottom_pivot) / 2;
        $mid_val = $calc->($mid);
    }

    my $val = Rmpf_init();
    Rmpf_floor($val, ($mid ** 987654321));
    # print "Found f($n) = $val\n";
    print "Found f($n) = ", Rmpf_get_str($val, 10, 0), "\n";
    # print "S($n) = $sum\n";
}

# print "Sum = $sum\n";
