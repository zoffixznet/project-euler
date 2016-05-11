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
has ['x_hint', 'y_hint'] => (is => 'rw', 'isa' => 'Maybe[Euler424_v1::Hint]');
has 'digit' => (is => 'rw', isa => 'Maybe[Str]');
has ['x_affecting_sum', 'y_affecting_sum'] => (is => 'rw', 'isa' => 'Maybe[Euler424_v1::Coord]');

sub set_gray
{
    my ($self) = @_;

    $self->gray(1);
    $self->x_hint(undef());
    $self->y_hint(undef());
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
    $self->x_hint(defined($h) ? Euler424_v1::Hint->new({ sum => $h }) : $h);

    my $v = $args->{v};
    $self->y_hint(defined($v) ? Euler424_v1::Hint->new({ sum => $v }) : $v);

    return;
}


package Euler424_v1::Puzzle;

use Moose;

my $EMPTY = 0;
my $X = 1;
my $Y = 2;

my $NUM_DIGITS = 10;

has _found_letters => (is => 'ro', isa => 'HashRef', default => sub { return +{}; });
has _queue => (is => 'ro', isa => 'ArrayRef', default => sub { return []; });
has 'y_lim' => (is => 'ro', isa => 'Int', required => 1);
has 'x_lim' => (is => 'ro', isa => 'Int', required => 1);
has 'truth_table' => (is => 'rw', default => sub { return [map { [($EMPTY) x $NUM_DIGITS]} (1 .. $NUM_DIGITS)]; });
has 'grid' => (is => 'rw', lazy => 1, default => sub {
        my $self = shift;
        return [map { [map { Euler424_v1::Cell->new; } 1 .. $self->x_lim] }
            1 .. $self->y_lim
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

    $self->loop(sub {
            my (undef, $cell) = @_;

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
    );

    if ($s ne '')
    {
        die "Junk in line - <<$s>>!";
    }
    $self->loop(sub {
            my ($coord, $cell) = @_;
            if ($cell->gray)
            {
                foreach my $dir (qw(x y))
                {
                    my $hint_meth = $dir . '_hint';
                    if (defined(my $hint = $cell->$hint_meth))
                    {
                        my $next_meth = 'next_' . $dir;
                        my $next_coord = $coord->$next_meth;
                        my $lim = $dir . '_lim';
                        my $sum_meth = $dir . '_affecting_sum';
                        NEXT_X:
                        while ($next_coord->$dir < $self->$lim)
                        {
                            my $next_cell = $self->cell($next_coord);
                            if ($next_cell->gray)
                            {
                                last NEXT_X;
                            }
                            $next_cell->$sum_meth($coord);
                            push @{$hint->affected_cells}, $next_coord;
                        }
                        continue
                        {
                            $next_coord = $next_coord->$next_meth;
                        }
                    }
                }
            }
        }
    );
    return;
}

use List::Util qw/ max min /;
use List::MoreUtils qw/ none /;

sub loop
{
    my ($self, $cb) = @_;

    foreach my $y (0 .. $self->y_lim - 1)
    {
        foreach my $x (0 .. $self->x_lim - 1)
        {
            my $coord = Euler424_v1::Coord->new({x => $x, y => $y});
            $cb->($coord, $self->cell($coord));
        }
    }
    return;
}

use v5.16;

sub solve
{
    my $self = shift;

    my %already_handled;

    my $run_once = 1;

    MAIN:
    while ($run_once ||
        (
            (keys (%{$self->_found_letters}) != 10)
        )
    )
    {
        $run_once = 0;
        $self->loop(sub {
                my (undef, $cell) = @_;
                if ($cell->gray)
                {
                    foreach my $dir (qw(x y))
                    {
                        my $hint_meth = $dir . '_hint';
                        if (defined(my $hint = $cell->$hint_meth))
                        {
                            my $sum = $hint->sum;
                            if (my ($letter) = $sum =~ /\A([A-J])/)
                            {
                                if (exists $already_handled{$letter})
                                {
                                    die "Twilly";
                                }
                                my $l_i = ord($letter)-ord('A');
                                my $len = length($sum);
                                my $cells_count = scalar @{$hint->affected_cells};

                                my $min_val =
                                (
                                    ((1 + $cells_count)*$cells_count)
                                    >> 1
                                );

                                my $min = $len == 2 ? max(1, int ( $min_val / 10)) : min(9, $min_val);
                                my $max =
                                (
                                    ((9 + 9 - $cells_count + 1)*$cells_count)
                                    >> 1
                                );
                                if (length$max == $len)
                                {
                                    $max = substr($max, 0, 1);
                                }
                                else
                                {
                                    $max = 9;
                                }
                                print "Matching $letter [$min..$max]\n";

                                if ($min == $max)
                                {
                                    my $digit = $min;

                                    $already_handled{$letter} = 1;
                                    $self->_mark_as_yes($l_i, $digit);


                                    # A sanity check.
                                    if (0)
                                    {
                                        foreach my $row (@{$self->grid})
                                        {
                                            foreach my $c (@$row)
                                            {
                                                if ($c->gray)
                                                {
                                                    foreach my $dir (qw(x y))
                                                    {
                                                        my $hint_meth = $dir . '_hint';
                                                        if (defined(my $hint = $c->$hint_meth))
                                                        {
                                                            if ($hint->sum =~ /$letter/)
                                                            # if ($hint->sum =~ /B/)
                                                            {
                                                                die "Foobar";
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        print "Sanity check ok.\n";
                                    }
                                }
                                else
                                {
                                    my %l = (map { $_ => 1 } $min .. $max);

                                    foreach my $d (0 .. 9)
                                    {
                                        if (!exists $l{$d})
                                        {
                                            $self->_mark_as_not($l_i, $d);
                                        }
                                    }
                                }
                                if ($len == 1)
                                {
                                    my $partial_sum = 0;
                                    foreach my $c_ (map { $self->cell($_) } @{$hint->affected_cells})
                                    {
                                        if (defined (my $d_ = $c_->digit))
                                        {
                                            my $d2;
                                            if ($d_ =~ /\A[0-9]\z/)
                                            {
                                                $d2 = $d_;
                                            }
                                            else
                                            {
                                                my $l_i = ord($d_)-ord('A');
                                                V:
                                                foreach my $v (0 .. 9)
                                                {
                                                    if ($self->truth_table->[$l_i]->[$v] == $EMPTY)
                                                    {
                                                        $d2 = $v;
                                                        last V;
                                                    }
                                                }
                                            }
                                            $partial_sum += $d2;
                                        }
                                    }
                                    my %l = (map { $_ => 1 } $partial_sum+1 .. $max);

                                    foreach my $d (0 .. 9)
                                    {
                                        if (!exists $l{$d})
                                        {
                                            $self->_mark_as_not($l_i, $d);
                                        }
                                    }

                                }
                            }
                        }
                    }
                }
            }
        );

        if (! @{$self->_queue})
        {
            last MAIN;
        }
        while (defined (my $task = shift(@{$self->_queue})))
        {
            if ($task->{type} eq '_mark_as_yes')
            {
                $self->_mark_as_yes($task->{l}, $task->{d});
            }
            else
            {
                die "Unknown task type";
            }
        }
    }

    # Output the current layout:
    use Text::Table;

    my $tb = Text::Table->new((map { ; "Col", \' | '; } 2 .. $self->x_lim), "Col");

    my $transform = sub {
        my $item = shift;

        if (! defined($item)) {
            return '';
        }
        elsif (ref$item eq '') {
            return $item =~ s#([A-J])#
                my $l = $1;
                my $l_i = ord($l)-ord('A');
                "{$l=[" . join('', grep { $self->truth_table->[$l_i]->[$_] == $EMPTY } 0 .. 9) . "]}"
            #egr;
        }
        elsif ($item->can('sum')) {
            return __SUB__->($item->sum);
        }
        else
        {
            die "PinkiePie";
        }
    };
    $tb->load(
        map
        {
            my $y = $_;
            [ map {
                    my $x = $_;
                    my $coord = Euler424_v1::Coord->new({x => $x, y => $y});
                    my $cell = $self->cell($coord);
                    $cell->gray ? $transform->($cell->y_hint) . " \\ " . $transform->($cell->x_hint) : $transform->($cell->digit);
                } 0 .. $self->x_lim - 1
            ],
        }
        (0 .. $self->y_lim-1)
    );

    print "Current State == <<\n$tb\n>>\n";

    return;
}

sub _enqueue
{
    my ($self, $task) = @_;

    push @{$self->_queue}, $task;

    return;
}


sub _mark_as_not
{
    my ($self, $l_i, $d) = @_;

    my $v_ref = \($self->truth_table->[$l_i]->[$d]);
    if ($$v_ref == $X)
    {
        return;
    }

    $$v_ref = $X;

    {
        my @digit_opts = (grep { $self->truth_table->[$_]->[$d] == $EMPTY } 0 .. 9);
        print "Remaining values for digit=$d : " , (join ',', @digit_opts), "\n";
        if (@digit_opts == 1 and none { $self->truth_table->[$_]->[$d] == $Y } 0 .. 9)
        {
            $self->_enqueue({ type => '_mark_as_yes', d => $d, l => $digit_opts[0]});
        }
    }
    {
        my @letter_opts = (grep { $self->truth_table->[$l_i]->[$_] == $EMPTY } 0 .. 9);
        print "Remaining values for letter=$l_i : " , (join ',', @letter_opts),
        "\n";

        if (@letter_opts == 1 and none { $self->truth_table->[$l_i]->[$_] == $Y } 0 .. 9)

        {
            $self->_enqueue({ type => '_mark_as_yes', d => $letter_opts[0], l => $l_i});
        }
    }

    return;
}

sub _mark_as_yes
{
    my ($self, $l_i, $digit) = @_;

    my $letter = chr(ord('A') + $l_i);
    my $v_ref = \($self->truth_table->[$l_i]->[$digit]);
    if ($$v_ref == $Y)
    {
        return;
    }
    print "Matching $letter=$digit\n";
    $$v_ref = $Y;
    $self->_found_letters->{$l_i} = $digit;

    foreach my $d (0 .. 9)
    {
        if ($d != $digit)
        {
            $self->_mark_as_not($l_i, $d);
        }
        if ($d != $l_i)
        {
            $self->_mark_as_not($d, $digit);
        }
    }

    $self->loop(
        sub {
            my (undef,$c) = @_;
            if ($c->gray)
            {
                foreach my $dir (qw(x y))
                {
                    my $hint_meth = $dir . '_hint';
                    if (defined(my $hint = $c->$hint_meth))
                    {
                        $hint->sum(
                            $hint->sum =~ s#\Q$letter\E#$digit#gr
                        );
                    }
                }
            }
            else
            {
                if (defined $c->digit)
                {
                    $c->digit(
                        $c->digit =~ s#\Q$letter\E#$digit#gr
                    );
                }
            }
            return;
        },
    );

    return;
}

1;