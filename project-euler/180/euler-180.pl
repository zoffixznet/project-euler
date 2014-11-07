#!/usr/bin/perl

use strict;
use warnings;

use bytes;

use Math::BigRat lib => 'GMP';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $K = 35;

sub pick_frac
{
    my ($cb) = @_;

    for my $bb ( 2 .. $K)
    {
        for my $aa (1 .. $bb-1)
        {
            $cb->($aa, $bb);
        }
    }

    return;
}

my %sqrts;
foreach my $n (1 .. ($K*2))
{
    $sqrts{$n*$n} = $n;
}

my %found_s;
my $total_sum = Math::BigRat->new("0/1");

sub check
{
    my ($n, $x_a, $x_b, $y_a, $y_b) = @_;

    my $x = Math::BigRat->new("$x_a/$x_b");
    my $y = Math::BigRat->new("$y_a/$y_b");
    my $sum = $x ** $n + $y ** $n;

    $sum->bnorm();

    my $z;
    if ($n == 2)
    {
        my $z_a = $sqrts{$sum->numerator};
        my $z_b = $sqrts{$sum->denominator};

        if (!defined($z_a) or (!defined($z_b)))
        {
            return;
        }
        $z = Math::BigRat->new("$z_a/$z_b");
    }
    else
    {
        $z = $sum;
    }

    {
        if
        (
            ($x_a < $x_b)
            ? ($z->numerator < $z->denominator and $z->denominator <= $K)
            : ($z->numerator > $z->denominator and $z->numerator <= $K)
        )
        {
            my $s = $x + $y + $z;
            $s->bnorm;
            my $s_str = $s->bstr;
            if (!exists($found_s{$s_str}))
            {
                $total_sum += $s;
                $found_s{$s_str} = 1;
            }
        }
    }

}

pick_frac(
    sub {
        my ($x_a, $x_b) = @_;
        pick_frac(
            sub {
                my ($y_a, $y_b) = @_;
                print "{$x_a,$x_b,$y_a,$y_b}\n";

                for my $n (1, 2)
                {
                    check($n, $x_a, $x_b, $y_a, $y_b);
                    check($n, $x_b, $x_a, $y_b, $y_a);
                }
            },
        );
    },
);

print "$total_sum\n";
