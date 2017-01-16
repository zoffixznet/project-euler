#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Euler150;

# TEST
is( Euler150::S::get(), 273_519, 's_1' );

# TEST
is( Euler150::S::get(), (-153_582), 's_2' );

# TEST
is( Euler150::S::get(), (450_905), 's_3' );
