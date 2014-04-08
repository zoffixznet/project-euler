#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);

require Euler161;

print Dumper([Euler161::get_shapes()]), "\n";
