#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $max = 0;
while (my $l = <ARGV>)
{
    my ($n) = ($l =~ /([0-9]+)/g);
    my $sum = `seq "$n" "@{[$n+8]}" | factor | perl -lane '\$s += \$F[-1]; END { print \$s }'`;
    chomp($sum);
    if ($sum > $max)
    {
        $max = $sum;
    }
    print "Found n = $n Max = $max\n";
}
