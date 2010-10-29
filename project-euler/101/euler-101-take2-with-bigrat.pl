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

sub inv
{
    my ($self) = @_;

    my $inverted = Matrix->eye($self->size());

    foreach my $col_to_stair (0 .. $self->size()-1)
    {
        my $found_row_idx =
            List::Util::first 
            {
                ! $self->rows->[$_]->elems->[$col_to_stair]->is_zero()
            }
            ($col_to_stair .. $self->size() - 1)
            ;

        if ($found_row_idx != $col_to_stair)
        {
            $self->_swap_rows($col_to_stair, $found_row_idx);
            $inverted->_swap_rows($col_to_stair, $found_row_idx);
        }

        {
            my $n = $self->rows->[$col_to_stair]->elems->[$col_to_stair];
            if (!$n->is_one())
            {
                $self->_multiply_row_by($col_to_stair, 1/$n);
                $inverted->_multiply_row_by($col_to_stair, 1/$n);
            }
        }
    }
}

