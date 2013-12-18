#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $N = 1_000_000_000_000;

my $power_of_5 = 5;
my $sum = 0;
while ($power_of_5 < $N)
{
    $sum += int($N / $power_of_5);
}
continue
{
    $power_of_5 *= 5;
}
print "There are $sum powers of 5.\n";

my $power_of_2 = 2;
my $sum2 = 0;
while ($power_of_2 < $N)
{
    $sum2 += int($N / $power_of_2);
}
continue
{
    $power_of_2 *= 2;
}
print "There are $sum2 components of 2.\n";

my $sum_diff = $sum2 - $sum;
print "There are $sum_diff components of 2 excluding those for the digits.\n";

sub get_power_modulo
{
    my ($modulo, $b, $e) = @_;

    if ($e == 0)
    {
        return 1;
    }

    my $rec_p = get_power_modulo($modulo, $b, ($e >> 1));

    my $ret = $rec_p * $rec_p;

    if ($e & 0x1)
    {
        $ret *= $b;
    }

    return ($ret % $modulo);
}

my $FIVE_DIGITS_MOD = 100_000;
my $powers_2_contribution = get_power_modulo($FIVE_DIGITS_MOD, 2, $sum_diff);
print "They contribute $powers_2_contribution to the modulo\n"
