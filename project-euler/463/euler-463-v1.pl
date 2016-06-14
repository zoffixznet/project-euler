#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

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
        if ($n <= 3)
        {
            return 1;
        }
        else
        {
            return f_mod($n >> 1);
        }
    });
}

if (1)
{
    my $want = 0;
    foreach my $n (1 .. 1_000_000)
    {
        ($want += f_mod($n)) %= $MOD;
    }
}
