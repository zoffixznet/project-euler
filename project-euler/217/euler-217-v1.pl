#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

# S = sums.
# $sums[$num_digits][$sum][$leading_digit_truth] = [$count, $sum]
my @S;

for my $d ( 0 .. 9 )
{
    $S[1][$d][ ( $d != 0 ) ? 1 : 0 ] = [ 1, $d ];
}

my $COUNT = 0;
my $SUM   = 1;

my $pow10 = 10;
for my $num_digits ( 2 .. 26 )
{
    my $prev = $num_digits - 1;

    my $pow10times = 0;
    for my $leading_digit ( 0 .. 9 )
    {
        my $d_t = ( ( $leading_digit != 0 ) ? 1 : 0 );
        while ( my ( $prev_sum, $prev_leads_aref ) = each( @{ $S[$prev] } ) )
        {
            foreach my $prev_stats (@$prev_leads_aref)
            {
                if ( defined($prev_stats) )
                {
                    my $record =
                        (
                        $S[$num_digits][ $prev_sum + $leading_digit ][$d_t] //=
                            [ 0, 0 ] );

                    $record->[$COUNT] += $prev_stats->[$COUNT];
                    $record->[$SUM] +=
                        $prev_stats->[$SUM] +
                        $prev_stats->[$COUNT] * $pow10times;
                }
            }
        }
    }
    continue
    {
        $pow10times += $pow10;
    }
}
continue
{
    $pow10 *= 10;
}

my @unique_results;
my @T;

$unique_results[0] = 0;
$unique_results[1] = 45;

$T[0] = 0;
$T[1] = $unique_results[1] + $T[0];

for my $num_digits ( 2 .. 47 )
{
    my $half   = ( $num_digits >> 1 );
    my $parity = ( $num_digits & 0x1 );
    my $result = 0;
    foreach my $sum ( @{ $S[$half] } )
    {
        my $count_true = $sum->[1]->[0] // 0;
        my $sum_true   = $sum->[1]->[1] // 0;
        my $count_both = $count_true + ( $sum->[0]->[0] // 0 );
        my $sum_both   = $sum_true + ( $sum->[0]->[1] // 0 );
        $result +=
            ( $sum_true * $count_both * ( 10**( $half + $parity ) ) +
                $sum_both * $count_true ) * ( $parity ? 10 : 1 ) +
            (
            $parity ? ( 45 * $count_both * $count_true * ( 10**$half ) ) : 0 );

    }
    $unique_results[$num_digits] = $result;
    push @T, $T[-1] + $result;
}

print "T(2) = ", $T[2], "\n";
print "T(5) = ", $T[5], "\n";
print "T(47) mod 3**15 = ", ( $T[47] % ( 3**15 ) ), "\n";
