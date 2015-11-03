#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

use Euler377;

printf "Result = %09d\n", Euler377->new->calc_result;

my $ret = 0;
for my $exp (1 .. 17)
{
    my $BASE = 13 ** $exp;
    my $obj = Euler377->new({BASE => $BASE, N_s => [$BASE]});

    $ret += $obj->calc_result();

    $ret %= 1_000_000_000;
}

printf "ResultLoop = %09d\n", $ret;
