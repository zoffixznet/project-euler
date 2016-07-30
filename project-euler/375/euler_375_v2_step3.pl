#!/usr/bin/perl

use strict;
use warnings;

use bigint;

my $MIN_ELEM = 3;
my $delta = 6308949 - 1;
my $s = $delta + 1;
my $m_s = 4336411086199724;
my $m_s2 = 9043999811195255;

my $m_delta = $m_s2 - $m_s;
my $s2 = $s + $delta;

my $n = $s2;
my $m = $m_s2 + 0;

my $s_t = 63484;
my $s_t_min_1 = $s_t - 1;

my $m_s2_t = $s + $s_t_min_1;

print "\$s = $s\n";
print "\$m_s2_t = $m_s2_t\n";
my $M6308949 = 4336411086199724;
my $M6372432 = 4390481392426100;
my $delta_t2 = $M6372432 - $M6308949;
$n += $delta;
while ($n < 2_000_000_000)
{
    $m_delta += $MIN_ELEM * $delta * $delta;
    $delta_t2 += $MIN_ELEM * $delta * $s_t_min_1;
    $m += $m_delta;
}
continue
{
    $n += $delta;
}
print "M(@{[$n-$delta]}) = $m\n";
print "M(@{[2_000_000_000]}) = @{[$m + $delta_t2]}\n";
