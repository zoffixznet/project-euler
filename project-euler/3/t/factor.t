#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1000;

sub _check
{
    my ($n) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return is(
        scalar `./mini_factor-prod.exe "$n"`,
        scalar `factor "$n"`,
        "Checking $n"
    );
}

{
    # TEST*1000
    foreach my $n ( 1 .. 1000 )
    {
        _check($n);
    }
}

