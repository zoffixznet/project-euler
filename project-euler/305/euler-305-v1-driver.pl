#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $BASE = 3;

my $power = $BASE;
my $sum = 0;
for my $k (1 .. 13)
{
    $sum += `QUIET=1 ./e305-prod.exe "$power" "$power" | tail -1`;
    print "$k [ 3 ** k = $power ] : $sum\n";
}
continue
{
    $power *= $BASE;
}
