#!/usr/bin/perl

use strict;
use warnings;

use bytes;

STDOUT->autoflush(1);
STDERR->autoflush(1);

use Math::MPFR qw(:mpfr);
Rmpfr_set_default_prec(10000);

# Math::MPFR->precision(50);
# Math::MPFR->accuracy(50);
# my $sum = Math::MPFR->new('0');
my $eps       = Math::MPFR->new('1e-300');
my $base      = Math::MPFR->new('1e8');
my $log_base  = log($base);
my $total_sum = 0;
for my $n ( 1 .. 30 )
{
    print STDERR "Evaulating $n\n";
    my $top_pivot = Math::MPFR->new(2)**$n;
    my $exp2      = $top_pivot;
    my $delta     = Math::MPFR->new('0.00000001');

    my $calc = sub {
        my ($x) = @_;

        return +( $x**2 ) * ( $x - $exp2 ) + $n;
    };

    my $bottom_pivot = $top_pivot - $delta;
    my $bottom_val   = $calc->($bottom_pivot);
    while ( $bottom_val > 0 )
    {
        $delta *= 2;
        $bottom_pivot = $top_pivot - $delta;
        $bottom_val   = $calc->($bottom_pivot);
    }

    my $mid     = ( $top_pivot + $bottom_pivot ) / 2;
    my $mid_val = $calc->($mid);
    while ( abs($mid_val) > $eps )
    {
 # print "top=$top_pivot; bottom=$bottom_pivot ; mid=$mid ; mid_val=$mid_val\n";
        if ( $mid_val > 0 )
        {
            $top_pivot = $mid;
        }
        else
        {
            $bottom_pivot = $mid;
        }
        $mid     = ( $top_pivot + $bottom_pivot ) / 2;
        $mid_val = $calc->($mid);
    }

    my $mid_log   = log($mid) / $log_base;
    my $log_times = $mid_log * 987654321;

    my $val = Rmpfr_init();
    Rmpfr_floor( $val, $log_times );

    my $diff = $log_times - $val;

    my $modulo = $base**$diff;

    $val = Rmpfr_init();
    Rmpfr_floor( $val, $modulo );

    # print "Found f($n) = $val\n";
    my $as_int = Rmpfr_integer_string( $val, 10, 0 );
    print "Found f($n) = $as_int\n";

    # print "S($n) = $sum\n";
    ( $total_sum += $as_int ) %= 1e8;
}

print "Sum = $total_sum\n";
