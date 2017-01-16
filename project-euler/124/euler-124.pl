#!/usr/bin/perl

use strict;
use warnings;

use integer;
use IO::Handle;

use Data::Dumper;

use Heap::Fibonacci;

package MyHeapElem;

use parent 'Heap::Elem';

use List::Util qw(reduce);

use vars qw($a $b);

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    # set $self->{key} = $value;
    my $n = shift;

    $self->{key} =
        ( reduce { $a * $b } 1, ( map { $_->[0] } @{ ::factorize($n) } ) );
    $self->{n} = $n;

    return $self;
}

sub cmp
{
    my $self  = shift;
    my $other = shift;

    return (   ( ( $self->{key} <=> $other->{key} ) )
            || ( ( $self->{n} <=> $other->{n} ) ) );
}

sub val
{
    my $self = shift;

    if (@_)
    {
        $self->{val} = shift;
    }

    return $self->{val};
}

sub heap
{
    my $self = shift;

    if (@_)
    {
        $self->{heap} = shift;
    }

    return $self->{heap};
}

package main;

use List::Util qw(reduce sum);
STDOUT->autoflush(1);

my @Cache = ( undef, [] );

sub factorize_helper
{
    my ( $n, $start_from ) = @_;

    my $limit = int( sqrt($n) );

    if ( !defined( $Cache[$n] ) )
    {
        my $d = $n;
        while ( $d % $start_from )
        {
            if ( ++$start_from > $limit )
            {
                return $Cache[$n] = [ [ $n, 1 ] ];
            }
        }

        $d /= $start_from;

        my @n_factors =
            ( map { [@$_] } @{ factorize_helper( $d, $start_from ) } );

        if ( @n_factors && $n_factors[0][0] == $start_from )
        {
            $n_factors[0][1]++;
        }
        else
        {
            unshift @n_factors, ( [ $start_from, 1 ] );
        }

        $Cache[$n] = \@n_factors;
    }
    return $Cache[$n];
}

sub factorize
{
    my ($n) = @_;
    return factorize_helper( $n, 2 );
}

# use vars qw($a $b);

my $heap = Heap::Fibonacci->new;

my $REQUIRED_K = 10_000;
my $LIMIT      = 100_000;
for my $n ( 1 .. $REQUIRED_K )
{
    print "Reached $n\n" if ( $n % 1_000 == 0 );
    $heap->add( MyHeapElem->new($n) );
}

for my $n ( $REQUIRED_K + 1 .. $LIMIT )
{
    print "Reached $n\n" if ( $n % 1_000 == 0 );
    $heap->add( MyHeapElem->new($n) );

    # print "Extracted: ", $heap->extract_top()->{n}, "\n";
}

for my $i ( 1 .. $REQUIRED_K - 1 )
{
    print "Reached $i\n" if ( $i % 1_000 == 0 );
    $heap->extract_top();
}

print "\nFound: ", $heap->extract_top->{n}, "\n";

