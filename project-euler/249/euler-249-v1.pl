#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';
use Math::GMP;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %sums;

open my $p_fh, 'primes 2 5000|' or die "Foo - $!";
my $sum = 0;
while (my $p = <$p_fh>)
{
    chomp($p);
    print "Reached p = $p\n";
    $sum += $p;
    foreach my $k (reverse sort { $a <=> $b } keys%sums)
    {
        ($sums{$k+$p} //= Math::GMP->new(0)) += $sums{$k};
    }
    ($sums{$p} //= Math::GMP->new(0))++;
}
close($p_fh);

my $total = Math::GMP->new(0);
open my $sum_fh, "primes 2 $sum |" or die "Bar - $!";

while (my $s = <$sum_fh>)
{
    chomp($s);
    if (exists($sums{$s}))
    {
        $total += $sums{$s};
    }
}
close($sum_fh);

print "Ret = $total ; LastDigits = " , substr("$total", -16), "\n";
