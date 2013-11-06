#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(reduce);
use List::MoreUtils qw(uniq);

print "0\n";
foreach my $n (1 .. 120_000)
{
    my $factors = `factor $n`;
    $factors =~ s{\A[^:]+:}{};
    print ((reduce { $a * $b } 1, uniq($factors =~ m/(\d+)/g)), "\n");
}
