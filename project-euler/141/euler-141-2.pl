#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP';

STDOUT->autoflush(1);

my %squares = (map { $_ * $_ => undef() } 1 .. 999_999);
# my $sum = 0;

my $d;
my $d3;

sub divisors
{
    my ($r, $factors, $this_) = @_;
    if ($this_ == @$factors)
    {
        my $n = ($r + $d3 / $r);

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
    else
    {
        my ($b, $e) = @{ $factors->[$this_] };
        my $rest = $this_ + 1;

        I:
        for my $i (0 .. $e)
        {
            if ($r >= $d)
            {
                last I;
            }
            divisors($r, $factors, $rest);
            $r *= $b;
        }
    }
    return;
}

open my $fh, '<', 'factors.txt';
for my $i (2 .. 999_999)
{
    $d = $i;
    if ($d % 1_000 == 0)
    {
        print "D=$d\n";
    }
    # my $d3 = Math::BigInt->new($d) * $d * $d;
    $d3 = $d * $d * $d;
    my %factors;
    my @x = split/\s+/,<$fh>;
    pop(@x);
    for my $f (@x)
    {
        $factors{$f} += 3;
    }
    divisors(1, [map { [$_,$factors{$_}]} keys(%factors)], 0);
}

close($fh);
# print "sum = $sum\n";
