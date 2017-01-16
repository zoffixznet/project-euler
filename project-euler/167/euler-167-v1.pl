#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Tree::RB;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $DESIRED_K = int( 1 . ( '0' x 11 ) ) - 1;

sub solve
{
    my ($n) = @_;

    my $AA = 2;
    my $BB = $n * 2 + 1;

    my $U = 0;
    my $u = '';
    vec( $u, $U++, 32 ) = $AA;
    vec( $u, $U++, 32 ) = $BB;

    print "$AA\n$BB\n";

    my $v = '';
    vec( $v, $AA + $BB, 2 ) = 1;

    my $CALC_CNT = (
          ( $n < 5 )  ? ( $n * 2_000 )
        : ( $n < 8 )  ? ( $n * 16_000 )
        : ( $n == 8 ) ? ( $n * 500_000 )
        : ( $n == 9 ) ? ( $n * 1_000_000 )
        :               ( $n * 4_000_000 )
    );
    my $FIND_NUM = ( $CALC_CNT >> 2 );
    my $MAX_STEP = ( $FIND_NUM >> 2 );

    my $double_good_next;
    my $even;

    my $next;
    while ( not( defined($double_good_next) and $next > $double_good_next ) )
    {
        $next = undef;
        my $LAST_u = vec( $u, $U - 1, 32 );
    FIND_NEXT:
        for my $i ( $LAST_u + 1 .. ( $LAST_u << 1 ) )
        {
            if ( vec( $v, $i, 2 ) == 1 )
            {
                $next = $i;
                last FIND_NEXT;
            }
        }

        if ( !defined($next) )
        {
            die "Next not found!";
        }

        for my $prev_i ( 0 .. $U - 1 )
        {
            my $s = vec( $u, $prev_i, 32 ) + $next;
            if ( vec( $v, $s, 2 ) < 2 )
            {
                vec( $v, $s, 2 )++;
            }
        }

        # print "$next\n";
        vec( $u, $U++, 32 ) = $next;

        if ( not( $next & 0x1 ) )
        {
            $double_good_next = ( ( $even = $next ) << 1 );
        }
    }

    while ( $U < $CALC_CNT )
    {
        my $val = sub {

            # Pivot for 2
            my $p2 = $U - 1;

            # Pivot for even.
            my $pe = $p2 - 1;

            my $LAST_u = vec( $u, $p2, 32 );

            my $val     = $LAST_u + $AA;
            my $MAX_VAL = $LAST_u + $even;

            while ( vec( $u, $pe, 32 ) + $even > $val )
            {
                $pe--;
            }
            if ( vec( $u, $pe, 32 ) + $even != $val )
            {
                return $val;
            }
            while ( ( $val += 2 ) < $MAX_VAL )
            {
                while ( vec( $u, $pe, 32 ) + $even < $val )
                {
                    $pe++;
                }
                if ( vec( $u, $pe, 32 ) + $even == $val )
                {
                    return $val;
                }
            }
            return $val;
            }
            ->();
        vec( $u, $U++, 32 ) = $val;
    }

    my $M = $U - 1;
STEP:
    for my $STEP ( 1 .. $MAX_STEP )
    {
        my $delta = vec( $u, $M, 32 ) - vec( $u, $M - $STEP, 32 );

        for my $i ( $M - $FIND_NUM .. $M - $STEP - 1 )
        {
            if ( vec( $u, $i + $STEP, 32 ) - vec( $u, $i, 32 ) != $delta )
            {
                next STEP;
            }
        }
        my $STEP_K = $DESIRED_K;
        $STEP_K -= ( ( int( ( $STEP_K - $M ) / $STEP ) + 1 ) * $STEP );
        return
            vec( $u, $STEP_K, 32 ) +
            $delta * ( ( $DESIRED_K - $STEP_K ) / $STEP );
    }

    die "Cannot find for $n!";
}

my $total_sum = 0;
for my $n ( 2 .. 10 )
{
    $total_sum += solve($n);
    print "Total Sum [n=$n] = $total_sum\n";
}
print "Total Sum = $total_sum\n";
