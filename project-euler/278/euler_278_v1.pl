#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

sub f
{
    my @x = @_;

    my $b = '';
    vec( $b, 0, 1 ) = 1;

    my $n      = 0;
    my $last   = 0;
    my $DELTA  = $x[0] + 1;
    my $target = $last + $DELTA;

    while ( $n < $target )
    {
        if ( vec( $b, $n, 1 ) )
        {
            foreach my $x (@x)
            {
                vec( $b, $n + $x, 1 ) = 1;
            }
        }
        else
        {
            $last   = $n;
            $target = $last + $DELTA;
        }
    }
    continue
    {
        ++$n;
    }
    return $last;
}

sub test
{
    my ( $x, $res ) = @_;
    if ( f(@$x) != $res )
    {
        die "[@$x]!";
    }
    return;
}

test( [ 5, 7 ], 23 );
test( [ 6,  10, 15 ], 29 );
test( [ 14, 22, 77 ], 195 );

my @p = `primesieve -p1 2 5000`;
chomp @p;
say $_ for @p;
my $ret = 0;
foreach my $pi ( 50 .. $#p )
{
    my $p = int $p[$pi];
    foreach my $qi ( $pi + 1 .. $#p )
    {
        my $q = int $p[$qi];
        foreach my $ri ( $qi + 1 .. $#p )
        {
            my $r = int $p[$ri];
            my $res = f( $p * $q, $p * $r, $q * $r );
            $ret += $res;
            say "Reached [$p,$q,$r] = $res [ sum = $ret]";
            if ( $res >= 2 * $p * $q * $r )
            {
                die "foo!";
            }
        }
    }
}
say "Result = $ret";
