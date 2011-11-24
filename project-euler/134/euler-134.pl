#!/usr/bin/perl

use strict;
use warnings;

use integer;

=head1 DESCRIPTION

Consider the consecutive primes p1 = 19 and p2 = 23. It can be verified that
1219 is the smallest number such that the last digits are formed by p1 whilst
also being divisible by p2.

In fact, with the exception of p1 = 3 and p2 = 5, for every pair of consecutive
primes, p2 > p1, there exist values of n for which the last digits are formed
by p1 and n is divisible by p2. Let S be the smallest of these values of n.

Find ∑ S for every pair of consecutive primes with 5 ≤ p1 ≤ 1000000.

=cut

# Extended gcd.
sub xgcd
{
    my ($aa, $bb) = @_;
    if ($bb == 0)
    {
        return (1,0);
    }
    else
    {
        my $q = $aa / $bb;
        my $r = $aa % $bb;
        my ($s, $t) = xgcd($bb, $r);
        return ($t, $s- $q*$t);
    }
}

open my $primes_fh, "(primes 5 1100000)|";

my $p1 = int(<$primes_fh>);
my $p2;
my $sum = 0;
my $count = 0;
PRIMES_LOOP:
while ($p2 = int(<$primes_fh>))
{
    if ($p1 > 1_000_000)
    {
        last PRIMES_LOOP;
    }

    my $mod = $p2-$p1;
    my $mod_delta = ((1 . ('0' x length($p1))) % $p2);

    # See:
    # http://en.wikipedia.org/wiki/Linear_congruence_theorem
    # $mod_delta * $x = $p2-$p1 (mod $p2)
    my ($r, $s) = xgcd($mod_delta, $p2);
    my $x = $r * $mod / ($r*$mod_delta + $s * $p2);
    if ($x <= 0)
    {
        $x += ((-$x)/$p2+1)*$p2;
    }
    else
    {
        $x %= $p2;
    }
    my $S = ($x . $p1);
    $sum += $S;

    # if ((++$count) % 100 == 0)
    {
        print "For (p1=$p1,p2=$p2) found $S (sum=$sum)\n";
    }
}
continue
{
    $p1 = $p2;
}

close($primes_fh);

print "Sum = $sum\n";
