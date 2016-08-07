#!/bin/bash

summarize()
{
    perl -lanE '$s += $_; END{ say $s; }'
}

gen()
{
    /home/shlomif/Download/unpack/prog/python/pypy2-v5.3.0-src/pypy/goal/pypy-c euler_565_v1.py | sort -n -u
}

verify()
{
    perl -lan -MList::Util=sum -E 'my $n = $_; my %f; foreach my $f (`factor "$n"` =~ s/\A[^:]*://r =~ /([0-9]+)/g) { $f{$f}++ } ; my $p = 1; while (my ($k, $e) = each %f) { my $s = 0 ; my $ee = 1; $s += $ee; for my $x (1 .. $e) { $s += ($ee *= $k); } $p *= $s; } ; say $n if $p % 2017'
}

gen | summarize
# gen | verify

