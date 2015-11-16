#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Storable qw/dclone/;
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
        my $row = shift(@$b);

        X_LOOP:
        for my $x (0 .. $N-1)
        {
            if (!$row->{p}->[$x])
            {
                my $q = dclone($b);
                my $x1 = $x-1;
                my $x2 = $x+1;
                foreach my $mod_row (@$q[0 .. min($L-1, $N-$h-2)])
                {
                    for my $xx (
                        grep { $_ >= 0 and $_ <= $N-1 }
                        ($x1--,$x,$x2++)
                    )
                    {
                        if (!$mod_row->{p}->[$xx])
                        {
                            $mod_row->{p}->[$xx] = 1;
                            if (not --$mod_row->{c})
                            {
                                next X_LOOP;
                            }
                        }
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

    rec(0,[map { +{ c => $N, p => [(0)x$N] } } (1 .. $N)]);

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
