#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use 5.016;

use integer;
use bytes;

=head1 DESCRIPTION

Let f(n) be the largest positive integer x less than 109 such that the last 9 digits of nx form the number x (including leading zeros), or zero if no such integer exists.

For example:

    f(4) = 411728896 (4411728896 = ...490411728896)
    f(10) = 0
    f(157) = 743757 (157743757 = ...567000743757)
    Σf(n), 2 ≤ n ≤ 103 = 442530011399

Find Σf(n), 2 ≤ n ≤ 106.

=cut

my $MOD = 1_000_000_000;

sub exp_mod
{
    my ($b, $e) = @_;

    if ($e == 0)
    {
        return 1;
    }

    my $rec_p = exp_mod($b, ($e >> 1));

    my $ret = $rec_p * $rec_p;

    if ($e & 0x1)
    {
        $ret *= $b;
    }

    return ($ret % $MOD);
}

sub calc_f
{
    my ($n) = @_;

    if ($n % 10 == 0)
    {
        return 0;
    }

    my %cache;

    my $e = 0;
    my $power = 1;

    while (! exists($cache{$power}))
    {
        $cache{$power} = $e;
    }
    continue
    {
        $e++;
        ($power *= $n) %= $MOD;
    }

    my $cycle_len = $e-$cache{$power};

    # Inspect the largest ones first.
    for my $x (sort { $b <=> $a } keys%cache)
    {
        if (( ($x - $cache{$x}) % $cycle_len) == 0)
        {
            return $x;
        }
    }

    return 0;
}

my $MAX = 1_000_000;
my $sum = 0;

my ($START, $END) = @ARGV;

foreach my $n ($START .. $END)
{
    $sum += calc_f($n);
}

say "Sum == $sum";
