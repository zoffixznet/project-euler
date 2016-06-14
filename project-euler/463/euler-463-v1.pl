#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

no warnings 'recursion';

my $MOD = 1_000_000_000;

my $UPPER = 200_000;
my $LOWER = 100_000;

sub _cache
{
    my ($h, $key, $promise) = @_;

    my $ret = ($h->{$key} //= $promise->());

    if (scalar keys %$h >= $UPPER)
    {
        my @to_del;

        my $NUM = +(scalar keys %$h) - $LOWER;
        K:
        while (my ($k, undef) = each %$h)
        {
            push @to_del, $k;
            if (@to_del == $NUM)
            {
                last K;
            }
        }
        delete @$h{@to_del};
    }
    return $ret;
}

my %cache;

sub f_mod
{
    my ($n) = @_;

    return _cache(\%cache, $n, sub {
        if ($n == 1)
        {
            return 1;
        }
        elsif ($n == 3)
        {
            return 3;
        }
        elsif (($n & 1) == 0)
        {
            return f_mod($n >> 1);
        }
        elsif (($n & 3) == 1)
        {
            return (2 * f_mod(($n >> 1) + 1) - f_mod($n >> 2)) % $MOD;
        }
        else
        {
            return (3 * f_mod(($n >> 1)) - 2 * f_mod($n >> 2)) % $MOD;
        }
    });
}

sub s_bruteforce
{
    my ($n) = @_;

    my $s = 0;

    foreach my $i (1 .. $n)
    {
        ($s += f_mod($i)) %= $MOD;
    }

    return $s;
}

{
    my %s_cache;

    sub s_smart
    {
        my ($start, $end) = @_;

        return _cache(\%s_cache, "$start|$end", sub {
                if ($start > $end)
                {
                    return 0;
                }
                if ($end <= 8)
                {
                    return s_bruteforce($end) - s_bruteforce($start - 1);
                }
                if (($start & 0b11) != 0)
                {
                    return ((f_mod($start) + s_smart($start+1, $end)) % $MOD);
                }
                if (($end & 0b11) != 11)
                {
                    return ((f_mod($end) + s_smart($start, $end-1)) % $MOD);
                }
                my $half_start = ($start >> 1);
                my $half_end = (($end - 1) >> 1);
                return ((6 * f_mod($half_end) + (s_smart($half_start+1, $half_end-1) << 2) - (f_mod($half_start) << 1)) % $MOD);
            }
        );
    }
}

if (0)
{
    my $want = 0;
    foreach my $n (1 .. 1_000_000)
    {
        ($want += f_mod($n)) %= $MOD;
        my $have = s_smart(1, $n);
        if ($want != $have)
        {
            die "want=$want have=$have n=$n!";
        }
    }
}

{
    say "S(3 ** 37) = ", s_smart(1, (eval join'*',(3) x 37));
}
