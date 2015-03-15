#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @factorials = (1);
for my $n (1 .. 9)
{
    push @factorials, $factorials[-1] * $n;
}

my $sum = 0;
my @g;
my $count = 0;

my $n = 1;
while ($count < 150)
{
    my $sf = sum(@factorials[split//,$n]);

    if ($sf < 150)
    {
        if (!defined($g[$sf]))
        {
            $count++;
            $g[$sf] = $n;
            $sum += sum(split//,$n);
            print "Found g($sf) == $n [Count=$count]\n";
        }
    }
}
continue
{
    $n++;
}
