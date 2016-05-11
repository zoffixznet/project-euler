package Euler424_v1;

use strict;
use warnings;

package Euler424_v1::Coord;

use Moose;

has ['x', 'y'] => (is => 'ro', isa => 'Int', required => 1);

sub next_x
{
    my $self = shift;

    return Euler424_v1::Coord->new({x => $self->x + 1, y => $self->y});
}

sub next_y
{
    my $self = shift;

    return Euler424_v1::Coord->new({x => $self->x, y => $self->y + 1});
}

package Euler424_v1::Hint;

use Moose;

has 'sum' => (is => 'rw', isa => 'Str');
has 'affected_cells' => (is => 'rw', isa => 'ArrayRef',
    default => sub { return []; });

package Euler424_v1::Cell;

use Moose;

has 'gray' => (is => 'rw', isa => 'Bool');
has ['horiz_hint', 'vert_hint'] => (is => 'rw', 'isa' => 'Maybe[Euler424_v1::Hint]');
has 'digit' => (is => 'rw', isa => 'Maybe[Str]');
has ['horiz_affecting_sum', 'vert_affecting_sum'] => (is => 'rw', 'isa' => 'Maybe[Euler424_v1::Coord]');

sub set_gray
{
    my ($self) = @_;

    $self->gray(1);
    $self->horiz_hint(undef());
    $self->vert_hint(undef());
    $self->digit(undef());

    return;
}

sub set_digit
{
    my ($self,$val) = @_;

    $self->gray(0);
    $self->digit(length$val ? $val : undef());

    return;
}

sub set_hints
{
    my ($self,$args) = @_;

    $self->gray(1);
    my $h = $args->{h};
    $self->horiz_hint(defined($h) ? Euler424_v1::Hint->new({ sum => $h }) : $h);

    my $v = $args->{v};
    $self->vert_hint(defined($v) ? Euler424_v1::Hint->new({ sum => $v }) : $v);

    return;
}


package Euler424_v1::Puzzle;

use Moose;

my $EMPTY = 0;
my $X = 1;
my $Y = 2;

my $NUM_DIGITS = 10;

has 'height' => (is => 'ro', isa => 'Int', required => 1);
has 'width' => (is => 'ro', isa => 'Int', required => 1);
has 'truth_table' => (is => 'rw', default => sub { return [map { [($EMPTY) x $NUM_DIGITS]} (1 .. $NUM_DIGITS)]; });
has 'grid' => (is => 'rw', lazy => 1, default => sub {
        my $self = shift;
        return [map { [map { Euler424_v1::Cell->new; } 1 .. $self->width] }
            1 .. $self->height
        ]
    }
);

sub cell
{
    my ($self,$coord) = @_;

    return $self->grid->[$coord->y]->[$coord->x];
}

sub populate_from_string
{
    my ($self,$s) = @_;

    $s =~ s#\r?\n?\z#,#;

    foreach my $y (0 .. $self->height - 1)
    {
        foreach my $x (0 .. $self->width - 1)
        {
            my $cell = $self->cell(Euler424_v1::Coord->new({y => $y, x => $x}));
            if ($s =~ s#\AX,##)
            {
                $cell->set_gray;
            }
            elsif ($s =~ s#\AO,##)
            {
                $cell->set_digit('');
            }
            elsif ($s =~ s#\A([A-J]),##)
            {
                $cell->set_digit($1);
            }
            elsif ($s =~ s#\A\((?:h([A-J]{1,2}))?,?(?:v([A-J]{1,2}))?\),##)
            {
                $cell->set_hints({ h => ($1 || undef()), v => ($2 || undef())});
            }
            else
            {
                die "Unknown format for string <<$s>>!";
            }
        }
    }

    if ($s ne '')
    {
        die "Junk in line - <<$s>>!";
    }
    # TODO: cross-reference the sums and the hints.
    foreach my $y (0 .. $self->height - 1)
    {
        foreach my $x (0 .. $self->width - 1)
        {
            my $coord = Euler424_v1::Coord->new({x => $x, y => $y});
            my $cell = $self->cell($coord);
            if ($cell->gray)
            {
                if (defined(my $hint = $cell->horiz_hint))
                {
                    my $next_coord = $coord->next_x;
                    NEXT_X:
                    while ($next_coord->x < $self->width)
                    {
                        my $next_cell = $self->cell($next_coord);
                        if ($next_cell->gray)
                        {
                            last NEXT_X;
                        }
                        $next_cell->horiz_affecting_sum($coord);
                        push @{$hint->affected_cells}, $next_coord;
                    }
                    continue
                    {
                        $next_coord = $next_coord->next_x;
                    }
                }
            }
        }
    }
    return;
}


1;
