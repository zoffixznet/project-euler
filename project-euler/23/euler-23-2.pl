use strict;
use warnings;

use 5.016;

use List::Util qw(sum);
use List::MoreUtils qw(any);

my @divisors_sums;
$divisors_sums[1] = 0;

my $MAX = 28_123;
foreach my $div ( 1 .. ( $MAX >> 1 ) )
{
    my $prod = ( $div << 1 );
    while ( $prod <= $MAX )
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
my $is_abundant = '';

foreach my $num ( 1 .. $MAX )
{
    vec( $is_abundant, $num, 1 ) = ( $divisors_sums[$num] > $num );
}

sub is_abundant_sum
{
    my ($num) = @_;
    return
        any { vec( $is_abundant, $_, 1 ) && vec( $is_abundant, $num - $_, 1 ) }
    ( 1 .. ( $num >> 1 ) );
}

say "Sum == ", sum( grep { !is_abundant_sum($_) } ( 1 .. $MAX ) );
