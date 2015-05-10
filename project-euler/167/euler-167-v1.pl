#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Tree::RB;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $DESIRED_K = int(1 . ('0' x 11)) - 1;

sub solve
{
    my ($n) = @_;

    my $AA = 2;
    my $BB = $n*2+1;

    my @u = ($AA, $BB);
    print "$AA\n$BB\n";

    my $v = '';
    vec($v, $AA+$BB, 2) = 1;

    my $CALC_CNT = $n * 2_000;
    my $FIND_NUM = $n * 1000;
    my $MAX_STEP = $n * 500;

    while (@u < $CALC_CNT)
    {
        my $next;
        FIND_NEXT:
        for my $i ($u[-1]+1 .. ($u[-1]<<1))
        {
            if (vec($v, $i, 2) == 1)
            {
                $next = $i;
                last FIND_NEXT;
            }
        }

        if (!defined ($next))
        {
            die "Next not found!";
        }

        for my $prev (@u)
        {
            my $s = $prev+$next;
            if (vec($v, $s, 2) < 2)
            {
                vec($v, $s, 2)++;
            }
        }

        print "$next\n";
        push @u, $next;
    }

    my $M = $#u;
    STEP:
    for my $STEP (1 .. $MAX_STEP)
    {
        my $delta = $u[$M]-$u[$M-$STEP];

        for my $i ($M-$FIND_NUM .. $M-$STEP-1)
        {
            if ($u[$i+$STEP] - $u[$i] != $delta)
            {
                next STEP;
            }
        }
        my $STEP_K = $DESIRED_K;
        $STEP_K -= ((int (($STEP_K - $M) / $STEP) + 1) * $STEP);
        return $u[$STEP_K] + $delta * (($DESIRED_K - $STEP_K) / $STEP);
    }

    die "Cannot find for $n!";
}

my $total_sum = 0;
for my $n (2 .. 10)
{
    $total_sum += solve($n);
}
print "Total Sum = $total_sum\n";
