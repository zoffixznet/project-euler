package Euler303_Take1;

use strict;
use warnings;

use integer;
use bytes;

use parent 'Exporter';

our @EXPORT_OK = (qw(f_div f_complete));

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub f_div_9999_try_pos
{
    my ( $n, $count_2 ) = @_;

    my $f = "2222" x $count_2;

    my $digits_sum = 2 * 4 * $count_2;

    while ( !length($f) || ( $digits_sum % 9 != 0 ) )
    {
        $f = "1111" . $f;
        $digits_sum += 4;
    }

    if ( ( 0 + $f ) % $n != 0 )
    {
        die "Fail $n $count_2!";
    }
    return ( ( 0 + $f ) / $n );
}

sub f_div_9999
{
    my ($n) = @_;

    return min( map { f_div_9999_try_pos( $n, $_ ) } 0 .. 9 );
}

sub f_div
{
    my ($n) = @_;

    # Special case because it's too slow and memory hungry.
    if ( $n == 9_999 )
    {
        return f_div_9999($n);
    }

    my $digit = 1;

    my $prev_place_products = [];
    my $tens                = 10;
    for my $d ( 1 .. 9 )
    {
        my $prod = $d * $n;
        if ( ( $prod % 10 ) <= 2 )
        {
            if ( $prod !~ /[^012]/ )
            {
                return $d;
            }
            push @$prev_place_products, [ $d, ( $prod / 10 ) ];
        }
    }

    while (1)
    {
        my $next_place_products = [];

        my $d_tens = 0;
        my $d_n    = 0;
        for my $d ( 0 .. 9 )
        {
            for my $p (@$prev_place_products)
            {
                my ( $prev_factor, $mod ) = @$p;
                my $prod = $d_n + $mod;

                if ( ( $prod % 10 ) <= 2 )
                {
                    my $factor = $d_tens + $prev_factor;
                    if ( $prod !~ /[^012]/ )
                    {
                        return $factor;
                    }
                    push @$next_place_products, [ $factor, $prod / 10 ];
                }
            }
        }
        continue
        {
            $d_tens += $tens;
            $d_n    += $n;
        }
        $prev_place_products = $next_place_products;
    }
    continue
    {
        $digit++;
        $tens *= 10;
    }
}

sub f_complete
{
    my ($n) = @_;

    return f_div($n) * $n;
}

1;
