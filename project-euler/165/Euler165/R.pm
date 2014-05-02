package Euler165::R;

use strict;
use warnings;

use bigrat (lib => "GMP");

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my $self = shift;

    $self->{n} = 0;
    $self->{s_n} = 290_797;

    return;
}

sub get_t
{
    my $self = shift;

    $self->{s_n} = (($self->{s_n} * $self->{s_n}) % 50_515_093);
    $self->{n}++;

    return ($self->{s_n} % 500);
}

sub get_seg
{
    my $self = shift;

    my @t;

    push @t, $self->get_t for 1 .. 4;

    return \@t;
}

1;
