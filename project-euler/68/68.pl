#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

my $max;

sub process_combination
{
    my ( $c, $allocated ) = @_;

    # print join(",", @$c), "\n";

    my @gon = ( [ @{$c}[ 5, 0, 1 ] ] );

    my $sum = sum( @{ $gon[0] } );

    foreach my $idx ( 1 .. 4 )
    {
        my @n = @{$c}[ $idx, ( $idx + 1 ) % 5 ];
        my $outer = $sum - sum(@n);

        if ( ( $outer <= 0 ) or exists( $allocated->{$outer} ) )
        {
            return;
        }
        $allocated->{$outer} = 1;
        push @gon, [ $outer, @n ];
    }

    my ($idx) = sort { $gon[$a][0] <=> $gon[$b][0] } ( 0 .. 4 );

    my $string =
        join( "", map { @$_ } @gon[ map { ( $idx + $_ ) % 5 } ( 0 .. 4 ) ] );

    if ( length($string) == 16 )
    {
        $max ||= $string;

        if ( $string gt $max )
        {
            $max = $string;
            print "New Max $max\n";
        }
    }
}

sub create_combination
{
    my ( $num_left, $combination, $allocated_numbers ) = @_;

    if ( $num_left == 0 )
    {
        process_combination( $combination, $allocated_numbers );
    }
    else
    {
        foreach my $next_num ( grep { !exists( $allocated_numbers->{$_} ) }
            1 .. 10 )
        {
            create_combination(
                $num_left - 1,
                [ @$combination, $next_num ],
                { %{$allocated_numbers}, $next_num => 1 },
            );
        }
    }
}

create_combination( 6, [], {} );

print "Max == $max\n";
