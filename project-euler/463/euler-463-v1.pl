#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

my $LOWER = 100_000;

sub _cache
{
    my ($h, $key, $promise) = @_;

    my $ret = ($h->{$key} //= $promise->());

    my @to_del;
    while (my ($k, undef) = each %$h)
    {
        push @to_del, $k;
    }
    delete @$h{@to_del};
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

foreach my $n (1 .. 1_000_000)
{
    f_mod($n);
}
