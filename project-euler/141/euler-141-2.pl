#!/usr/bin/perl

use strict;
use warnings;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw(any);

STDOUT->autoflush(1);

my %found;
my $sum = 0;

sub divisors
{
    if (!@_)
    {
        return [1];
    }
    my ($this, @rest) = @_;

    my ($b, $e) = @$this;
    my $d_rest = divisors(@rest);

    my @ret;
    for my $i (0 .. $e)
    {
        push @ret, @$d_rest;

        for my $d (@$d_rest)
        {
            $d *= $b;
        };
    }
    return \@ret;
}

for my $d (2 .. 1e6)
{
    if ($d % 1_000 == 0)
    {
        print "D=$d\n";
    }
    my $d3 = $d * $d * $d;
    my %factors;
    for my $f (split/\s+/, `factor "$d"` =~ s/\A[^:]+:\s*//r)
    {
        $factors{$f} += 3;
    }
    my @divisors = sort {$a <=> $b } @{divisors(
        map {[$_, $factors{$_}]} keys(%factors)
    )};

    R:
    foreach my $r (@divisors)
    {
        if ($r >= $d)
        {
            last R;
        }

        my $n = $r + $d3 / $r;

        if ($n < 1e12)
        {
            my $sq = int(sqrt($n));

            if (any { $_ * $_ == $n } ($sq-1 .. $sq+1))
            {
                if (!exists($found{$n}))
                {
                    $found{$n} = 1;
                    $sum += $n;
                    print "Found for d=$d n=$n sum = $sum\n";
                }
            }
        }
    }
}
print "sum = $sum\n";
