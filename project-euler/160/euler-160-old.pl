#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $N = abs( int( $ENV{N} || 1_000_000_000_000 ) );

my $power_of_5 = 5;
my $sum        = 0;
while ( $power_of_5 <= $N )
{
    $sum += int( $N / $power_of_5 );
}
continue
{
    $power_of_5 *= 5;
}
print "There are $sum powers of 5.\n";

my $power_of_2 = 2;
my $sum2       = 0;
while ( $power_of_2 <= $N )
{
    $sum2 += int( $N / $power_of_2 );
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
    my ( $modulo, $b, $e ) = @_;

    if ( $e == 0 )
    {
        return 1;
    }

    my $rec_p = get_power_modulo( $modulo, $b, ( $e >> 1 ) );

    my $ret = $rec_p * $rec_p;

    if ( $e & 0x1 )
    {
        $ret *= $b;
    }

    return ( $ret % $modulo );
}

my $FIVE_DIGITS_MOD = 100_000;
my $powers_2_contribution = get_power_modulo( $FIVE_DIGITS_MOD, 2, $sum_diff );
print "They contribute $powers_2_contribution to the modulo\n";

my $i               = 1;
my $next_trace_step = my $next_trace = 1_000_000;
my $mod             = 1;
while ( $i <= $N )
{
    my $j = $i;
    while ( ( $j & 1 ) == 0 )
    {
        $j >>= 1;
    }
    while ( $j % 5 == 0 )
    {
        $j /= 5;
    }
    ( $mod *= $j ) %= $FIVE_DIGITS_MOD;
}
continue
{
    $i++;
    if ( $i == $next_trace )
    {
        print "Modulo for $i is $mod\n";
        $next_trace += $next_trace_step;
    }
}
print "Modulo for $i is $mod\n";
print "TotalMod == ", ( ( $mod * $powers_2_contribution ) % $FIVE_DIGITS_MOD ),
    "\n";
