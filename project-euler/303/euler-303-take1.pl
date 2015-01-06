#!/usr/bin/perl

use strict;
use warnings;

use Euler303_Take1 (qw( f_div f_complete ));
use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

sub sum_of_f
{
    my ($max) = @_;

    my $sum = 0;

    for my $n (1 .. $max)
    {
        my $found = f_div($n);
        print "Found $found for $n\n";
        $sum += $found;
    }

    return $sum;
}

print "Sum[100] = " . sum_of_f(100) . "\n";

print "Sum[10000] = " . sum_of_f(10_000) . "\n";

