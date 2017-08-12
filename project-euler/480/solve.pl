#!/usr/bin/perl

use strict;
use warnings;

use lib '.';
use Euler480;

sub W
{
    return Euler480::calc_W(@_);
}

sub P
{
    return Euler480::calc_P(@_);
}

print "Result = <<",
    W( P('legionary') +
        P('calorimeters') -
        P('annihilate') +
        P('orchestrated') -
        P('fluttering') ), ">>\n";
