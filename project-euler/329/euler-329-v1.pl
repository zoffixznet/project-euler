#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat (try => 'GMP');

use bytes;

use List::Util qw(sum);
use List::MoreUtils qw(none);

STDOUT->autoflush(1);

my @is_prime = (0, 0, map { my $p = $_; (none { $_ % $p == 0 } 2 .. $p-1) ? 1 : 0 } 2 .. 500);

my @init_probab = (0, (map { Math::BigRat->new('1/500') } 1 .. 500) , 0);

my @up_step_probab = (0, 1, (map { Math::BigRat->new('1/2') } 2 .. 499) , 0 , 0);
my @down_step_probab = (0, 0, (map { Math::BigRat->new('1/2') } 2 .. 499) , 1, 0 );
my $s = 'PPPPNNPPPNPPNPN';

my @probab = @init_probab;
my $T_frac = Math::BigRat->new('2/3');
my $F_frac = Math::BigRat->new('1/3');

for my $k (split//, $s)
{
    my @next_probab = (0, (map { my $i = $_;
            ($up_step_probab[$i-1] * $probab[$i-1]
            + $down_step_probab[$i+1] * $probab[$i+1])
            * ((!($k eq 'P' xor $is_prime[$i])) ? $T_frac : $F_frac)
        } 1 .. 500), 0);

    @probab = @next_probab;
}

my $sum = Math::BigRat->new('0,1');

foreach my $x (@probab)
{
    $sum += $x;
}

print $sum;

