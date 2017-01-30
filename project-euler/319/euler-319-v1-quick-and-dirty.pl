#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use List::Util qw/ min max /;
use POSIX qw/ ceil floor /;

sub rec
{
    my ( $n, $so_far, $i ) = @_;

    print "So far: "
        . join( ", ",
        map { ref($_) eq 'ARRAY' ? "$_->[0]→$_->[1]" : $_ } @$so_far )
        . "\n";
    if ( $i == 1 )
    {
        return rec(
            $n,
            [
                2,
                (
                    map {
                        my $j   = $_;
                        my $x_i = 2;
                        [
                            1 + floor( -1 + $x_i**( $j / $i ) ),
                            -1 + ceil( ( $x_i + 1 )**( $j / $i ) )
                        ]
                    } 2 .. $n
                )
            ],
            $i + 1
        );
    }
    elsif ( $i > $n )
    {
        print "Found [@$so_far]\n";
    }
    else
    {
        my ( $bottom, $top ) = @{ $so_far->[ $i - 1 ] };
    X_I:
        foreach my $x_i ( $bottom .. $top )
        {
            my @new = @$so_far;
            $new[ $i - 1 ] = $x_i;
            foreach my $j ( $i + 1 .. $n )
            {
                my $old = $new[ $j - 1 ];
                my $new = [
                    max( 1 + floor( -1 + $x_i**( $j / $i ) ), $old->[0] ),
                    min( -1 + ceil( ( $x_i + 1 )**( $j / $i ) ), $old->[1] )
                ];
                if ( $new->[0] > $new->[1] )
                {
                    next X_I;
                }
                $new[ $j - 1 ] = $new;
            }
            rec( $n, \@new, $i + 1 );
        }
    }
}

binmode STDOUT, ':encoding(utf8)';

rec( shift(@ARGV), [], 1 );
