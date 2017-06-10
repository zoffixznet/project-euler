package Euler607::Seg;

use strict;
use warnings;

use Carp::Always;

use parent 'Exporter';

our $TYPE_X_ONLY = 0;
our $TYPE_XY     = 1;

our @EXPORT_OK =
    qw($TYPE_X_ONLY $TYPE_XY compile_segment intersect intersect_x);

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $m > $n )
    {
        ( $n, $m ) = ( $m, $n );
    }

    while ( $m > 0 )
    {
        ( $n, $m ) = ( $m, $n % $m );
    }

    return $n;
}

sub signed_gcd
{
    my ( $n, $m ) = @_;

    return gcd( abs($n), abs($m) );
}

sub _reduce
{
    my ( $n, $d ) = @_;

    my $g = signed_gcd( $n, $d );

    my @ret = ( $n / $g, $d / $g );

    if ( $ret[0] == 0 )
    {
        return ( 0, 1 );
    }
    elsif ( $ret[1] < 0 )
    {
        return map { -$_ } @ret;
    }
    else
    {
        return @ret;
    }
}

sub _mul
{
    my ( $x, $y ) = @_;

    return $x * $y;
}

sub _div
{
    my ( $x, $y ) = @_;

    return _mul( $x, 1 / $y );
}

sub _add
{
    my ( $x, $y ) = @_;

    return $x + $y;
}

sub _subtract
{
    my ( $x, $y ) = @_;

    return _add( $x, -$y );
}

sub _lt
{
    my ( $x, $y ) = @_;

    return ( $x->[0] * $y->[1] < $x->[1] * $y->[0] );
}

sub _lt2
{
    my ( $f, $x ) = @_;

    return ( $f->[0] < $x * $f->[1] );
}

sub _lt3
{
    my ( $x, $f ) = @_;

    return ( $f->[0] > $x * $f->[1] );
}

sub _eq
{
    my ( $x, $y ) = @_;

    return ( $x == $y );
}

sub _f
{
    return [ shift, 1 ];
}

sub compile_segment
{
    my ($L) = @_;

    my ( $x1, $y1, $x2, $y2 ) = @$L;
    my @y_s = sort { $a <=> $b } ( $y1, $y2 );

    if ( $x1 == $x2 )
    {
        if ( $y1 == $y2 )
        {
            die "Duplicate point in segment [@$L].";
        }
        return {
            t  => $TYPE_X_ONLY,
            x  => $x1,
            X  => _f($x1),
            y1 => $y_s[0],
            y2 => $y_s[-1],
        };
    }
    else
    {
        my $m = [ _reduce( $y2 - $y1, $x2 - $x1 ) ];
        my $bb = _subtract( _f($y1), _mul( $m, _f($x1) ) );
        my @x_s = sort { $a <=> $b } ( $x1, $x2 );
        return {
            t  => $TYPE_XY,
            m  => $m,
            b  => $bb,
            x1 => $x_s[0],
            x2 => $x_s[-1],
            y1 => $y_s[0],
            y2 => $y_s[-1],
        };
    }
}

sub intersect_x
{
    my ( $s1, $s2 ) = @_;
    my ( $X,  $x )  = @$s1{qw(X x)};

    my $y = _add( _mul( $s2->{'m'}, $X ), $s2->{'b'} );

    return [ $X, $y ];
}

sub intersect
{
    my ( $s1, $s2 ) = @_;

    # Both are y = f(x) so m1x+b1 == m2x+b2 ==> x
    if ( _eq( $s1->{'m'}, $s2->{'m'} ) )
    {
        return;
    }
    else
    {
        my $x = _div(
            _subtract( $s2->{'b'}, $s1->{'b'} ),
            _subtract( $s1->{'m'}, $s2->{'m'} )
        );

        return [ $x, _add( $s2->{'b'}, _mul( $s2->{'m'}, $x ) ) ];
    }
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

sub solve
{
    my ($deg) = @_;

    # say "Deg=$deg";

    my $p  = [ 0, 0 ];
    my $v1 = 10;
    my $m1 = tan($deg);
    my $m0 = 0.5;
    my $b1 = -( 100 - 50 * sqrt(2) ) / 2;
    my $p2 = Euler607::Seg::intersect( { m => $m1, b => 0 },
        { m => $m0, b => $b1 } );

    # say "@$p2";

    my $distance = 0;
    $distance += dist( $p, $p2 ) / $v1;

    my $b = $b1 + 0;

    my $to_add = 1;
    my $iter   = sub {
        my ( $old_v, $new_v, $old_deg, $p2 ) = @_;

        my $deg2 = snell( $old_deg, $old_v, $new_v );
        my $m2 = tan($deg2);
        $b -= 10 * sqrt(2);
        my $p3 = Euler607::Seg::intersect(
            { m => $m2, b => ( $p2->[1] - $m2 * $p2->[0] ) },
            { m => $m0, b => $b } );

        # say "@$p3";
        if ($to_add)
        {
            $distance += dist( $p2, $p3 ) / $old_v;
        }
        return ( $p3, $m2, $deg2 );
    };

    my ( $p3, $m2, $deg2 ) = $iter->( 9, 8,  $deg,  $p2 );
    my ( $p4, $m3, $deg3 ) = $iter->( 8, 7,  $deg2, $p3 );
    my ( $p5, $m5, $deg4 ) = $iter->( 7, 6,  $deg3, $p4 );
    my ( $p6, $m6, $deg5 ) = $iter->( 6, 5,  $deg4, $p5 );
    my ( $p7, $m7, $deg6 ) = $iter->( 5, 10, $deg5, $p6 );

    my $x8 = 100;
    my $y8 = $p7->[1] + $m7 * ( $x8 - $p7->[0] );

    $distance += dist( [ $x8, $y8 ], $p7 ) / 10;

    my @ret = ( $distance, $y8 );

    # say "Ret=@ret";
    # say '==========';
    return @ret;
}

my $low = -pi() / 4;
solve($low);
my $high = pi() / 8;

my $N = 1_000;
foreach my $i ( 0 .. $N )
{
    say "$i ", ( solve( $low + ( $high - $low ) / $N * $i ) )[1];
}
exit;

my ( $mid, @sol );

sub recalc
{
    $mid = ( ( $low + $high ) / 2 );
    @sol = solve($mid);
    return;
}
recalc;
while ( abs( $sol[1] ) > 1e-12 )
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
