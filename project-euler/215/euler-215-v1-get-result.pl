#!/usr/bin/perl

use strict;
use warnings;

use Euler215;

my ($len, $num_layers) = (32, 10);

printf "Result[%d*%d] == %d\n", $len, $num_layers,
    Euler215::solve($len, $num_layers);
