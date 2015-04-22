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

# Cache.
my %C = (1 => 1);

sub chain_len
{
    my ($n, $is_p) = @_;

    return ($C{$n} //= (1 + chain_len(scalar($is_p ? ($n-1) : totient($n)), 0)));
}

sub totient
{
    my ($n) = @_;

    my @factors = ((`factor "$n"` =~ s/\A[^:]+://r) =~ /([0-9]+)/g);

    if (@factors == 1)
    {
        return $n-1;
    }

    my %f = (map { $_ => 1 } @factors);

    my @p = (map { [$_, $_] } sort { $a <=> $b } keys%f);

    my $count = 1;

    I:
    for my $i (2 .. $n-1)
    {
        for my $p (@p)
        {
            while ($p->[0] < $i)
            {
                $p->[0] += $p->[1];
            }
            if ($p->[0] == $i)
            {
                next I;
            }
        }
        $count++;
    }

    return $count;
}

my $MAX = 40_000_000;
my $LEN = 25;
open my $fh, "primes 2 $MAX|";
while (my $p = <$fh>)
{
    chomp($p);
    printf "%d L=%d\n", $p, chain_len($p, 1);
}
close($fh);
