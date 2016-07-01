#!/usr/bin/perl

use strict;
use warnings;

my %cache;

sub _cache
{
    my ($key, $promise) = @_;
    my $ret = ($cache{$key} //= $promise->());
    %cache = ();
    return $ret;
}

sub f_mod
{
    my ($n) = @_;

    return _cache($n, sub {
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
