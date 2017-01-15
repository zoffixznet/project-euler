#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Path::Tiny qw/ path /;

my @dirs = (sort { $a <=> $b } grep { /\A[0-9]+\z/ } path(".")->children());

plan tests => scalar(@dirs);

foreach my $d (@dirs)
{
    my $fn = "$d/euler-$d-description.txt";
    ok( ((-f $fn) && (-s "$fn" > 0)),
        "File $fn exists and is not empty."
    );
}

