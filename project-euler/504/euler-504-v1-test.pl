#!/usr/bin/perl

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

use strict;
use warnings;

use lib '.';
use Euler504;

Euler504::set_M(4);

print "Answer = ", Euler504::calc_all_quadris(), "\n";
