use strict;
use warnings;

use 5.016;

use List::Util qw(sum);
use List::MoreUtils qw(any);

sub sum_divisors
{
    my ($num ) = @_;

    return sum(grep { $num % $_ == 0 } (1 .. ($num >> 1))) // 0;
}

# Memoized.
#
my $MAX = 28_123;
my $is_abundant = '';

foreach my $num (1 .. $MAX)
{
    vec($is_abundant, $num, 1) = (sum_divisors($num) > $num);
}

sub is_abundant_sum
{
    my ($num) = @_;
    return any { vec($is_abundant, $_, 1) && vec($is_abundant, $num-$_, 1)} (1 .. ($num >> 1));
}

say "Sum == ", sum(grep { ! is_abundant_sum($_) } (1 .. $MAX));
