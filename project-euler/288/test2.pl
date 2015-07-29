use strict;
use warnings;

use Euler288 qw(factorial_factor_exp);
use Math::BigInt lib => "GMP", ":constant";

sub f
{
    return factorial_factor_exp(shift(), 61) % 61 ** 10;
}

for my $x (1 .. 30)
{
    my $xe = 61 ** $x;
    for my $y (1 .. 30)
    {
        for my $f (1 .. 60)
        {
            my $ye = $f * 61 ** $y;
            print "$x $y $f ", f($xe+$ye), " ", ((f($xe)+f($ye))% (61 ** 10)), "\n";
        }
    }
}
