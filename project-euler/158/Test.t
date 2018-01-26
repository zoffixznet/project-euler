#!/usr/bin/perl

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

use strict;
use warnings;

use Test::More tests => 4;

{
    # TEST
    is( scalar(`$^X euler-158-v1.pl 2`), <<'EOF', "For 2" );
Count[ 0] = 0
Count[ 1] = 0
Count[ 2] = 1
EOF
}

{
    # TEST
    is( scalar(`$^X euler-158-v1.pl 3`), <<"EOF", "For 3" );
Count[ 0] = 0
Count[ 1] = 0
Count[ 2] = @{[2+1]}
Count[ 3] = @{[6-1-1]}
EOF
}

{
    # TEST
    # Output taken from brute-force-count.pl .
    is( scalar(`$^X euler-158-v1.pl 4`), <<"EOF", "For 4" );
Count[ 0] = 0
Count[ 1] = 0
Count[ 2] = 6
Count[ 3] = 16
Count[ 4] = 11
EOF
}

{
    # TEST
    # Output taken from brute-force-count.pl .
    is( scalar(`$^X euler-158-v1.pl 5`), <<"EOF", "For 5" );
Count[ 0] = 0
Count[ 1] = 0
Count[ 2] = 10
Count[ 3] = 40
Count[ 4] = 55
Count[ 5] = 26
EOF
}
