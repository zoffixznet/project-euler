use strict;
use warnings;

use Euler77;

my $n = 1;

MAIN:
while (1)
{
    my $ret = get_num_primes_combinations($n);
    print "$n : $ret\n";
    if ( $ret > 5_000 )
    {
        last MAIN;
    }
}
continue
{
    $n++;
}
