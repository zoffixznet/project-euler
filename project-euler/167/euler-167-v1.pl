#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub solve
{
    my ($n) = @_;

    my $AA = 2;
    my $BB = $n*2+1;

    my @u = ($AA, $BB);
    print "$AA\n$BB\n";

    my $v = '';
    vec($v, $AA+$BB, 2) = 1;

    while (@u < 1_000)
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

    return $u[-1];
}

my $total_sum = 0;
for my $n (2 .. 10)
{
    $total_sum += solve($n);
}
print "Total Sum = $total_sum\n";
