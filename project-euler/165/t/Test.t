#!/usr/bin/perl

use strict;
use warnings;

use Euler165::R;

use Test::More tests => 1;

use Test::Differences qw(eq_or_diff);

{
    my $obj = Euler165::R->new;

    # TEST
    eq_or_diff(
        $obj->get_seg,
        [27, 144, 12, 232],
        "First segment",
    );
}

