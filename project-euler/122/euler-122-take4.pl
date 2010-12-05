#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::MoreUtils qw(uniq);
use List::Util qw(min);
use List::UtilsBy qw(min_by);
use IO::Handle;

STDOUT->autoflush(1);

my $comb1 = '';
vec($comb1, 1, 1) = 1;

my @compositions = (undef, [$comb1],);

my $limit = 200;

my $power_of_2 = 2;

while ($power_of_2 < $limit)
{
    my $v = $compositions[$power_of_2/2][0];

    vec($v, $power_of_2, 1) = 1;
    push @{$compositions[$power_of_2]}, $v;

    my $less_sig = $power_of_2;
    $less_sig /= 2;

    while ($less_sig >= 1)
    {
        my $v2 = $v;
        vec($v2, $power_of_2+$less_sig, 1) = 1;
        push @{$compositions[$power_of_2+$less_sig]}, $v2;
    }
    continue
    {
        $less_sig /= 2;
    }
}
continue
{
    $power_of_2 *= 2;
}

my $sum = 0;

N_LOOP:
foreach my $n (1 .. 200)
{
    if (!defined($compositions[$n]))
    {
        print "${n}: Unavailable\n";
        next N_LOOP;
    }
    my $optimal_comb = min_by { unpack("b*", $_) =~ tr/1/1/ } @{$compositions[$n]};

    my $comb = unpack("b*", $optimal_comb);
    my $result = -1 + $comb =~ tr/1/1/;
    print "${n}: $result ($comb)\n";

    $sum += $result;
}

print "Sum = $sum\n";
