#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use List::MoreUtils qw(all);

STDOUT->autoflush(1);

my $sum = 0;

# rec is short for "recurse".
sub rec
{
    my ( $factor, $counts, $result ) = @_;

    my $cnt = sum(@$counts);
    if ( $cnt == 0 )
    {
        $sum += $factor * $result;
    }
    else
    {
        while ( my ( $size, $f ) = each(@$counts) )
        {
            if ( $f > 0 )
            {
                my @c = @$counts;
                $c[$size]--;
                for my $s ( $size + 1 .. 4 )
                {
                    $c[$s]++;
                }
                rec( $factor * $f / $cnt, ( \@c ), $result + ( $cnt == 1 ) );
            }
        }
    }
    return;
}

rec( 1, [1], 0 );

printf "Result == %.6f\n", ( $sum - 2 );
