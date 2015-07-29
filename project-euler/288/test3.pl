use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

use Euler288 qw(factorial_factor_exp);
use Math::BigInt lib => "GMP";

my @t_n;

my $N_LIM = 20;
my $BASE = 3;
my $LIM = 10_000;

my $S_0 = 290797;
my $s = $S_0;

for my $n (0 .. $N_LIM-1)
{
    push @t_n, ($s % $BASE);
    $s = (($s * $s) % 50515093);
}

my $sum = 0;
for my $n ($N_LIM .. $LIM)
{
    $sum += ($s % $BASE);
    $s = (($s * $s) % 50515093);
}

sub f
{
    return factorial_factor_exp(shift(), Math::BigInt->new($BASE)) % (Math::BigInt->new($BASE) ** $N_LIM);
}

print sum(
    (map { f(Math::BigInt->new($BASE) ** $_) * $t_n[$_] } 1 .. $#t_n),
    $sum * f(Math::BigInt->new($BASE) ** $N_LIM)
) % (Math::BigInt->new($BASE) ** $N_LIM);
print "\n";
exit(0);
