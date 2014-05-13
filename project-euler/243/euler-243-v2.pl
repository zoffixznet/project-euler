#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(product sum);
use List::MoreUtils qw(uniq);

STDOUT->autoflush(1);

my $min_ratio = 1;

my $MULTIPLIER = 510_510;

FIND:
for my $base_i (1 .. 1e9)
{
    my $i = $base_i * $MULTIPLIER;
    my $num_non_strange = 0;

    my @f = uniq(`factor "$i"` =~ s/\A[^:]*://r =~ /([0-9]+)/g);
    my $recurse;

    $recurse = sub {
        my ($pos, $prod, $parity) = @_;

        if ($pos == @f)
        {
            if ($prod > 1)
            {
                $num_non_strange += (($parity ? (-1) : 1) * ($i / $prod));
            }
        }
        else
        {
            $recurse->($pos+1, $prod, $parity);
            $recurse->($pos+1, $prod*$f[$pos], ($parity^0b1));
        }

        return;
    };

    $recurse->(0, 1, 1);
    my $num_strange = $i - $num_non_strange;
    my $num_proper = $i - 1;

    # print "At i=$i : num_non_strange=$num_non_strange num_strange=$num_strange num_proper=$num_proper\n";

    my $ratio = $num_strange / $num_proper;

    if ($ratio < $min_ratio)
    {
        print "New minimum at $i == $ratio\n";
        $min_ratio = $ratio;
    }
    if ($num_strange * 94_744 < $num_proper * 15_499)
    # if ($num_strange * 10 < $num_proper * 4)
    {
        print "Found $i\n";
        last FIND;
    }
}
