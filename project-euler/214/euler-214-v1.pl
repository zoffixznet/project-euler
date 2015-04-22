#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $counts = "";
# Cache.
my %C = (1 => 1);

sub chain_len
{
    my ($n) = @_;

    return ($C{$n} //= (1 + chain_len(vec($counts, $n, 32))));
}

my $MAX = 40_000_000;

foreach my $i (2 .. $MAX-1)
{
    vec($counts, $i, 32) = $i-1;
}
print "Initialized Array\n";

my $min_n;
my $min_expr = 1_000_000;

my $l = ($MAX >> 1);
foreach my $d (2 .. $l)
{
    print "d=$d\n" if ($d % 1_000 == 0);
    my $totient = vec($counts, $d, 32);

    my $m = $d<<1;
    while ($m < $MAX)
    {
        vec($counts, $m, 32) -= $totient;
    }
    continue
    {
        $m += $d;
    }
}

my $LEN = 25;
open my $fh, "primes 2 $MAX|";
while (my $p = <$fh>)
{
    chomp($p);
    printf "%d L=%d\n", $p, chain_len($p, 1);
}
close($fh);
