#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP;

use 5.016;

package Poly;

use Moose;

has 'coeffs' => ( is => 'ro', 'isa' => 'ArrayRef[Math::GMP]' );

sub inc
{
    my ($self) = @_;

    return Poly->new(
        {
            coeffs =>
                [ $self->coeffs->[0] + $self->coeffs->[1], $self->coeffs->[1] ]
        }
    );
}

sub double
{
    my ($self) = @_;

    return Poly->new(
        { coeffs => [ $self->coeffs->[0], $self->coeffs->[1] * 2 ] } );
}

package ApplyF;

use Moose;

has 'p' => ( is => 'ro', 'isa' => 'Poly' );

sub inc
{
    my ($self) = @_;
    return ApplyF->new( { p => $self->p->inc } );
}

sub double
{
    my ($self) = @_;
    return ApplyF->new( { p => $self->p->double } );
}

package MultF;

use Moose;

has 'apply' => ( is => 'ro', isa => 'ApplyF' );
has 'mult'  => ( is => 'ro', isa => 'Math::GMP' );

sub inc
{
    my ($self) = @_;
    return MultF->new( { apply => $self->apply->inc, mult => $self->mult } );
}

sub double
{
    my ($self) = @_;
    return MultF->new( { apply => $self->apply->double, mult => $self->mult } );
}

package Euler_463_v2;

use Moose;

my %cache;
{
    my $mult  = Math::GMP->new('4');
    my @polys = (
        MultF->new(
            {
                mult  => Math::GMP->new('6'),
                apply => ApplyF->new(
                    {
                        p => Poly->new(
                            {
                                coeffs =>
                                    [ Math::GMP->new(1), Math::GMP->new(2) ]
                            }
                        )
                    }
                )
            }
        ),
        MultF->new(
            {
                mult  => Math::GMP->new(-2),
                apply => ApplyF->new(
                    {
                        p => Poly->new(
                            {
                                coeffs =>
                                    [ Math::GMP->new(0), Math::GMP->new(1) ]
                            }
                        )
                    }
                )
            }
        ),
    );

    %cache = ( "$mult" => \@polys );
}

sub lookup_proto
{
    my ( $self, $mult ) = @_;

    return $cache{"$mult"} //= sub {
        my @polys     = @{ $self->lookup_proto( $mult >> 1 ) };
        my @extend    = ( map { $_->inc } @polys );
        my @new_polys = map { $_->double } ( @polys, @extend );

        my $x2_p_1_coeff = Math::GMP->new(0);
        my $x_coeff      = Math::GMP->new(0);
        foreach my $p (@new_polys)
        {
            my $m = $p->mult;
            my @c = @{ $p->apply->p->coeffs };

            while ( $c[1] > 1 and $c[0] % 2 == 0 )
            {
                foreach my $x (@c)
                {
                    $x >>= 1;
                }
            }

            if ( not exists { 1 => 1, 2 => 1, 4 => 1 }->{ $c[1] } )
            {
                die "Dont know how to handle.";
            }
            if ( $c[1] == 1 )
            {
                if ( $c[0] != 0 )
                {
                    die "Dont know how to handle.";
                }
                $x_coeff += $m;
            }
            elsif ( $c[1] == 2 )
            {
                if ( $c[0] != 1 )
                {
                    die "Dont know how to handle.";
                }
                $x2_p_1_coeff += $m;
            }
            elsif ( $c[1] == 4 )
            {
                if ( $c[0] == 1 )
                {
                    $x2_p_1_coeff += ( $m << 1 );
                    $x_coeff -= $m;
                }
                elsif ( $c[0] == 3 )
                {
                    $x2_p_1_coeff += ( $m * 3 );
                    $x_coeff -= ( $m << 1 );
                }
                else
                {
                    die "Dont know how to handle.";
                }
            }
            else
            {
                die "Dont know how to handle.";
            }
        }
        @polys = (
            MultF->new(
                {
                    mult  => $x2_p_1_coeff,
                    apply => ApplyF->new(
                        {
                            p => Poly->new(
                                {
                                    coeffs => [
                                        Math::GMP->new(1), Math::GMP->new(2)
                                    ]
                                }
                            )
                        }
                    )
                }
            ),
            MultF->new(
                {
                    mult  => $x_coeff,
                    apply => ApplyF->new(
                        {
                            p => Poly->new(
                                {
                                    coeffs => [
                                        Math::GMP->new(0), Math::GMP->new(1)
                                    ]
                                }
                            )
                        }
                    )
                }
            ),
        );

        return \@polys;
        }
        ->();
}

sub lookup
{
    my ( $self, $mult ) = @_;

    return ( map { $_->mult } @{ $self->lookup_proto($mult) } );
}

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

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
