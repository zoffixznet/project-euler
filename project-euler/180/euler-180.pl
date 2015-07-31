#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use integer;
use bytes;

use Math::BigInt try => 'GMP';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

=head1 DESCRIPTION

For any integer n, consider the three functions

f1,n(x,y,z) = xn+1 + yn+1 − zn+1
f2,n(x,y,z) = (xy + yz + zx)*(xn-1 + yn-1 − zn-1)
f3,n(x,y,z) = xyz*(xn-2 + yn-2 − zn-2)

and their combination

fn(x,y,z) = f1,n(x,y,z) + f2,n(x,y,z) − f3,n(x,y,z)

We call (x,y,z) a golden triple of order k if x, y, and z are all rational numbers of the form a / b with
0 < a < b ≤ k and there is (at least) one integer n, so that fn(x,y,z) = 0.

Let s(x,y,z) = x + y + z.
Let t = u / v be the sum of all distinct s(x,y,z) for all golden triples (x,y,z) of order 35.
All the s(x,y,z) and t must be in reduced form.

Find u + v.

=cut

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
my @total_sum = (Math::BigInt->new(0),Math::BigInt->new(1));

sub gcd
{
    my ($n, $m) = @_;

    if ($n < $m)
    {
        return gcd($m,$n);
    }

    if ($m == 0)
    {
        return $n;
    }

    return gcd($m,$n % $m);
}

sub norm
{
    my ($aa, $bb) = @_;

    if ($bb < 0)
    {
        Carp::confess ( "Foo $aa/$bb" );
    }

    my $g = gcd(abs($aa), abs($bb));

    return ($aa / $g, $bb / $g);
}

sub _add
{
    my ($x_a, $x_b, $y_a, $y_b) = @_;

    return norm ($x_a*$y_b+$x_b*$y_a,$x_b*$y_b);
}

sub add
{
    my @r = _add(@_);

    if ($r[0] < 0)
    {
        Carp::confess ( "glim $r[0]/$r[1]" );
    }
    return @r;
}
sub check
{
    my $n = shift;
    my @xy = @_;
    my ($x_a, $x_b, $y_a, $y_b) = @_;

    my @sum = add(($n == 1) ? @xy : (map { $_ * $_ } @xy));

    my @z;
    if ($n == 2)
    {
        my $z_a = $sqrts{$sum[0]};
        my $z_b = $sqrts{$sum[1]};

        if ((!defined($z_a)) or (!defined($z_b)))
        {
            return;
        }
        @z = ($z_a, $z_b);
    }
    else
    {
        @z = @sum;
    }

    {
        my @s;
        if ( $x_a < $x_b )
        {
            if ($z[0] < $z[1] and $z[1] <= $K)
            {
                @s = add(add(@xy), @z);
            }
        }
        else
        {
            if ($z[0] > $z[1] and $z[0] <= $K)
            {
                @s = add(add($x_b,$x_a,$y_b,$y_a), @z[1,0]);
            }
        }

        if (@s)
        {
            my $s_str = "$s[0]/$s[1]";
            if (!exists($found_s{$s_str}))
            {
                @total_sum = add(@s, @total_sum);
                $found_s{$s_str} = 1;
            }
        }
    }

}

for my $x_b (2 .. $K)
{
    print "x_b=$x_b\n";
    for my $x_a (1 .. $x_b - 1)
    {
        # We can assume without loss of generality that y >= x.
        for my $y_b ($x_b .. $K)
        {
            for my $y_a (1 .. $y_b - 1)
            {

                for my $n (1, 2)
                {
                    check($n, $x_a, $x_b, $y_a, $y_b);
                    check($n, $x_b, $x_a, $y_b, $y_a);
                }
            }
        }
    }
}

print "$total_sum[0]/$total_sum[1] == @{[$total_sum[0]+$total_sum[1]]}\n";
