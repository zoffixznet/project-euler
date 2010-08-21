#!/usr/bin/perl

use strict;
use warnings;

use integer;
use IO::Handle;

use Data::Dumper;

use List::Util qw(reduce sum);
STDOUT->autoflush(1);

my @Cache = (undef, []);

sub factorize_helper
{
    my ($n, $start_from) = @_;

    my $limit = int(sqrt($n));

    if (! defined($Cache[$n]))
    {
        my $d = $n;
        while ($d % $start_from)
        {
            if (++$start_from > $limit)
            {
                return $Cache[$n] = [[$n,1]];
            }
        }

        $d /= $start_from;

        my @n_factors = (map { [@$_] } @{factorize_helper($d, $start_from)});

        if (@n_factors && $n_factors[0][0] == $start_from)
        {
            $n_factors[0][1]++;
        }
        else
        {
            unshift @n_factors, ([$start_from, 1]);
        }

        $Cache[$n] = \@n_factors;
    }
    return $Cache[$n];
}

sub factorize
{
    my ($n) = @_;
    return factorize_helper($n, 2);
}

use vars qw($a $b);
sub next_amicable
{
    my $n = shift;

    my $factors = factorize($n);

    return (reduce { $a * $b }
        map { my ($base, $e) = @$_; sum(map { $base ** $_ } (0 .. $e)) }
        @$factors) - $n;
}

print "next_amicable(28) = ", next_amicable(28), "\n";
print "next_amicable(220) = ", next_amicable(220), "\n";
print "next_amicable(284) = ", next_amicable(284), "\n";

my $found_n;
my $found_chain_len = 0;
N_LOOP:
for my $n (2 .. 1_000_000)
{
    my $chain_len = 1;
    my $m = $n;

    while (($m = next_amicable($n)) != 1)
    {
        $chain_len++;
        if ($m > 1_000_000)
        {
            next N_LOOP;
        }
        if ($m == $n)
        {
            if ($chain_len > $found_chain_len)
            {
                $found_chain_len = $chain_len;
                $found_n = $n;
                print "Found [$found_n] with Chain len $found_chain_len\n";
            }
            next N_LOOP;
        }
    }
}

