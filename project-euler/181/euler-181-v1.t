#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Test::More tests => 3;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $count = 0;

my %Cache = ();

sub rec
{
    my ($n, $left) = @_;

    # print "Checking [$n,$left]\n";

    if ($left == 0)
    {
        return 1;
    }
    elsif ($n == 1)
    {
        return 1;
    }
    else
    {
        return $Cache{"$n|$left"} //= do {
            my $ret = 0;

            if ($left >= $n)
            {
                $ret += rec($n, $left-$n);
            }
            $ret += rec($n-1, $left);
            $ret;
        };
    }

}

# TEST
is (rec(1, 5), 1, 'rec(1,5)');

# TEST
is (rec(2, 5), 3, 'rec(2,5)');

# TEST
is (rec(3, 3), 3, 'rec(3,3)');

my $NUM_OBJS = 60;
# print "Found ", rec($NUM_OBJS,$NUM_OBJS), "\n";
# exit(0);
