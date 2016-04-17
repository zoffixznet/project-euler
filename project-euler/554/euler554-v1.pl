#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

no warnings 'recursion';
# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @OFFSETS = ([0,0],[0,1],[1,0],[1,1]);

my @ATTACKS;

foreach my $x (-2 .. 2)
{
    foreach my $y (-2 .. 2)
    {
        if (abs($x) + abs($y) == 3
                or
            (abs($x) <= 1) && (abs($y) <= 1)
        )
        {
            push @ATTACKS, [$x,$y];
        }
    }
}

my %A = (map { (join',',@$_) => 1 } @ATTACKS);

sub calc_C
{
    my ($n) = @_;

    my $cb;
    my $ret = 0;

    my @p = [(undef) x ($n * $n)];

    $cb = sub {
        my ($x, $y, $i) = @_;

        my $base_x = ($x << 1);
        my $base_y = ($y << 1);

        NEW:
        foreach my $new (@OFFSETS)
        {
            my $nx = $base_x + $new->[0];
            my $ny = $base_y + $new->[1];

            my $check = sub {
                my ($off) = @_;
                my $cent = $p[$i-$off];
                return (exists($A{join',', $cent->[0]-$nx,$cent->[1]-$ny}));
            };

            if ($x > 0 && $check->(1)
                    or
                $y > 0 && $check->($n)
                    or
                $x > 0 && $y > 0 && $check->($n + 1)
            )
            {
                next NEW;
            }

            $p[$i] = [$nx,$ny];
            # Move to the next.
            if ($x + 1 == $n)
            {
                if ($y + 1 == $n)
                {
                    ++$ret;
                    # printf "Ret = %d\n", ++$ret;
                }
                else
                {
                    $cb->(0,$y+1, $i+1);
                }
            }
            else
            {
                $cb->($x+1,$y, $i+1);
            }
        }
    };

    $cb->(0,0,0);

    $cb = undef;

    return $ret;
}

sub print_C
{
    my ($n) = @_;

    printf "C(%d) = %d\n", $n, calc_C($n);
}

print_C(1);
print_C(2);
print_C(3);
print_C(4);
print_C(10);
