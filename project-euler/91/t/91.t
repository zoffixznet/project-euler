#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Euler91;

# TEST
is (get_num_O_right_angle_triangles(2,2), 4, "2*2 O triangles");
