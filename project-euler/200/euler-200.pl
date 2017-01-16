#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();
use List::UtilsBy qw(min_by);

STDOUT->autoflush(1);

use File::Spec;
use File::Basename (qw( basename dirname ));
use File::Temp     (qw/ tempfile tempdir /);
use File::Path     (qw/ rmtree mkpath /);

use IO::All qw / io /;

my @primes = io('primes.txt')->chomp->getlines;

package Stream;

use integer;

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my ( $self, $args ) = @_;

    $self->{'q'} = $args->{'q'};

    $self->{'i'} = -1;

    $self->advance;

    return;
}

sub val
{
    my ($self) = @_;

    return $self->{'q'}**3 * $primes[ $self->{'i'} ]**2;
}

sub advance
{
    my ($self) = @_;

    if ( $primes[ ++$self->{'i'} ] == $self->{'q'} )
    {
        ++$self->{'i'};
    }

    return;
}

package main;

sub sqube_stream
{
    my @streams;

    my $new_stream = sub {
        push @streams, Stream->new( { q => $primes[ scalar @streams ] } );
    };
    $new_stream->();

    return sub {
        my $idx = min_by { $streams[$_]->val } keys @streams;
        if ( $idx == $#streams )
        {
            $new_stream->();
        }
        my $ret = $streams[$idx]->val;
        $streams[$idx]->advance;

        return $ret;
    };
}

my $s = sqube_stream;

say $s->() while 1;
1;
