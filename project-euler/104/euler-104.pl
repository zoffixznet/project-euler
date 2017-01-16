#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

my $this_fib = 1;
my $prev_fib = 1;

my $k = 2;

sub is_pan
{
    my $s = shift;
    return join( "", sort { $a cmp $b } split //, $s ) eq "123456789";
}

while (1)
{
    ( $prev_fib, $this_fib ) = ( $this_fib, $prev_fib + $this_fib );
    $k++;

    if (   is_pan( substr( "$this_fib", 0, 9 ) )
        && is_pan( substr( "$this_fib", -9 ) ) )
    {
        print "F_[$k] matches.";
        exit(0);
    }
}

