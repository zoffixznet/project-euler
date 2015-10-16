#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

open my $reached, '>>', "reached-log.txt";

$reached->autoflush(1);
my $max = 10000000000000000;
my $step = 1000000000;

my $s1 = $step-1;
while ($max > 0)
{
    my $min = $max - $s1;

    system('/home/shlomif/apps/primesieve/bin/primesieve', $min, $max, '--print=4');
    $reached->print("Reached $max\n");
    $max = $min - 1;
}

close($reached);
