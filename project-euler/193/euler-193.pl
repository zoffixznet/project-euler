#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum max min);
use List::MoreUtils qw();

use Math::Prime::Util qw/next_prime/;
use integer;
use bytes;

my $DELTA = 1_000_000;

my $EXP = 25;

# my $EXP = 2;

my $MAX      = ( 1 << ( $EXP * 2 ) );
my $SQRT_MAX = ( 1 << ($EXP) );

my $reached_len = 0;

sub gen_prime_iter
{
    my $start = 1;
    open my $sieve_fh, '-|', 'primes.pl', 2, $MAX
        or die "Cannot open primes.pl";

    my $p = 2;

    return sub {
        my $ret = $p;
        if ( !defined($ret) )
        {
            return undef;
        }

        $p = next_prime($p);

        my $l = length sprintf( "%b", $ret );
        if ( $l > $reached_len )
        {
            $reached_len = $l;
            print "Reached $reached_len\n";
        }
        return $ret;
    };
}

my $nums_bit_mask = '';

my $iter = gen_prime_iter();

my $result = 0;

my $p;

# $p == 2
$p = $iter->();

vec( $nums_bit_mask, $p, 1 ) = 1;

my $LOW = $p;
$result++;

while ( ( $p = $iter->() ) < $SQRT_MAX )
{
    $result++;
    vec( $nums_bit_mask, $p, 1 ) = 1;

OTHER_N:
    for my $other_n ( 2 .. $p - 1 )
    {
        if ( vec( $nums_bit_mask, $other_n, 1 ) )
        {
            my $product = $other_n * $p;
            if ( $product >= $MAX )
            {
                last OTHER_N;
            }
            else
            {
                $result++;
                if ( $product < $SQRT_MAX )
                {
                    vec( $nums_bit_mask, $product, 1 ) = 1;
                }
            }
        }
    }
}

# Don't think I need that.
# my $high = $SQRT_MAX;

# We should not skip a $p.
my $first_time = 1;
while ( $first_time || defined( $p = $iter->() ) )
{
    $first_time = 0;
    $result++;

MAX_OTHER_N:
    for my $other_n ( 2 .. $SQRT_MAX )
    {
        if ( vec( $nums_bit_mask, $other_n, 1 ) )
        {
            my $product = $other_n * $p;

            if ( $product > $MAX )
            {
                last MAX_OTHER_N;
            }
            $result++;
        }
    }
}

print "Result == $result\n";
