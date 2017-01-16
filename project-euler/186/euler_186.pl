#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

package Rand;

use Moo;

has 'k' => ( is => 'rw', default => sub { return 1; } );
has 'prev' => ( is => 'rw', default => sub { return []; } );

sub get
{
    my ($self) = @_;

    my $k = $self->k();
    my $ret;
    if ( $k <= 55 )
    {
        $ret = ( 100_003 + $k * ( -200_003 + $k * $k * 300_007 ) );
    }
    else
    {
        $ret = $self->prev->[-55] + $self->prev->[-24];
        shift( @{ $self->prev() } );
    }

    $self->k( $k + 1 );

    $ret %= 1_000_000;

    push @{ $self->prev() }, $ret;

    return $ret;
}

sub get_pair
{
    my ($self) = @_;

    my $first  = $self->get();
    my $second = $self->get();

    return ( $first, $second );
}

package main;

use Test::More tests => 8;
use Test::Differences qw(eq_or_diff);

{
    my $r = Rand->new;

    # TEST
    eq_or_diff( [ $r->get() ], [200_007], "get 1." );

    # TEST
    eq_or_diff( [ $r->get() ], [100_053], "get 2." );

    # TEST
    eq_or_diff( [ $r->get() ], [600_183], "get 3." );

    # TEST
    eq_or_diff( [ $r->get() ], [500_439], "get 4." );

    # TEST
    eq_or_diff( [ $r->get() ], [600_863], "get 5." );

    # TEST
    eq_or_diff( [ $r->get() ], [701_497], "get 6." );
}

{
    my $r = Rand->new;

    # TEST
    eq_or_diff( [ $r->get_pair() ], [ 200_007, 100_053, ], "get-pair 1." );

    # TEST
    eq_or_diff( [ $r->get_pair() ], [ 600_183, 500_439 ], "get-pair 2." );
}

{
    my @friends;

    my $PM_PHONE = 524_287;

    my $r         = Rand->new;
    my $count     = 0;
    my $max_len   = 0;
    my $num_users = 0;
    while (
        not(
            defined( $friends[$PM_PHONE] )
            && (
                length( ${ $friends[$PM_PHONE] } ) >=
                ( ( 4 * 99 * 1_000_000 ) / 100 ) )
        )
        )
    {
        my @p = $r->get_pair();

        if ( $p[0] != $p[1] )
        {
            $count++;

            # Sort them first.
            if ( !defined( $friends[ $p[0] ] ) )
            {
                @p = reverse(@p);
            }

            if ( !defined( $friends[ $p[0] ] ) )
            {
                # If both are undefined
                my $new_vec = '';
                vec( $new_vec, 0, 32 ) = $p[0];
                vec( $new_vec, 1, 32 ) = $p[1];
                $friends[ $p[0] ] = $friends[ $p[1] ] = \$new_vec;
                $num_users += 2;
            }
            elsif ( !defined( $friends[ $p[1] ] ) )
            {
                # If one is undefined
                my $v = $friends[ $p[0] ];
                vec( $$v, ( length($$v) >> 2 ), 32 ) = $p[1];
                $friends[ $p[1] ] = $v;
                $num_users++;
            }
            else
            {
                # Both are associated.
                my $v0 = $friends[ $p[0] ];
                my $v1 = $friends[ $p[1] ];
                if ( $v0 ne $v1 )
                {
                    # Merge them if they are not identical.

                    # Make sure $v1 is the larger.
                    if ( length($$v0) > length($$v1) )
                    {
                        ( $v0, $v1 ) = ( $v1, $v0 );
                    }
                    $$v1 .= $$v0;

                    for my $idx ( 0 .. ( ( length($$v0) >> 2 ) - 1 ) )
                    {
                        $friends[ vec( $$v0, $idx, 32 ) ] = $v1;
                    }

=begin foo
                    if (length($$v1) > $max_len)
                    {
                        $max_len = length($$v1);
                        print "Reached $max_len Count = $count\n";
                    }
=end foo

=cut

                }
            }
        }
    }
    print "After $count Calls.\n";
}

