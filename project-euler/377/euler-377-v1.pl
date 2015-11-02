#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

use Euler377;

print calc_count(5);

print_rows(calc_count_matrix(5)->{normal});
print_rows(calc_count_matrix(5)->{transpose});

Euler377::calc_result();
printf "Result = %09d\n", $Euler377::result;
