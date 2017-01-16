package Euler215;

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

use parent 'Exporter';

our @EXPORT_OK = (qw(to_id from_id));

STDOUT->autoflush(1);
STDERR->autoflush(1);

sub to_id
{
    my ($wall) = @_;

    my $v = '';
    while ( my ( $i, $rec ) = each(@$wall) )
    {
        vec( $v, $i, 8 ) = ( ( $rec->{o} & 0x1 ) | ( $rec->{l} << 1 ) );
    }

    return $v;
}

sub from_id
{
    my ($id) = @_;

    return [
        map {
            my $v = vec( $id, $_, 8 );
            +{ o => ( 2 | ( $v & 0x1 ) ), l => ( $v >> 1 ) }
        } 0 .. length($id) - 1
    ];
}

our $LEN;
our $NUM_LAYERS;
our @levels;

sub solve_for_level
{
    # The level index.
    my ($l) = @_;

    STDERR->print("Checking level $l\n");

    if ( !defined( $levels[$l] ) )
    {
        return;
    }

    while ( my ( $id, $count ) = each( %{ $levels[$l] } ) )
    {
        my $wall = from_id($id);

        my $min_i;
        my $min_len = $LEN + 1;

        while ( my ( $i, $rec ) = each @$wall )
        {
            my $len = $rec->{l};
            if ( $len < $min_len )
            {
                $min_len = $len;
                $min_i   = $i;
            }
        }

        my $rem = $LEN - $min_len;
    NEW:
        for my $new ( ( $rem >= 5 ) ? ( 2, 3 ) : ( $rem == 3 ) ? (3) : (2) )
        {
            my $new_len = $min_len + $new;
            if ( $new_len != $LEN )
            {
                foreach my $i (
                    ( ( $min_i > 0 ) ? ( $min_i - 1 ) : () ),
                    ( ( $min_i + 1 < $NUM_LAYERS ) ? ( $min_i + 1 ) : () ),
                    )
                {
                    my ( $o, $l ) = @{ $wall->[$i] }{qw(o l)};
                    if ( $l == $new_len or ( $l - $o ) == $new_len )
                    {
                        next NEW;
                    }
                }
            }
            my $new_id = $id;
            vec( $new_id, $min_i, 8 ) = ( ( $new & 0x1 ) | ( $new_len << 1 ) );
            $levels[ $l + $new ]{$new_id} += $count;
        }
    }

    # Free no longer necessary results.
    $levels[$l] = undef();

    return;
}

sub solve
{
    my ( $len, $num_layers ) = @_;

    @levels = ();

    $LEN        = $len;
    $NUM_LAYERS = $num_layers;

    foreach my $start_new ( 2, 3 )
    {
        my $wall = [
            map {
                my $l = ( ( $_ & 0x1 ) ? $start_new : ( $start_new ^ 0x1 ) );
                +{ o => $l, l => $l }
            } ( 0 .. $NUM_LAYERS - 1 )
        ];

        my $sum = sum( map { $_->{l} } @$wall );

        $levels[$sum]{ to_id($wall) } = 1;
    }

    my $total = $LEN * $NUM_LAYERS;
    for my $l ( 0 .. $total - 1 )
    {
        solve_for_level($l);
    }

    # Now let's count the number of elements in the total level.
    #
    return sum( values( %{ $levels[$total] } ) );
}

1;
