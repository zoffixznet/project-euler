#!/usr/bin/perl

use strict;
use warnings;

use Algorithm::Permute ();

my $count = 1;
my $N     = shift @ARGV;
for my $n ( 1 .. $N )
{
    $count = $n * $count + ( $n % 2 ? (-1) : 1 );
}
print "$N\t$count\n";
