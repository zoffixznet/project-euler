#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

# Prime strings.
my @p_s = `primes 2 190`;
chomp(@p_s);

# The primes.
my @p = (map { Math::GMP->new($_) } @p_s);

my $n = Math::GMP->new(1);
$n *= $_ foreach @p;

my $sq = $n->bsqrt;

my $max = 1;

my @s = (0);

# Count limit
my $L = 1;

sub rec
{
    # Depth and product (multiplication)
    my ($d, $m) = @_;

    if ($m > $sq)
    {
        print "[G]Found $max [ " . join('*', @p_s[@s[0 .. $d]]) . " ]\n";
        return 0;
    }

    if ($m > $max)
    {
        $max = $m;
        print "Found $max [ " . join('*', @p_s[@s[0 .. $d]]) . " ]\n";
    }

    my $D = $d+1;

    if ($D == $L)
    {
        return 1;
    }

    my $x = 0;
    for my $n ($s[$d]+1 .. $#p)
    {
        $s[$D] = $n;
        if (! rec($D, $m * $p[$n]))
        {
            return $x;
        }
    }
    continue
    {
        $x++;
    }

    return $x;
}

for my $limit (reverse (1 .. @p))
{
    $L = $limit;
    for my $initial (0 .. $#p)
    {
        $s[0] = $initial;
        rec(0, $p[$initial]);
    }
}

print "Max = $max\n";
