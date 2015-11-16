#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::GMP; # (qw(:constant));

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $N;
my $L;

my $t;

sub rec
{
    # $N is the length of the board.
    # $L is $N - 1 - w
    # $h is the row's height.
    # $b is the lookup table.
    # $t is the total count.
    my ($h, $b) = @_;

    if ($h == $N)
    {
        # printf "t=%s\n", $t++;
        $t++;
    }
    else
    {
        for my $x (0 .. $N-1)
        {
            if (!vec($b, $h*$N+$x,1))
            {
                my $q = $b;
                for my $y (1 .. min($L, $N-$h-1))
                {
                    for my $xx (
                        grep { $_ >= 0 and $_ <= $N-1 }
                        ($x-$y,$x,$x+$y)
                    )
                    {
                        vec($q, ($y+$h)*$N+$xx, 1) = 1;
                    }
                }
                rec($h+1,$q);
            }
        }
    }
    return;
}

sub solve
{
    my ($new_N, $new_w) = @_;

    $N = $new_N;
    $t = Math::GMP->new(0);

    if ($new_w == $new_N-1)
    {
        return ($new_N ** $new_N);
    }

    $L = $N - 1 - $new_w;

    rec(0,'');
    return $t;
}

{
    my $n = shift(@ARGV);
    my $total = Math::GMP->new(0);

    for my $w (0 .. $n-1)
    {
        my $ret = solve($n, $w);
        print "Q($n,$w) = $ret\n";
        $total += $ret;
    }
    print "S($n) = $total\n";
}
