#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt try => "GMP";

my $size = shift(@ARGV);

my $counts = "";

foreach my $i (2 .. $size-1)
{
    vec($counts, $i, 32) = $i-1;
}
print "Initialized Array\n";

my $min_n;
my $min_expr = 1_000_000;

sub token
{
    return join("", sort { $a cmp $b } split//, shift());
}

my $l = int($size/2);
foreach my $d (2 .. $l)
{
    print "d=$d\n" if ($d % 1_000 == 0);
    my $totient = vec($counts, $d, 32);
    foreach my $m (2 .. int($size/$d))
    {
        vec($counts, $d*$m, 32) -= $totient;
    }

    if (token($totient) eq token($d))
    {
        my $to_check = $d/$totient;
        if ($to_check < $min_expr)
        {
            $min_n = $d;
            $min_expr = $to_check;
            print "Min[n] = $min_n ; Min[expr] = $min_expr\n";
        }
    }
}

foreach my $d ($l+1 .. $size)
{
    print "d=$d\n" if ($d % 1_000 == 0);
    my $totient = vec($counts, $d, 32);

    if (token($totient) eq token($d))
    {
        my $to_check = $d/$totient;
        if ($to_check < $min_expr)
        {
            $min_n = $d;
            $min_expr = $to_check;
            print "Min[n] = $min_n ; Min[expr] = $min_expr\n";
        }
    }
}

print "Min[n] = $min_n ; Min[expr] = $min_expr\n";
