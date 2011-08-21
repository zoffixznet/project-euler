package Euler150::S;

use strict;
use warnings;

use integer;

my $t = 0;

sub get
{
    $t = ((615949 * $t + 797807) & ((1 << 20)-1));
    return ($t - (1 << 19));
}

1;
