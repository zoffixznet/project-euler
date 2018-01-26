#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

summarize()
{
    perl -lan -Mbigint -E '$s += $_; END{ say $s; }'
}

basic_gen()
{
    /home/shlomif/Download/unpack/prog/python/pypy2-v5.3.0-src/pypy/goal/pypy-c euler_565_v1.py
}

gen()
{
     basic_gen | sort -n -u
}

verify()
{
    perl -lan -MList::Util=sum -E 'my $n = $_; my %f; foreach my $f (`factor "$n"` =~ s/\A[^:]*://r =~ /([0-9]+)/g) { $f{$f}++ } ; my $p = 1; while (my ($k, $e) = each %f) { my $s = 0 ; my $ee = 1; $s += $ee; for my $x (1 .. $e) { $s += ($ee *= $k); } $p *= $s; } ; say $n if $p % 2017'
}

dump()
{
    tee dump.txt
}

Split_()
{
    perl -E 'use strict; use warnings; my @d; foreach my $d (1..9) { open my $fh, ">", "split/$d"; $d[$d] = $fh; } ; open my $in, "<", "dump.txt"; while(<$in>){print { $d[substr($_,0,1)] } $_; }; close($in); foreach my $d (1..9) { close $d[$d]; }'
}
# gen | summarize
# gen | verify
# basic_gen | dump
