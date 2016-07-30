#!/usr/bin/perl

use strict;
use warnings;

use bigint;

sub lookup
{
    my ($place) = @_;

    return 0 + (`grep -F 'M($place) =' < dump_v3` =~ s/.* = //r);
}

my $delta = 6308949 - 1;
my $s = $delta + 1;
my $s2 = $s + $delta;
my $m_s = lookup($s);
my $m_s2 = lookup($s2);

my $m_delta = $m_s2 - $m_s;

my $n = $s2;
my $m = $m_s2 + 0;
# my $TARGET = $delta * 4 + 24024;
my $TARGET = 2_000_000_000;

my $s_t = (( $TARGET - 1 ) % $delta + 1);
my $s_t_min_1 = $s_t - 1;

my $m_s2_t = $s2 + $s_t_min_1;

my $MIN_ELEM = 3;
print "\$s = $s\n";
print "\$s2 = $s2\n";
print "\$m_s2_t = $m_s2_t\n";
print "\$s_t_min_1 = $s_t_min_1\n";
my $delta_t2 = lookup($m_s2_t) - $m_s2;
$n += $delta;
while ($n <= $TARGET)
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
print "M(@{[$TARGET]}) = @{[$m + $delta_t2]}\n";
