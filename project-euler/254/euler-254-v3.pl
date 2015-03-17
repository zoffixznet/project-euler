#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min sum);
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
        my ($n, $d) = @_;

        my $remain = $num_digits - length($n);

        if (! $remain)
        {
            my $f = sum(@factorials[split//,$n]);
            my $sf = sum(split//,$f);

            if ($sf <= $SEEK)
            {
                if (!defined($g[$sf]))
                {
                    $count++;
                    $g[$sf] = $n;
                    $sum += sum(split//,$n);
                    print "Found g($sf) == $n (f=$f) [Count=$count]\n";
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
            for my $e (($d == 9) ? ($remain) : reverse(0 .. min($remain, $d)))
            {
                if ($recurse->($n.($d x $e), $d+1))
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
        if ($recurse->('', $d))
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
