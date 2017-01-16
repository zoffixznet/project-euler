#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(min max sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @primes = map { 0 + $_ } `primes 2 100`;

my $L = shift(@ARGV);

# The count.
my $c = 0;

for my $n ( 1 .. $L )
{
    my @x = ( grep { $n % $_ == 0 } @primes );
    if ( @x >= 4 )
    {
        print "N = $n : @x\n";
        $c++;
    }
}

print "Count = $c\n";
