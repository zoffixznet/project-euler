#!/usr/bin/perl

use strict;
use warnings;

my $s = "";

vec( $s, 0, 2 ) = 3;
vec( $s, 0, 2 )++;

print "Foo = ", vec( $s, 0, 2 ), "\n";
