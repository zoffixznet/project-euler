#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $BASE = 20092010;
my $LEN  = 2000;

# Penultimate len.
my $PL = $LEN - 1;

package Mat;

my $ORIG  = 0;
my $TRANS = 1;

sub new
{
    my $o = \( my $foo = '' );
    my $t = \( my $bar = '' );

    my ( $class, $cb ) = @_;

    # The cell index
    my $ci = 0;
    for my $row ( 0 .. $PL )
    {
        my $ti = $row;
        for my $col ( 0 .. $PL )
        {
            vec( $$o, $ci++, 32 ) = vec( $$t, $ti, 32 ) = $cb->( $row, $col );
        }
        continue
        {
            $ti += $LEN;
        }
    }
    return bless [ $o, $t ], $class;
}

sub mul
{
    my ( $m_base, $n_base ) = @_;

    my $m = $m_base->[$ORIG];
    my $n = $n_base->[$TRANS];

    my $mi = -$LEN;
    my $ni;
    return Mat->new(
        sub {
            my ( $r, $c ) = @_;

            if ( $c == 0 )
            {
                $mi += $LEN;
                $ni = 0;
            }
            my $sum = 0;
            for my $i ( 0 .. $PL )
            {
                ( $sum += vec( $$m, $mi + $i, 32 ) * vec( $$n, $ni++, 32 ) ) %=
                    $BASE;
            }

            return $sum;
        }
    );
}

package main;

my $ONE = Mat->new(
    sub {
        my ( $r, $c ) = @_;
        return (
            (
                       ( ( $r == $PL ) and ( $c <= 1 ) )
                    or ( ( $r < $PL )  and ( $r + 1 == $c ) )
            ) ? 1 : 0
        );
    },
);

sub power
{
    my ($n) = @_;

    if ( $n == 1 )
    {
        return $ONE;
    }
    else
    {
        my $rec = power( $n >> 1 );
        print "After rec $n\n";
        my $ret = $rec->mul($rec);
        print "After mul $n\n";
        return ( ( $n & 0x1 ) ? $ret->mul($ONE) : $ret );
    }
}

my $p = power(1_000_000_000_000_000_000);

my $sum = 0;

my $o = $p->[$ORIG];
for my $col ( 0 .. $PL )
{
    ( $sum += vec( $$o, $col, 32 ) ) %= $BASE;
}

print "Result = $sum\n";
