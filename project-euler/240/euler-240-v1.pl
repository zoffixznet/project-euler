#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub top_dice
{
    my ( $num_dice, $num_sides, $num_top, $top_sum ) = @_;

    # The factorials.
    my @fac = ( 1, 1 );

    for my $n ( 2 .. $num_dice )
    {
        push @fac, $fac[-1] * $n;
    }

    my $count = 0;

    my $rec;

    my $init_base = $fac[$num_dice];

    $rec = sub {
        my ( $n, $dice, $sum ) = @_;

        if ( $n == $num_top )
        {
            if ( $sum == $top_sum )
            {
                # my $base = $init_base->copy;
                my $base = $init_base;

                for my $d ( @$dice[ 0 .. $#$dice - 1 ] )
                {
                    $base /= $fac[ $d->[1] ];
                }

                my $least = $dice->[-1]->[0];

                my $top_is_1 = ( $least == 1 );
                for my $extra_least (
                      $top_is_1
                    ? $num_dice - $num_top
                    : ( 0 .. $num_dice - $num_top )
                    )
                {
                    my $num_below = ( $num_dice - $num_top - $extra_least );
                    $count += (
                        $base / (
                            $fac[ $dice->[-1]->[1] + $extra_least ] *
                                $fac[$num_below]
                        ) * ( $top_is_1 ? 1 : ( $least - 1 )**$num_below )
                    );
                }
            }
            return;
        }
        my $least = $dice->[-1]->[0];

        # Handle the case of least.
        if ( $least * ( $num_top - $n ) + $sum < $top_sum )
        {
            return;
        }

        $rec->(
            $n + 1,
            [ @$dice[ 0 .. $#$dice - 1 ], [ $least, $dice->[-1]->[1] + 1 ] ],
            $sum + $least,
        );

        for my $new ( reverse( 1 .. $least - 1 ) )
        {
            $rec->( $n + 1, [ @$dice, [ $new, 1 ] ], $sum + $new );
        }
        return;
    };

    for my $top ( 1 .. $num_sides )
    {
        print "Reached $top\n";
        $rec->( 1, [ [ $top, 1 ] ], $top );
    }

    return $count;
}

print "For the test case it is ", top_dice( 5, 6, 3, 15 ),
    " and should be 1111\n";
print "Answer = ", top_dice( 20, 12, 10, 70 ), "\n";
