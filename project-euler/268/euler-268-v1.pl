#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP';

use List::Util qw(min max sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @primes = map { 0 + $_ } `primes 2 100`;
my @logs = map { log($_) } @primes;

my $L = (10 ** 16);
# my $L = 1_000;

my $LOG_L = log($L);

my $total = 0;

my $MAX_C = (1 << 25);
my $ITER = 100_000;
my $count = 0;
my $next_iter = $ITER;
sub f
{
    # $i is index to start from.
    # $c is count.
    # $mul is the product
    my ($i, $c, $mul, $mul_l) = @_;

    # print "\@_ = @_\n";
    if ($mul_l > $LOG_L)
    {
        return;
    }

    if ($i == @primes)
    {
        if (++$count == $next_iter)
        {
            print "Reached $count/$MAX_C\n";
            $next_iter += $ITER;
        }
        if ($c >= 4)
        {
            my $offset = int( $L / $mul );
            if ($c & 0x1)
            {
                $total -= $offset;
            }
            else
            {
                $total += $offset;
            }
        }
    }
    else
    {
        f($i + 1, $c, $mul, $mul_l);
        f($i + 1, $c+1, $mul*$primes[$i], $mul_l + $logs[$i]);
    }
    return;
}

f(0, 0, 1, 0);

print "total = $total\n";
