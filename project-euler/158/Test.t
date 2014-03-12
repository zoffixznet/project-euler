#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

{
    # TEST
    is (scalar(`$^X euler-158-v1.pl 2`), <<'EOF', "For 2");
Count[ 0] = 0
Count[ 1] = 0
Count[ 2] = 1
EOF
}

{
    # TEST
    is (scalar(`$^X euler-158-v1.pl 3`), <<"EOF", "For 3");
Count[ 0] = 0
Count[ 1] = 0
Count[ 2] = @{[2+1]}
Count[ 3] = @{[6-1-1]}
EOF
}
