#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat try => 'GMP';

use List::Util qw();

package Row;

use Moose;

has 'elems' => (isa => 'ArrayRef[Math::BigRat]', is => 'rw');

sub multiply_by
{
    my ($self, $x) = @_;

    foreach my $e (@{$self->elems})
    {
        $e *= $x;
    }

    return;
}

sub as_string
{
    my $self = shift;

    return join(", ", map { $_ . "" } @{$self->elems()});
}

package Matrix;

use Moose;

has 'rows' => (isa => 'ArrayRef[Row]', is => 'rw');

sub size
{
    my ($self) = @_;

    return scalar(@{$self->rows});
}

sub eye
{
    my $package = shift;
    my $size = shift;

    return $package->new(
        {
            rows => 
            [
                map
                { 
                    my $r = $_;
                    Row->new(
                        {
                            elems =>
                            [
                                map
                                {
                                    ($_ == $r
                                        ? Math::BigRat->new(1)
                                        : Math::BigRat->new(0)
                                    )
                                }
                                (0 .. $size-1)
                            ]
                        }
                    )
                } (0 .. $size-1)
            ]
        }
    );
}

sub _swap_rows
{
    my ($self, $i, $j) = @_;

    my $rows = $self->rows();

    @{$rows}[$i,$j] = @{$rows}[$j,$i];

    return;
}

sub _multiply_row_by
{
    my ($self, $row, $x) = @_;

    $self->rows->[$row]->multiply_by($x);

    return;
}

sub _add_row_product_to_row
{
    my ($self, $row_idx, $other_row, $multiplier) = @_;
    
    foreach my $i (0 .. $self->size()-1)
    {
        my $e = $self->_elem($row_idx, $i);
        
        $e += ($multiplier * $self->_elem($other_row, $i));
    }
}

sub _elem
{
    my ($self, $r, $c) = @_;

    return $self->rows->[$r]->elems->[$c];
}

sub inv
{
    my ($self) = @_;

    my $inverted = Matrix->eye($self->size());

    my $simultaneous = sub {
        my $callback = shift;

        foreach ($self, $inverted)
        {
            $callback->($_);
        }
    };

    foreach my $col_to_stair (0 .. $self->size()-1)
    {
        my $found_row_idx =
            List::Util::first 
            {
                ! $self->_elem($_, $col_to_stair)->is_zero()
            }
            ($col_to_stair .. $self->size() - 1)
            ;

        if ($found_row_idx != $col_to_stair)
        {
            $simultaneous->(sub {
                $_->_swap_rows($col_to_stair, $found_row_idx);
                }
            );
        }

        {
            my $n = $self->_elem($col_to_stair, $col_to_stair);
            if (!$n->is_one())
            {
                $simultaneous->(
                    sub {
                        $_->_multiply_row_by($col_to_stair, 1/$n);    
                    }
                );
            }
        }

        ROW_IDX:
        foreach my $row_idx (0 .. $self->size()-1)
        {
            if ($row_idx == $col_to_stair)
            {
                next ROW_IDX;
            }

            my $x = $self->_elem($row_idx, $col_to_stair);

            if (! $x->is_zero())
            {
                $simultaneous->(
                    sub {
                        $_->_add_row_product_to_row(
                            $row_idx, $col_to_stair, -$x
                        );
                    }
                );
            }
        }
    }

    return $inverted;
}

sub as_string
{
    my $self = shift;

    return join( "", map { $_->as_string() . "\n" } @{$self->rows()});
}

package main;

use Data::Dumper;

sub _row
{
    my $elems = shift;

    return Row->new({ elems => [ map { Math::BigRat->new($_) } @{$elems}]});
}

my $mat = Matrix->new(
    {
    rows =>
    [
        _row([2,3,0]),
        _row([0,1,0]),
        _row([0,0,5]),
    ]
    }
);

print $mat->inv->as_string();
