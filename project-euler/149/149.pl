#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

STDOUT->autoflush(1);

# use integer;

# use Math::BigInt "lib" => "GMP";

package FiboRand;

sub new
{
    return bless { _k => 1, _last_nums => [] }, shift;
}

# has '_k' => (isa => 'Math::BigInt', is => 'rw', default => sub { return 1; },);
# has '_last_nums' => (isa => 'ArrayRef[Math::BigInt]', is => 'rw', default => sub { return []; },
# traits => ['Array'], handles => { _push => 'push', _shift => 'shift',},);

sub fetch
{
    my $self = shift;

    my $k = $self->{_k};
    my $s_k;

    my $ln = $self->{_last_nums};

    if ( $k <= 55 )
    {
        $s_k = ( ( ( 100003 - 200003 * $k + 300007 * ( $k**3 ) ) % 1000000 ) -
                500000 );
    }
    else
    {
        $s_k = ( ( ( $ln->[-24] + $ln->[-55] + 1000000 ) % 1000000 ) - 500000 );
        shift(@$ln);
    }
    push @$ln, $s_k;
    $self->{_k}++;

    return $s_k;
}

package main;

# Unit test to the randomizer.
{
    my $rand = FiboRand->new;

    foreach my $k ( 1 .. 100 )
    {
        print "$k = ", $rand->fetch(), "\n";
    }

    $rand = FiboRand->new;

    for my $k ( 1 .. 9 )
    {
        $rand->fetch();
    }

    if ( $rand->fetch() != -393027 )
    {
        die "Wrong s10!";
    }

    for my $k ( 11 .. 99 )
    {
        $rand->fetch();
    }

    if ( $rand->fetch() != 86613 )
    {
        die "Wrong s100!";
    }
}

package Max;

sub new
{
    return bless { _so_far => 0, _ending_here => 0 }, shift;
}

sub _max
{
    my ( $x, $y ) = @_;

    return ( $x > $y ) ? $x : $y;
}

sub add
{
    my ( $self, $n ) = @_;

    $self->{_ending_here} = _max( $self->{_ending_here} + $n, 0 );
    $self->{_so_far} = _max( $self->{_so_far}, $self->{_ending_here} );

    return;
}

sub get_max
{
    my ($self) = @_;

    return $self->{_so_far};
}

package main;

my $rand = FiboRand->new;

sub max
{
    my ( $x, $y ) = @_;

    return ( $x > $y ) ? $x : $y;
}

my $SIZE = 2_000;

my $horiz_max_max     = 0;
my @vert_max          = map { Max->new } ( 1 .. $SIZE );
my @diag_max          = map { Max->new } ( 1 .. $SIZE );
my @anti_diag_max     = map { Max->new } ( 1 .. $SIZE );
my $diag_max_max      = 0;
my $anti_diag_max_max = 0;

sub handle_row
{
    my $horiz = Max->new;

    # First row.
    foreach my $x ( 0 .. $SIZE - 1 )
    {
        my $s = $rand->fetch();

        $vert_max[$x]->add($s);
        $horiz->add($s);
        $diag_max[$x]->add($s);
        $anti_diag_max[$x]->add($s);
    }

    $horiz_max_max = max( $horiz_max_max, $horiz->get_max() );

    $diag_max_max = max( $diag_max_max, $diag_max[0]->get_max() );
    shift(@diag_max);
    push @diag_max, Max->new;

    $anti_diag_max_max =
        max( $anti_diag_max_max, $anti_diag_max[-1]->get_max() );
    pop(@anti_diag_max);
    unshift @anti_diag_max, Max->new;

    return;
}

foreach my $y ( 1 .. $SIZE )
{
    if ( $y % 100 == 0 )
    {
        print "$y\n";
    }
    handle_row();
}

sub multi_max
{
    my $aref = shift;

    my $max = 0;

    foreach my $n (@$aref)
    {
        if ( $n > $max )
        {
            $max = $n;
        }
    }
    return $max;
}

print "Result = ",
    multi_max(
    [
        $horiz_max_max, $anti_diag_max_max, $diag_max_max,
        ( map { $_->get_max() } @vert_max, @diag_max, @anti_diag_max )
    ]
    ),
    "\n";
