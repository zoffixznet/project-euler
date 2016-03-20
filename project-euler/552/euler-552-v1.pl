#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::GMP;

use Math::BigInt lib => 'GMP'; #, ':constant';

use List::Util qw(reduce sum);
use List::MoreUtils qw(all);

use Math::ModInt qw(mod);
use Math::ModInt::ChineseRemainder qw(cr_combine cr_extract);

my $MAX = 300000;
my @primes = `primes 2 $MAX`;
chomp(@primes);

# @r = records.
my @r = (map { +{ n => $_ } } @primes);
STDOUT->autoflush(1);

my $sum = 0;
my $accum_mod;
for my $idx (keys @r)
{
    my $rec = $r[$idx];
    my $n = $rec->{n};

    print "Reached i=$idx n=$n\n";
    my $big_n = Math::BigInt->new($n);
    my $this_mod = mod($idx+1, $big_n);
    $accum_mod = $idx ? cr_combine($accum_mod, $this_mod) : $this_mod;
    $rec->{A} = $accum_mod->residue;

    my $verdict = sub {
        for my $p (0 .. $idx-1)
        {
            if ($r[$p]->{A} % $big_n == 0)
            {
                return 1;
            }
        }
        return 0;
    }->();

    if ($verdict)
    {
        $sum += $n;
        print "Found n=$n sum=$sum\n";
    }
}

print "Final sum = $sum\n";

