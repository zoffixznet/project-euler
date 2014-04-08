package Euler161;

use strict;
use warnings;

use integer;
use bytes;

use List::MoreUtils qw(any firstidx);
use List::Util qw(first max min);

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

sub not_in_dims
{
    my ($x, $y) = @_;
    return (($x < 0) || ($x >= $X_DIM) || ($y < 0) || ($y >= $Y_DIM));
}

sub vec_get
{
    my ($buf, $x, $y) = @_;

    # This is done for convenience to query external cells.
    if (not_in_dims($x,$y))
    {
        return 0;
    }
    return vec($$buf, $y*$X_DIM+$x, 1);
}

sub get_initial_vec
{
    return '';
}

sub find_pos
{
    my ($buf) = @_;

    for my $x (0 .. $X_DIM-1)
    {
        for my $y (0 .. $Y_DIM-1)
        {
            if (! vec_get($buf, $x, $y))
            {
                return [$x,$y];
            }
        }
    }

    die "No empty spot.";
}

my @bufs = (+{get_initial_vec() => 1});

sub try_to_fit_shape_at_pos
{
    my ($depth, $old_buf, $count, $pos, $shape) = @_;

    my $buf = $$old_buf;

    my @coords;
    foreach my $new_offset (@{$shape->{'cells'}})
    {
        my @new_pos = ($pos->[0] + $new_offset->[0], $pos->[1] + $new_offset->[1]);
        if (not_in_dims(@new_pos) or vec_get($old_buf, @new_pos)
        )
        {
            # Cannot fit shape.
            return;
        }

        push @coords, \@new_pos;
    }

    foreach my $cell_pos (@coords)
    {
        vec_set(\$buf, @$cell_pos);
    }

    # Now let's see if the empty space in $buf is still contiguous.
    #
    foreach my $neighbour (map { [$pos->[0]+$_->[0],$pos->[1]+$_->[1]] } @{$shape->{'neighbours'}})
    {
        if ((! vec_get(\$buf, @$neighbour)) and (! not_in_dims(@$neighbour)))
        {
            my %found = (join(",", @$neighbour) => 1);
            my @queue = ($neighbour);

            my $MAX_TO_FIND = min(10, $X_DIM*$Y_DIM-3*$depth);
            while (keys(%found) < $MAX_TO_FIND and @queue)
            {
                my $p = shift(@queue);
                foreach my $dir ([0,-1],[0,1],[1,0],[-1,0])
                {
                    my $new_p = [$p->[0]+$dir->[0],$p->[1]+$dir->[1]];
                    if ((! not_in_dims(@$new_p)) and
                        (! vec_get(\$buf, @$new_p)))
                    {
                        my $new_p_token = join(",", @$new_p);
                        if (!exists($found{$new_p_token}))
                        {
                            $found{$new_p_token} = 1;
                            push @queue, $new_p;
                        }
                    }
                }
            }
            if ((! @queue) and (keys(%found) < $MAX_TO_FIND))
            {
                # There is a hole.
                return;
            }
        }
    }

    # Finally add it to the next depth.
    $bufs[$depth+1]{$buf} += $count;

    return;
}

sub handle_buf_at_depth
{
    my ($depth, $buf, $count) = @_;

    my $pos = find_pos(\$buf);

    foreach my $shape (@shapes)
    {
        try_to_fit_shape_at_pos($depth, \$buf, $count, $pos, $shape);
    }

    return
}

sub handle_depth
{
    my ($depth) = @_;

    while (my ($buf, $count) = each($bufs[$depth]))
    {
        handle_buf_at_depth($depth, $buf, $count);
    }

    return;
}

sub handle_all_depths
{
    my $MAX_DEPTH = $X_DIM*$Y_DIM/3;
    foreach my $depth (0 .. $MAX_DEPTH-1)
    {
        print "Handling depth $depth\n";
        handle_depth($depth);
    }

    if (keys(%{ $bufs[$MAX_DEPTH] }) != 1)
    {
        die "Found more than one solution.";
    }

    my ($k) = keys(%{ $bufs[$MAX_DEPTH] });
    print "Final Count is ", $bufs[$MAX_DEPTH]{$k}, "\n";

    return;
}

1;

