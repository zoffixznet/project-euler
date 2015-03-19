#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

use IO::All qw/io/;

STDOUT->autoflush(1);

my @factorials = (1);
for my $n (1 .. 9)
{
    push @factorials, $factorials[-1] * $n;
}

my $SEEK = 150;
my $sum = 0;

foreach my $l (io()->file('./out.txt')->getlines())
{
    if (my ($digits) = $l =~ /\AFound g\([0-9]+\) == ([0-9]+) \(f=/)
    {
        $sum += sum( split//,$digits );
    }
}

for my $n (68 .. $SEEK)
{
    my $anti_g = int ( (($n % 9) || '') .  '9' x int($n / 9) );

    my $x = 0 + $anti_g;
    for my $d (reverse(1 .. 9))
    {
        $sum += $d * int($x / $factorials[$d]);
        $x %= $factorials[$d];
    }
}
print "Sum == $sum\n";
