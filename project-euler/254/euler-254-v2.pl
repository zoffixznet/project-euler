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

my $num_digits = 1;
my $SEEK = 150;
while ($count < $SEEK)
{
    my $recurse;

    $recurse = sub {
        my $n = shift;

        if (length($n) == $num_digits)
        {
            my $sf = sum(split//,sum(@factorials[split//,$n]));

            if ($sf <= $SEEK)
            {
                if (!defined($g[$sf]))
                {
                    $count++;
                    $g[$sf] = $n;
                    $sum += sum(split//,$n);
                    print "Found g($sf) == $n [Count=$count]\n";
                    if ($count == $SEEK)
                    {
                        return 1;
                    }
                }
            }

            return;
        }
        else
        {
            my $s = substr($n,-1);
            for my $d (($s <= 1) ? (0 , 2..9) : ($s .. 9))
            {
                if ($recurse->($n.$d))
                {
                    return 1;
                }
            }
            return;
        }
    };

    D_LOOP:
    for my $d (1 .. 9)
    {
        if ($recurse->($d))
        {
            last D_LOOP;
        }
    }
}
continue
{
    $num_digits++;
}
print "Sum == $sum\n";
