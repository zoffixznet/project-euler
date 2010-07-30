use strict;
use warnings;

use Test::More tests => 5;

use Euler77;

# TEST
is (get_num_primes_combinations(2), 1,
    "2 == { [2] }"
);

# TEST
is (get_num_primes_combinations(3), 1,
    "3 == { [3] }"
);

# TEST
is (get_num_primes_combinations(4), 1,
    "4 == { [2,2] }",
);

# TEST
is (get_num_primes_combinations(5), 2,
    "4 == { [2,3], [5] }",
);

# TEST
is (get_num_primes_combinations(10), 5,
    "10 == {[7,3], [5, 5], [5, 3, 2], [3, 3, 2, 2], [2, 2, 2, 2, 2]}",
);

