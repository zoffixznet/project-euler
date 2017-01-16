package Pentagonal;

use strict;
use warnings;

use Math::BigInt ":constant", lib => "GMP";

use base 'Exporter';

our @EXPORT = (qw(is_pentagonal));

sub new
{
    my $class = shift;
    my $self = { 'i' => 1, 'n' => 1 };
    bless $self, $class;
    return $self;
}

sub from_i
{
    my $class = shift;
    my $i     = shift;
    my $n     = ( ( $i * ( 3 * $i - 1 ) ) / 2 );
    my $self  = { i => $i, n => $n };
    bless $self, $class;
    return $self;
}

sub inc
{
    my $self = shift;

    my $new = Pentagonal->new();

    $new->{i} = $self->{i} + 1;

    $new->{n} = $self->{n} + $self->{i} * 3 + 1;

    return $new;
}

sub register
{
    my ( $self, $hash_ref ) = @_;

    $hash_ref->{ $self->{n}->bstr() } = $self->{i}->bstr();
}

my $pent_max = Pentagonal->new();
my %pents_map;
$pent_max->register( \%pents_map );

sub is_pentagonal
{
    my $num = shift;

    while ( $num > $pent_max->{n} )
    {
        # Advance both pent_max and pent_max_idx
        $pent_max = $pent_max->inc();
        $pent_max->register( \%pents_map );
    }
    return exists( $pents_map{ $num->bstr() } );
}

1;
