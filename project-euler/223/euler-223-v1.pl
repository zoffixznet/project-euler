#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use feature qw/say/;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $LIM = 25_000_000;

# For the case where A = 1.
my $count = int(sqrt(($LIM-1)/2));
my $As = 4;
my $Ad = 3;
my $l = $LIM/3;
A:
for my $A (2 .. $l)
{
    print "Checking A=$A\n";
    my $Cs = (($As<<1)-1);
    my $Bd = $Ad;
    for my $B ($A .. $l)
    {
        my $C = int(sqrt($Cs));
        if ($A+$B+$C > $LIM)
        {
            next A;
        }
        if ($C*$C == $Cs)
        {
            say "Found ($A,$B,$C) @{[++$count]}";
        }
    }
    continue
    {
        $Cs += ($Bd += 2);
    }
}
continue
{
    $As += ($Ad += 2);
}
