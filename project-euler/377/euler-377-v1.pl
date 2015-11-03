#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

use Euler377;

if (1)
{
printf "Result = %09d\n", Euler377->new->calc_result;

}

if (1)
{
my $ret = 0;
my $base = 13;
my $power = $base;
for my $exp (1 .. 17)
{
    my $obj = Euler377->new({BASE => $power, N_s => [$power]});

    $ret += $obj->calc_result();

    $ret %= 1_000_000_000;
}
continue
{
    $power *= $base;
}

printf "ResultLoop = %09d\n", $ret;
}
