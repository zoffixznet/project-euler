#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

my %registry;
my @score_lists;

sub handle_final_doubles
{
    my ($results) = @_;

    foreach my $double_result ( 1 .. 20, 25 )
    {
        my $id =
            join( ',', sort { $a cmp $b } map { join( '*', @$_ ) } @$results )
            . ";$double_result*2";

        if ( !exists( $registry{$id} ) )
        {
            my $score = sum( map { $_->[0] * $_->[1] } @$results,
                [ $double_result, 2 ] );
            $registry{$id} = $score;
            push @{ $score_lists[$score] }, $id;
        }
    }
}

sub recurse
{
    my ($results) = @_;

    my $depth = @$results;

    handle_final_doubles($results);

    if ( $depth < 2 )
    {
        foreach my $multiplier ( 1 .. 3 )
        {
            foreach my $new_res ( 1 .. 20 )
            {
                recurse( [ @$results, [ $new_res, $multiplier ] ] );
            }
        }

        foreach my $multiplier ( 1 .. 2 )
        {
            recurse( [ @$results, [ 25, $multiplier ] ] );
        }
    }

    return;
}

recurse( [] );

if ( @{ $score_lists[6] } != 11 )
{
    die "Number of checkouts for 6 is not correct.";
}

print "Total = ",
    ( sum( map { scalar( @{ $_ || [] } ) } @score_lists[ 1 .. 99 ] ) ), "\n";
