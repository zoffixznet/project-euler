#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP';

STDOUT->autoflush(1);

my %squares = (map { $_ * $_ => undef() } 1 .. 999_999);
# my $sum = 0;

sub divisors
{
    my $lim = shift;
    if (!@_)
    {
        return [1];
    }
    my ($this, @rest) = @_;

    my ($b, $e) = @$this;
    my $d_rest = divisors($lim, @rest);

    my @ret;
    EXP_LOOP:
    for my $i (0 .. $e)
    {
        push @ret, @$d_rest;

        if (! @{$d_rest = [grep { $_ < $lim } map { $_ * $b } @$d_rest]})
        {
            last EXP_LOOP;
        }
    }
    return \@ret;
}

for my $d (2 .. 1e6)
{
    if ($d % 1_000 == 0)
    {
        print "D=$d\n";
    }
    # my $d3 = Math::BigInt->new($d) * $d * $d;
    my $d3 = $d * $d * $d;
    my %factors;
    for my $f (split/\s+/, `factor "$d"` =~ s/\A[^:]+:\s*//r)
    {
        $factors{$f} += 3;
    }
    
    foreach my $r
    (
        @{divisors(
                $d,
                map {[$_, $factors{$_}]} keys(%factors)
            )
        }
    )
    {
        my $n = (($r + $d3 / $r).'');

        if (exists($squares{$n}))
        {
            if ($n % $d == $r)
            {
                my @i = sort {$a <=> $b} (int($n/$d),$d,$r);
                if (Math::BigInt->new($i[1]) * Math::BigInt->new($i[1])
                    == Math::BigInt->new($i[0]) * Math::BigInt->new($i[2])
                )
                {
                    print "Found for d=$d r=$r q=@{[int($n/$d)]} n=$n\n";
                }
            }
        }
    }
}
# print "sum = $sum\n";
