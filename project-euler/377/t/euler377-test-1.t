#!/usr/bin/perl

use strict;
use warnings;

use Euler377;

foreach my $new_digit (1 .. 2)
{
    Euler377::recurse_digits(
        $new_digit,
    );
}
