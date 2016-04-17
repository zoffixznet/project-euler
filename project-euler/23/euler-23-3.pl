use strict;
use warnings;

use 5.016;

use List::Util qw(sum);
use List::MoreUtils qw(any);

my @divisors_sums;
$divisors_sums[1] = 0;

my $MAX = 28_123;
foreach my $div (1 .. ($MAX >> 1))
{
    my $prod = ($div<<1);
    while ($prod <= $MAX)
    {
        $divisors_sums[$prod] += $div;
    }
    continue
    {
        $prod += $div;
    }
}

# Memoized.
#
my $is_abundant_sum = '';

my @abundants;
foreach my $num (1 .. $MAX)
{
    if ($divisors_sums[$num] > $num)
    {
        push @abundants, $num;
        foreach my $i (@abundants)
        {
            vec($is_abundant_sum, $i+$num, 1) = 1;
        }
    }
}

say "Sum == ", sum(grep { ! vec($is_abundant_sum, $_, 1) } (1 .. $MAX));
