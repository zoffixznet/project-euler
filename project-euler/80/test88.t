#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use List::Util qw(sum);

use Euler80;

{
    my $result = Euler80::square_root(2);
    my $first_100 = substr("$result", 0, 100);
    my $sum = sum(split//, $first_100);

    # TEST
    is ($sum, 475, "Sum of square root 2 is 475");
}
