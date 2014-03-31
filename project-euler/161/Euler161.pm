package Euler161;

use strict;
use warnings;

use integer;
use bytes;

use List::MoreUtils qw(any firstidx);
use List::Util qw(first max);

my @shapes_strings =
(
    <<'EOF',
 ***
*XXX*
 ***
EOF
    <<'EOF',
 *
*X*
*X*
*X*
 *
EOF
    <<'EOF',
 **
*XX*
 *X*
  *
EOF
    <<'EOF',
 **
*XX*
*X*
 *
EOF
    <<'EOF',
 *
*X*
*XX*
 **
EOF
    <<'EOF',
  *
 *X*
*XX*
 **
EOF
);

sub shape_string_to_vector
{
    my ($s) = @_;
    my @mat = map { [split//] } split(/\n/, $s);

    my $max_x = max (map { scalar @$_ } @mat) - 1;
    my $leftmost_topmost_x = first { my $x = $_; any { $_->[$x] eq 'X' } @mat }  (0 .. $max_x);
    my $leftmost_topmost_y = firstidx { $_->[$leftmost_topmost_x] eq 'X' } @mat;

    my @cells_offsets = ([0,0]);
    my @neighbours_offsets;

    while (my ($y,$line) = each(@mat))
    {
        while (my ($x, $cell) = each (@$line))
        {
            if (not ($x == $leftmost_topmost_x and $y == $leftmost_topmost_y))
            {
                my @offsets = ($x-$leftmost_topmost_x, $y-$leftmost_topmost_y);
                if ($cell eq 'X')
                {
                    push @cells_offsets, \@offsets;
                }
                elsif ($cell eq '*')
                {
                    push @neighbours_offsets, \@offsets;
                }
            }
        }
    }

    return
    {
        cells => \@cells_offsets,
        neighbours => \@neighbours_offsets,
    };
}

my @shapes = map { shape_string_to_vector($_) } @shapes_strings;

sub get_shapes
{
    return \@shapes;
}

# Some routines to manipulate location vectors:
#

my $X_DIM = 9;
my $Y_DIM = 12;

sub vec_set
{
    my ($buf, $x, $y) = @_;

    if ($x < 0)
    {
        die "X $x is lower than 0.";
    }
    if ($x >= $X_DIM)
    {
        die "X $x is Bigger than $X_DIM";
    }
    if ($y < 0)
    {
        die "Y $y is lower than 0.";
    }
    if ($y >= $Y_DIM)
    {
        die "Y $y is Bigger than $Y_DIM";
    }

    vec($$buf, $y*$X_DIM+$x, 1) = 1;

    return;
}

sub vec_get
{
    my ($buf, $x, $y) = @_;

    # This is done for convenience to query external cells.
    if (($x < 0) || ($x >= $X_DIM) || ($y < 0) || ($y >= $Y_DIM))
    {
        return 0;
    }
    return vec($$buf, $y*$X_DIM+$x, 1);
}

sub get_initial_vec
{
    return '';
}

1;

