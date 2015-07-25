package Euler320;

use strict;
use warnings;

use integer;
use bytes;

use parent 'Exporter';

our @EXPORT_OK = qw(factorial_factor_exp);

# use Math::BigInt lib => 'GMP', ':constant';
use Math::GMP;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub factorial_factor_exp
{
    my ($n , $f) = @_;

    return 1;
}

1;

