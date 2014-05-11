#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $count = 0;

my %Cache = ();

sub rec
{
    my ($n, $left) = @_;

    print "Checking [$n,$left]\n";

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
            while ($left >= 0)
            {
                $ret += rec($n-1, $left);
                $left -= $n;
            }
            $ret;
        };
    }

}

my $NUM_OBJS = 60;
print "Found ", rec($NUM_OBJS,$NUM_OBJS), "\n";
