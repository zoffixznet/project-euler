#!/usr/bin/perl

use strict;
use warnings;

use Euler377;

foreach my $n (1 .. 2)
{
    Euler377::recurse_digits(
        $n,
    );
}
