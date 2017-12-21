#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use integer;
use bytes;

use Math::BigInt try => 'GMP';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $K = 35;

sub pick_frac
{
    my ($cb) = @_;

    for my $bb ( 2 .. $K )
    {
        for my $aa ( 1 .. $bb - 1 )
        {
            $cb->( $aa, $bb );
        }
    }

    return;
}

my %sqrts;
foreach my $n ( 1 .. ( $K * 2 ) )
{
    $sqrts{ $n * $n } = $n;
}

my %found_s;
my @total_sum = ( Math::BigInt->new(0), Math::BigInt->new(1) );

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $n < $m )
    {
        return gcd( $m, $n );
    }

    if ( $m == 0 )
    {
        return $n;
    }

    return gcd( $m, $n % $m );
}

sub norm
{
    my ( $aa, $bb ) = @_;

    if ( $bb < 0 )
    {
        Carp::confess("Foo $aa/$bb");
    }

    my $g = gcd( abs($aa), abs($bb) );

    return ( $aa / $g, $bb / $g );
}

sub _add
{
    my ( $x_a, $x_b, $y_a, $y_b ) = @_;

    return norm( $x_a * $y_b + $x_b * $y_a, $x_b * $y_b );
}

sub add
{
    my @r = _add(@_);

    if ( $r[0] < 0 )
    {
        Carp::confess("glim $r[0]/$r[1]");
    }
    return @r;
}

sub check
{
    my $n  = shift;
    my @xy = @_;
    my ( $x_a, $x_b, $y_a, $y_b ) = @_;

    my @sum = add( ( $n == 1 ) ? @xy : ( map { $_ * $_ } @xy ) );

    my @z;
    if ( $n == 2 )
    {
        my $z_a = $sqrts{ $sum[0] };
        my $z_b = $sqrts{ $sum[1] };

        if ( ( !defined($z_a) ) or ( !defined($z_b) ) )
        {
            return;
        }
        @z = ( $z_a, $z_b );
    }
    else
    {
        @z = @sum;
    }

    {
        my @s;
        if ( $x_a < $x_b )
        {
            if ( $z[0] < $z[1] and $z[1] <= $K )
            {
                @s = add( add(@xy), @z );
            }
        }
        else
        {
            if ( $z[0] > $z[1] and $z[0] <= $K )
            {
                @s = add( add( $x_b, $x_a, $y_b, $y_a ), @z[ 1, 0 ] );
            }
        }

        if (@s)
        {
            my $s_str = "$s[0]/$s[1]";
            if ( !exists( $found_s{$s_str} ) )
            {
                @total_sum = add( @s, @total_sum );
                $found_s{$s_str} = 1;
            }
        }
    }

}

for my $x_b ( 2 .. $K )
{
    print "x_b=$x_b\n";
    for my $x_a ( 1 .. $x_b - 1 )
    {
        # We can assume without loss of generality that y >= x.
        for my $y_b ( $x_b .. $K )
        {
            for my $y_a ( 1 .. $y_b - 1 )
            {

                for my $n ( 1, 2 )
                {
                    check( $n, $x_a, $x_b, $y_a, $y_b );
                    check( $n, $x_b, $x_a, $y_b, $y_a );
                }
            }
        }
    }
}

print "$total_sum[0]/$total_sum[1] == @{[$total_sum[0]+$total_sum[1]]}\n";

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
