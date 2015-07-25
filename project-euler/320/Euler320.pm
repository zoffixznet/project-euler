package Euler320;

use strict;
use warnings;

use integer;
use bytes;

use parent 'Exporter';

our @EXPORT_OK = qw(factorial_factor_exp find_exp_factorial);

# use Math::BigInt lib => 'GMP', ':constant';
use Math::GMP;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub factorial_factor_exp
{
    my ($n , $f) = @_;

    if ($n < $f)
    {
        return 0;
    }
    else
    {
        my $div = $n / $f;
        return $div + factorial_factor_exp($div, $f);
    }
}

# Finds the minimal n-factorial whose exponent is larger than $e
sub find_exp_factorial
{
    my ($f, $e, $bottom, $top) = @_;

    if ($bottom > $top)
    {
        return $top;
    }
    my $top_val = factorial_factor_exp($top, $f);

    if ($top_val < $e)
    {
        return find_exp_factorial($f, $e, $top, $top << 1);
    }
    my $bottom_val = factorial_factor_exp($bottom, $f);
    if ($bottom_val < $e and ($top == $bottom + 1))
    {
        return $top;
    }


    my $mid = (($bottom + $top) >> 1);
    my $mid_val = factorial_factor_exp($mid, $f);

    if ($mid_val < $e)
    {
        return find_exp_factorial($f, $e, $mid, $top);
    }
    return find_exp_factorial($f, $e, $bottom, $mid);
}
1;

