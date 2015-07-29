package Euler288;

use strict;
use warnings;

use integer;
use bytes;

use parent 'Exporter';

our @EXPORT_OK = qw(factorial_factor_exp find_exp_factorial sum_factorials);

use Math::BigInt lib => 'GMP';

use Tree::AVL;
use IO::All qw/io/;

use List::Util qw(sum);
use List::MoreUtils qw();

no warnings 'recursion';

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

1;

