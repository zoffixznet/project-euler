use strict;
use warnings;

use Test::More tests => 2;

use Euler77;

# TEST
is (get_num_primes_combinations(2), 1,
    "2 == { [2] }"
);

# TEST
is (get_num_primes_combinations(3), 1,
    "3 == { [3] }"
);
