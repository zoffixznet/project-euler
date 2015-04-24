#!/usr/bin/perl

use strict;
use warnings;

use IO::All qw/ io /;

my $s = io->file("input.txt")->all;

my $sum = 0;
for my $d (1 .. 9)
{
    $sum += $d * (eval "\$s =~ tr/$d/$d/");
}

print "Sum = $sum\n";
