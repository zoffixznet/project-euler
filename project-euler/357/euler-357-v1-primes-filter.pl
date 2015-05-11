#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use integer;
use bytes;

use List::MoreUtils qw/all/;

my $v = '';
open my $p_fh, '<', 'primes.txt';
while (my $p = <$p_fh>)
{
    chomp($p);
    vec($v, $p, 1) = 1;
}
close($p_fh);

# We've skipped those.
my $sum = 1+2;

open my $fh, '<', 'exprs.txt';
while (my $l = <$fh>)
{
    chomp($l);
    my ($n, @d) = split/ /,$l;
    if (all { vec($v, $_, 1) } @d)
    {
        # print "Adding $n\n";
        $sum += $n;
    }
    else
    {
        # print "Skipping $n\n";
    }
}
close ($fh);
print "Sum = $sum\n";
