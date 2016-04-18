#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use List::Util qw(reduce);
use List::MoreUtils qw(uniq);

print "0\n";
open my $in, 'seq 1 120000 | factor |';
while (my $factors = <$in>)
{
    $factors =~ s{\A[^:]+:}{};
    print ((reduce { $a * $b } 1, uniq($factors =~ m/(\d+)/g)), "\n");
}
close $in;
