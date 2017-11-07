use strict;
use warnings;

package MySvg;

use MooX qw/ late /;
use SVG;
use IO::All qw/ io /;

has svg => ( is => 'rw' );

sub BUILD
{
    my ($self) = @_;

    $self->svg( SVG->new( width => 400, height => 400 ) );
    $self->svg->rect(
        x      => 0,
        y      => 0,
        width  => 400,
        height => 400,
        style  => { fill => 'white' }
    );

    $self->circle( 0,   0 );
    $self->circle( 100, 0 );

    foreach my $i ( 0 .. 5 )
    {
        my $x = 50 - ( $i - 2.5 ) * sqrt(2) * 10;
        my $y = 0;
        $self->line( $x - 200, $y - 200, $x + 200, $y + 200, 'black' );
    }
    return;
}

sub display
{
    my ($self) = @_;

    my $fn = './e607.svg';

    io->file($fn)->utf8->print( $self->svg->xmlify );

    system( "gwenview", $fn );

    return;
}

sub line
{
    my ( $self, $x1, $y1, $x2, $y2, $color ) = @_;

    $self->svg->line(
        x1    => $self->trans_x($x1),
        x2    => $self->trans_x($x2),
        y1    => $self->trans_y($y1),
        y2    => $self->trans_y($y2),
        style => { stroke => $color, 'stroke-width' => 2 },
    );

    return;
}

sub trans_x
{
    my ( $self, $x ) = @_;

    return $x + 200;
}

sub trans_y
{
    my ( $self, $y ) = @_;

    return 200 - $y;
}

sub circle
{
    my ( $self, $x, $y ) = @_;

    $self->svg->circle(
        cx    => $self->trans_x($x),
        cy    => $self->trans_y($y),
        r     => 5,
        style => { fill => 'black' }
    );

    return;
}

package main;

use strict;
use warnings;

use 5.016;

use Math::Trig;

sub dist
{
    my ( $p1, $p2 ) = @_;

    return sqrt( ( $p1->[0] - $p2->[0] )**2 + ( $p1->[1] - $p2->[1] )**2 );
}

sub snell
{
    my ( $deg, $v1, $v2 ) = @_;
    my $sin1 = sin( $deg + pi / 4 );
    my $sin2 = $v2 / $v1 * $sin1;
    my $deg2 = asin($sin2) -pi / 4;

    return $deg2;
}

sub intersect
{
    my ( $s1, $s2 ) = @_;

    # Both are y = f(x) so m1x+b1 == m2x+b2 ==> x
    if ( $s1->{'m'} == $s2->{'m'} )
    {
        return;
    }
    else
    {
        my $x = ( ( $s2->{'b'} - $s1->{'b'} ) / ( $s1->{'m'} - $s2->{'m'} ) );

        return [ $x, $s2->{'b'} + $s2->{'m'} * $x ];
    }
}

sub solve
{
    my ( $deg, $svg ) = @_;
    my @colors = ( 'green', 'red', 'yellow', 'purple', 'blue', 'brown' );

    my $p  = [ 0, 0 ];
    my $v1 = 10;
    my $m1 = tan($deg);
    my $m0 = 1;
    my $b1 = -( 100 - 50 * sqrt(2) ) / 2;
    my $p2 = intersect( { m => $m1, b => 0 }, { m => $m0, b => $b1 } );

    my $distance = 0;
    my $add_dist = sub {
        my ( $p, $p2, $v, $color ) = @_;
        $distance += dist( $p, $p2 ) / $v;
        $svg->line( @$p, @$p2, $color );
        return;
    };
    $add_dist->( $p, $p2, $v1, 'cyan' );
    my $b = $b1 + 0;

    my $iter = sub {
        my ( $old_v, $new_v, $ctx ) = @_;

        my $old_deg = $ctx->{deg};
        my $p2      = $ctx->{p};

        my $deg2 = snell( $old_deg, $old_v, $new_v );

        my $m2 = tan($deg2);
        $b -= 10 * sqrt(2);
        my $p3 = intersect( { m => $m2, b => ( $p2->[1] - $m2 * $p2->[0] ) },
            { m => $m0, b => $b } );

        $add_dist->( $p2, $p3, $new_v, shift @colors );
        return { p => $p3, deg => $deg2 };
    };

    my $ctx = { deg => $deg, p => $p2 };
    for my $v ( [ 10, 9 ], [ 9, 8 ], [ 8, 7 ], [ 7, 6 ], [ 6, 5 ] )
    {
        $ctx = $iter->( @$v, $ctx );
    }

    my $exit_p = $ctx->{p};
    my $DEST_X = 100;
    my $dest_p = intersect(
        { m => $m1, b => ( $exit_p->[1] - $m1 * $exit_p->[0] ) },
        { m => $m0, b => ( 0 - $m0 * $DEST_X ) },
    );
    $add_dist->( $dest_p, $exit_p, 10, 'pink' );

    my @ret = ( $distance, $dest_p->[1], $svg );
    return @ret;
}

my $low  = -pi() / 4;
my $high = pi() / 8;

my $N = 1_000;
foreach my $i ( 0 .. $N )
{
    my $svg = MySvg->new;
    say "$i ", ( solve( $low + ( $high - $low ) / $N * $i, $svg ) )[1];
}

my ( $mid, @sol );

sub recalc
{
    $mid = ( ( $low + $high ) / 2 );
    @sol = solve( $mid, MySvg->new );
    return;
}

recalc;
while ( abs( $sol[1] ) > 1e-14 )
{
    if ( $sol[1] > 0 )
    {
        $high = $mid;
    }
    else
    {
        $low = $mid;
    }
    recalc;
}

printf "sol = %.10f\n", $sol[0];
