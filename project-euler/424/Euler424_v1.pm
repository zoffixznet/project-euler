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

sub count
{
    return scalar @{shift->affected_cells};
}

package Euler424_v1::Cell;

use Moose;

has 'gray' => (is => 'rw', isa => 'Bool');
has ['x_hint', 'y_hint'] => (is => 'rw', 'isa' => 'Maybe[Euler424_v1::Hint]');
has 'digit' => (is => 'rw', isa => 'Maybe[Str]');
has 'options' => (is => 'ro', 'isa' => 'HashRef', default => sub { return +{ map { $_ => 1 } 1 .. 9 }; });

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

use KakuroPerms qw/$GENERATED_PERMS/;

sub _perms {
    my ($count, $s) = @_;

    return $GENERATED_PERMS->{$count}->{$s - $count};
}

sub _def_perms {
    return _perms(@_) || [];
}

my $EMPTY = 0;
my $X = 1;
my $Y = 2;

my $NUM_DIGITS = 10;

my $LETT_RE = qr/[A-J]/;

has _dirty => (is => 'rw', isa => 'Bool', default => sub { return 0; });
has _found_letters => (is => 'ro', isa => 'HashRef', default => sub { return +{}; });
has _found_digits => (is => 'ro', isa => 'HashRef', default => sub { return +{}; });
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
has 'output_cb' => (is => 'ro', default => sub { return sub { return; }; });

sub _out
{
    my $self = shift;

    return $self->output_cb->(@_);
}

# Calc letter index
sub _calc_l_i
{
    my ($self, $letter) = @_;

    return ord($letter) - ord('A');
}

sub cell
{
    my ($self,$coord) = @_;

    return $self->grid->[$coord->y]->[$coord->x];
}

sub populate_from_string
{
    my ($self,$s) = @_;

    $s =~ s#\r?\n?\z#,#;

    my $_process_hint = sub {
        my $hint = shift;
        if (defined($hint))
        {
            $self->_enqueue({ type => '_mark_as_not', d => 0, l => $self->_calc_l_i(substr($hint, 0, 1))});
        }
        return $hint;
    };

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
            elsif ($s =~ s#\A($LETT_RE),##)
            {
                $cell->set_digit($_process_hint->($1));
            }
            elsif ($s =~ s#\A\((?:h((?:$LETT_RE){1,2}))?,?(?:v((?:$LETT_RE){1,2}))?\),##)
            {
                my $h = $1;
                my $v = $2;
                $cell->set_hints(
                    {
                        h => $_process_hint->($h || undef()),
                        v => $_process_hint->($v || undef())
                    }
                );
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
    $self->hint_loop(
        sub {
            my ($args) = @_;
            my $coord = $args->{coord};
            my $dir = $args->{dir};
            my $hint = $args->{hint};
            my $next_meth = 'next_' . $dir;
            my $next_coord = $coord->$next_meth;
            my $lim = $dir . '_lim';
            NEXT_X:
            while ($next_coord->$dir < $self->$lim)
            {
                my $next_cell = $self->cell($next_coord);
                if ($next_cell->gray)
                {
                    last NEXT_X;
                }
                push @{$hint->affected_cells}, $next_coord;
            }
            continue
            {
                $next_coord = $next_coord->$next_meth;
            }
            return;
        },
    );
    return;
}

use List::Util qw/ first max min sum /;
use List::MoreUtils qw/ any none uniq /;

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

sub hint_loop
{
    my ($self, $cb) = @_;

    $self->loop(
        sub {
            my ($coord, $cell) = @_;
            if ($cell->gray)
            {
                foreach my $dir (qw(x y))
                {
                    my $hint_meth = $dir . '_hint';
                    if (defined(my $hint = $cell->$hint_meth))
                    {
                        $cb->(
                            {
                                cell => $cell,
                                coord => $coord,
                                dir => $dir,
                                hint => $hint,
                                sum => $hint->sum,
                            }
                        );
                    }
                }
            }
        }
    );
    return;
}


use v5.16;

sub _process_queue
{
    my ($self) = @_;

    while (defined (my $task = shift(@{$self->_queue})))
    {
        if ($task->{type} eq '_mark_as_yes')
        {
            $self->_mark_as_yes($task->{l}, $task->{d});
        }
        elsif ($task->{type} eq '_mark_as_not')
        {
            $self->_mark_as_not($task->{l}, $task->{d});
        }
        else
        {
            die "Unknown task type";
        }
    }

    return;
}

sub _mark_as_dirty
{
    my $self = shift;

    $self->_dirty(1);

    # $self->_output_layout;

    return;
}

my $DIGIT_RE = qr/[0-9]/;

sub _is_digit
{
    return shift =~ /\A$DIGIT_RE\z/;
}

sub _is_numeric
{
    return shift =~ /\A(?:$DIGIT_RE)+\z/;
}

sub _hint_cells
{
    my ($self, $hint) = @_;
    return map { $self->cell($_) } @{$hint->affected_cells};
}

sub _combine_bitmasks
{
    my $ret = 0;
    foreach my $b (@_)
    {
        $ret |= $b;
    }
    return $ret;
}
sub solve
{
    my $self = shift;

    $self->_output_layout;

    my %already_handled;

    # So it will run the first time.
    $self->_dirty(1);

    MAIN:
    while ( (keys (%{$self->_found_letters}) < 10) and $self->_dirty )
    {
        $self->_dirty(0);

        $self->_process_queue;

        $self->hint_loop(
            sub {
                my ($args) = @_;
                my $hint = $args->{hint};
                my $sum = $args->{sum};
                my $letter;
                my $digit;
                if (($letter) = $sum =~ /\A($LETT_RE)/)
                {
                    my $cells_count = $hint->count;
                    my $max =
                    (
                        ((9 + 9 - $cells_count + 1)*$cells_count)
                        >> 1
                    );
                    my $l_i = $self->_calc_l_i($letter);
                    if (my ($other_letter) = $sum =~ /\A.($LETT_RE)\z/)
                    {
                        my $max_digit = $self->_max_lett_digit($letter);
                        my $min_other = $self->_min_lett_digit($other_letter);
                        if ($max < $max_digit . $min_other)
                        {
                            $self->_mark_as_not($l_i, $max_digit);
                        }
                    }
                    if (exists $already_handled{$letter})
                    {
                        die "Twilly";
                    }
                    my $len = length($sum);

                    my $min_val =
                    (
                        ((1 + $cells_count)*$cells_count)
                        >> 1
                    );

                    my $min = $len == 2 ? max(1, int ( $min_val / 10)) : min(9, $min_val);
                    if (length$max == $len)
                    {
                        my $max_digit = $self->_max_lett_digit($letter);
                        my $new_sum = $sum =~ s#\Q$letter\E#$max_digit#gr;
                        my $new_max = substr($max, 0, 1);
                        if ($new_sum !~ /$LETT_RE/ and $new_max eq substr($new_sum, 0, 1) and $max < $new_sum)
                        {
                            $new_max--;
                        }
                        $max = $new_max;
                    }
                    else
                    {
                        $max = $self->_max_lett_digit($letter);
                    }
                    $self->_out("Matching $letter [$min..$max]\n");

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
                            $self->_out("Sanity check ok.\n");
                        }
                    }
                    else
                    {
                        $self->_mark_as_not_out_of_range(
                            $l_i, $min, $max
                        );
                    }

                    if ($len == 1)
                    {
                        $self->_process_partial_sum(
                            {
                                hint => $hint,
                                max => $max,
                            }
                        );
                    }
                }
                elsif (($digit, $letter) = $sum =~ /\A($DIGIT_RE)($LETT_RE)\z/)
                {
                    my $cells_count = $hint->count;
                    my $partial_sum = 0;
                    foreach my $c_ ($self->_hint_cells($hint))
                    {
                        if (defined (my $d_ = $c_->digit))
                        {
                            if (_is_digit($d_))
                            {
                                $cells_count--;
                                $partial_sum += $d_;
                            }
                        }
                    }
                    my $max = $partial_sum +
                    (
                        ((9 + 9 - $cells_count + 1)*$cells_count)
                        >> 1
                    );

                    if ($max % 10 == 0)
                    {
                        if ($max == ($sum =~ s#\Q$letter\E#0#gr))
                        {
                            $self->_mark_as_yes($self->_calc_l_i($letter), 0);
                        }
                    }
                    else
                    {
                        if (int($max / 10) == $digit)
                        {
                            $self->_mark_as_not_out_of_range(
                                $self->_calc_l_i($letter),
                                0,
                                $max % 10
                            );
                        }
                    }
                }
                elsif (_is_numeric($sum))
                {
                    $self->_process_partial_sum(
                        {
                            hint => $hint,
                            max => $sum,
                        }
                    );
                }
                {
                    my $total = 0;
                    foreach my $sum (@{ $self->_get_possible_sums($sum)})
                    {
                        my @partial_sums = ($sum);
                        my $bitmask = 0;
                        my $empty_count = $hint->count;
                        foreach my $c_ ($self->_hint_cells($hint))
                        {
                            if (defined (my $d_ = $c_->digit))
                            {
                                if (_is_digit($d_))
                                {
                                    @partial_sums = ( map {$_-$d_} @partial_sums);
                                    $bitmask |= (1 << ($d_ - 1));
                                    $empty_count--;
                                }
                                else
                                {
                                    my @d = @{ $self->_lett_digits($d_) };
                                    @partial_sums = uniq( sort {$a <=> $b} (map { my $s = $_; map {$s - $_ } @d } @partial_sums));
                                    $empty_count--;
                                }
                            }
                        }
                        foreach my $partial_sum (@partial_sums)
                        {
                            $total |= _combine_bitmasks(grep { !($bitmask & $_) } @{_def_perms($empty_count, $partial_sum)});
                        }
                    }
                    foreach my $c_ ($self->_hint_cells($hint))
                    {
                        if (!defined ($c_->digit))
                        {
                            foreach my $d (1 .. 9)
                            {
                                if (!($total & (1 << ($d - 1))))
                                {
                                    $self->_remove_cell_digit_opt($c_, $d);
                                }
                            }
                        }
                    }
                }

                {
                    my $max_sum = $sum;
                    $max_sum =~ s#($LETT_RE)#$self->_max_lett_digit($1)#eg;
                    $max_sum =~ s#\A0#1#;

                    my $min_sum = $sum;
                    $min_sum =~ s#($LETT_RE)#$self->_min_lett_digit($1)#eg;

                    my @empty;
                    my $partial_sum = 0;
                    my $max_partial_sum = 0;
                    my $min_partial_sum = 0;
                    foreach my $c_ ($self->_hint_cells($hint))
                    {
                        if (defined (my $d_ = $c_->digit))
                        {
                            if (_is_digit($d_))
                            {
                                $partial_sum += $d_;
                                $max_partial_sum += $d_;
                                $min_partial_sum += $d_;
                            }
                            else
                            {
                                $partial_sum += $self->_min_lett_digit($d_);
                                $max_partial_sum += $self->_max_lett_digit($d_);
                                $min_partial_sum += $self->_min_lett_digit($d_);
                            }
                        }
                        else
                        {
                            my @k = sort {$a <=> $b } keys %{$c_->options};
                            # if (@k == 9)
                            if (1)
                            {
                                push @empty, $c_;
                                $max_partial_sum += $k[-1];
                                $min_partial_sum += $k[0];
                            }
                            else
                            {
                                $partial_sum += $k[0];
                            }
                        }
                    }

                    if (@empty == 1 and $partial_sum < $max_sum)
                    {
                        foreach my $c_ (@empty)
                        {
                            foreach my $d (($max_sum - $partial_sum + 1) .. 9)
                            {
                                $self->_remove_cell_digit_opt($c_, $d);
                            }
                        }
                    }
                    if ($max_partial_sum < $max_sum)
                    {
                        my @l;
                        if ((@l = ($sum =~ /($LETT_RE)/g)) == 1)
                        {
                            my $l = $l[0];
                            foreach my $d (0 .. 9)
                            {
                                my $new_sum = $sum =~ s#\Q$l\E#$d#r;
                                if ($max_partial_sum < $new_sum)
                                {
                                    $self->_mark_as_not($self->_calc_l_i($l), $d);
                                }
                            }
                        }
                    }
                    if ($min_partial_sum > $min_sum)
                    {
                        my @l;
                        if ((@l = ($sum =~ /($LETT_RE)/g)) == 1)
                        {
                            my $l = $l[0];
                            foreach my $d (0 .. 9)
                            {
                                my $new_sum = $sum =~ s#\Q$l\E#$d#r;
                                if ($min_partial_sum > $new_sum)
                                {
                                    $self->_mark_as_not($self->_calc_l_i($l), $d);
                                }
                            }
                        }
                    }
                }
                {
                    my $min_sum = $sum;
                    $min_sum =~ s#($LETT_RE)#$self->_min_lett_digit($1)#eg;
                    my @empty;
                    my $partial_sum = 0;
                    foreach my $c_ ($self->_hint_cells($hint))
                    {
                        if (defined (my $d_ = $c_->digit))
                        {
                            if (_is_digit($d_))
                            {
                                $partial_sum += $d_;
                            }
                            else
                            {
                                push @empty, $c_;
                            }
                        }
                        else
                        {
                            push @empty, $c_;
                        }
                    }

                    @empty = sort { $self->_cell_min($a) <=> $self->_cell_min($b) } @empty;

                    if (@empty)
                    {
                        my $pivot = shift@empty;
                        my $cells_count = @empty;
                        my $max =
                        (
                            ((9 + 9 - $cells_count + 1)*$cells_count)
                            >> 1
                        );
                        foreach my $k ($self->_cell_min($pivot) .. 9)
                        {
                            if ($partial_sum + $max + $k < $min_sum)
                            {
                                $self->_remove_option($pivot, $k);
                            }
                        }
                    }
                }
                {
                    my $max_sum = $sum;
                    $max_sum =~ s#($LETT_RE)#$self->_max_lett_digit($1)#eg;
                    $max_sum =~ s#\A0#1#;

                    my @empty;
                    my $partial_sum = 0;
                    foreach my $c_ ($self->_hint_cells($hint))
                    {
                        if (defined (my $d_ = $c_->digit))
                        {
                            if (_is_digit($d_))
                            {
                                $partial_sum += $d_;
                            }
                            else
                            {
                                push @empty, $c_;
                            }
                        }
                        else
                        {
                            push @empty, $c_;
                        }
                    }

                    @empty = sort { $self->_cell_min($a) <=> $self->_cell_min($b) } @empty;

                    if (@empty)
                    {
                        foreach my $pivot_i (keys @empty)
                        {
                            my @e = @empty;
                            my ($pivot) = splice@e, $pivot_i, 1;
                            my $cells_count = @e;
                            my $max = @e ? sum(map { $self->_cell_min($_) } @e) : 0;
                            foreach my $k ($self->_cell_min($pivot) .. 9)
                            {
                                if ($partial_sum + $max + $k > $max_sum)
                                {
                                    $self->_remove_option($pivot, $k);
                                }
                            }
                        }
                    }
                }
                $self->_try_whole_sum($sum, $hint);
                $self->_try_perms_sum($sum, $hint);
                $self->_try_perms_sum_with_min($sum, $hint);
                $self->_try_1_plus($sum, $hint);
            }
        );

        $self->_find_identity_truth_permutations;

        $self->_process_queue;

        $self->hint_loop(
            sub {
                my ($args) = @_;
                $self->_try_remove_opts(@{$args}{qw/sum hint/});
                return;
            },
        );

        $self->_process_queue;
    }

    # Output the current layout:
    $self->_output_layout;

    if ($self->_was_solved)
    {
        $self->_out("[VERDICT] == Solved: " . $self->result()  . "\n");
    }
    else
    {
        $self->_out("[VERDICT] == Unsolved\n");
    }
    return;
}

sub _try_remove_opts
{
    my ($self, $master_sum, $hint) = @_;
    my @possible_sums = (map { +{ map { $_ => 0 } @$_ } } @{$self->_get_possible_sums_proto($master_sum)});
    my $partial_sum = 0;
    my @cells;
    my %found;
    foreach my $c_ ($self->_hint_cells($hint))
    {
        my $d_s = $self->_cell_digits($c_);
        if (@$d_s == 1)
        {
            my $d = $d_s->[0];
            $partial_sum += $d;
            $found{$d} = 1;
        }
        else
        {
            push @cells, [$c_, $d_s];
        }
    }
    if (@cells)
    {
        foreach my $repeat_times (keys@cells)
        {
            my $recurse = sub {
                my ($f, $i, $sum) = @_;

                if ($i == @cells)
                {
                    my @d = split//,$sum;
                    if (@d != @possible_sums)
                    {
                        return '';
                    }
                    while (my ($idx, $d) = each@d)
                    {
                        if (!exists$possible_sums[$idx]{$d})
                        {
                            return '';
                        }
                        $possible_sums[$idx]{$d}++;
                    }
                    return 1;
                }
                elsif ($i == 0)
                {
                    my ($c_, $d_s) = @{ $cells[$i]};
                    foreach my $d (@$d_s)
                    {
                        if (exists $found{$d})
                        {
                            $self->_remove_option($c_, $d);
                        }
                        else
                        {
                            if (!exists($f->{$d}))
                            {
                                if (!__SUB__->(+{%$f, $d => 1},
                                        $i+1,
                                        $sum + $d,
                                    ))
                                {
                                    $self->_remove_option($c_, $d);
                                }
                            }
                        }
                    }
                    return;
                }
                else
                {
                    my ($c_, $d_s) = @{ $cells[$i]};
                    my $ret = '';
                    foreach my $d (@$d_s)
                    {
                        if (!exists($f->{$d}) and !exists$found{$d})
                        {
                            if (__SUB__->(+{%$f, $d => 1},
                                    $i+1,
                                    $sum + $d,
                                ))
                            {
                                $ret = 1;
                            }
                        }
                    }
                    return $ret;
                }
            };
            $recurse->({}, 0, $partial_sum);
        }
        continue
        {
            my $next = shift@cells;
            push @cells,  $next;
        }

        while (my ($idx, $h) = each@possible_sums)
        {
            if (my ($l) = substr($master_sum, $idx, 1) =~ /\A($LETT_RE)\z/)
            {
                foreach my $d (grep { $h->{$_} == 0 } keys%$h)
                {
                    $self->_mark_as_not($self->_calc_l_i($l), $d);
                }
            }
        }
    }

    return;
}

sub _get_possible_sums_proto
{
    my ($self, $sum) = @_;

    my @s = split//, $sum;
    foreach my $s (@s)
    {
        if ($s =~ /\A$LETT_RE\z/)
        {
            $s = $self->_lett_digits($s);
        }
        else
        {
            $s = [$s];
        }
    }
    if ($s[0][0] == 0)
    {
        shift @{ $s[0] };
    }

    return \@s;
}

sub _compile_possible_sum
{
    my ($self, $s) = @_;

    my $cross_product = sub {
        if (!@_)
        {
            return [''];
        }
        else
        {
            my $f = shift@_;
            my $more = __SUB__->(@_);
            return [map { my $x = $_; map {$x.$_}@$more } @$f];
        }
    };

    return $cross_product->(@$s);
}

sub _get_possible_sums
{
    my ($self, $sum) = @_;

    return $self->_compile_possible_sum($self->_get_possible_sums_proto($sum));
}

sub _find_identity_truth_permutations
{
    my ($self) = @_;

    my @sets = (map { +{} } 0 .. 10);

    foreach my $l_i (0 .. 9)
    {
        my $letter = chr(ord('A') + $l_i);
        my $d_s = $self->_lett_digits($letter);
        my $sig = join',', @$d_s;
        push @{$sets[scalar@$d_s]{$sig}}, +{l => $l_i, d_s => $d_s};
    }

    foreach my $i (2 .. 10)
    {
        while (my ($sig, $arr) = each(%{$sets[$i]}))
        {
            my @l_s = @$arr;
            my $to_check = sub {
                if (@$arr == $i)
                {
                    return 1;
                }
                elsif (@$arr == $i-1)
                {
                    my $d_s = $arr->[0]{d_s};
                    foreach my $p (keys@$d_s)
                    {
                        my @subset = @$d_s;
                        splice(@subset, $p, 1);
                        my $sub_sig = join',',@subset;
                        if (exists$sets[$i-1]{$sub_sig})
                        {
                            push @l_s, @{$sets[$i-1]{$sub_sig}};
                            return 1;
                        }
                    }
                }
                return '';
            }->();

            if ($to_check)
            {
                # Let's rock and roll.
                my @letters = (map { $_->{l} } @l_s);
                my @digits = @{$arr->[0]->{d_s}};

                my %l = (map { $_ => 1 } @letters);
                my %d = (map { $_ => 1 } @digits);

                foreach my $l_i (0 .. 9)
                {
                    if (!exists $l{$l_i})
                    {
                        foreach my $d (@digits)
                        {
                            $self->_mark_as_not($l_i, $d);
                        }
                    }
                }
            }
        }
    }
    return;
}

sub _was_solved
{
    my $self = shift;

    return keys %{$self->_found_letters} == 10;
}

sub result
{
    my $self = shift;

    if ($self->_was_solved)
    {
        my $_found_letters = $self->_found_letters;
        return join('', @$_found_letters{0 .. 9})
    }
    else
    {
        return "UNSOLVED";
    }
}

sub _try_perms_sum
{
    my ($self, $sum, $hint) = @_;

    if (! _is_numeric($sum))
    {
        return;
    }

    my $total_cells_count = $hint->count;
    my $cells_count = $total_cells_count;
    my $partial_sum = 0;
    my @letter_cells;
    my @empty;
    foreach my $c_ ($self->_hint_cells($hint))
    {
        if (defined (my $d_ = $c_->digit))
        {
            if (_is_digit($d_))
            {
                $partial_sum += $d_;
                $cells_count--;
            }
            else
            {
                push @letter_cells, $c_;
            }
        }
        else
        {
            push @empty, $c_;
        }
    }

    my $calc_mask = sub {
        my ($count, $s) = @_;

        return _combine_bitmasks(@{_def_perms($count, $s)});
    };
    my $combined = ($calc_mask->($total_cells_count, $sum) &
        $calc_mask->($cells_count, $sum - $partial_sum));
    my $bit = 1;
    for my $d (1 .. 9)
    {
        if (not ( $combined & $bit))
        {
            foreach my $c_ (@empty, @letter_cells)
            {
                $self->_remove_option($c_, $d);
            }
        }
    }
    continue
    {
        $bit <<= 1;
    }

    return;
}

sub _try_1_plus
{
    my ($self, $sum, $hint) = @_;

    my $cells_count = $hint->count;

    if ($cells_count != 2)
    {
        return;
    }

    my $sum_l;
    if (not (($sum_l) = $sum =~ /\A(?:$DIGIT_RE)?($LETT_RE)\z/))
    {
        return;
    }

    my $d_s = $self->_lett_digits($sum_l);

    if ($d_s->[0] + 1 != $d_s->[-1])
    {
        return;
    }
    my $was_one_found = 0;
    my @lett_found;
    foreach my $c_ ($self->_hint_cells($hint))
    {
        my $d_ = $c_->digit;
        if (! defined($d_))
        {
            return;
        }
        if ($d_ eq 1)
        {
            if ($was_one_found++)
            {
                return;
            }
        }
        elsif (my ($l_) = $d_ =~ /\A($LETT_RE)\z/)
        {
            my $d_s = $self->_lett_digits($l_);
            if ($d_s->[0] + 1 != $d_s->[-1])
            {
                return;
            }
            push @lett_found, $l_;
            if (@lett_found > 1)
            {
                return;
            }
        }
    }

    if (not ($was_one_found && @lett_found))
    {
        return;
    }

    my %l = (map { $self->_calc_l_i($_) => 1 } @lett_found, $sum_l);
    # Let's boogie.
    for my $d ($d_s->[0])
    {
        foreach my $l_i (0 .. 9)
        {
            if (not exists $l{$l_i})
            {
                $self->_mark_as_not($l_i, $d);
            }
        }
    }

    return;
}

sub _try_perms_sum_with_min
{
    my ($self, $sum, $hint) = @_;

    if (! _is_numeric($sum))
    {
        return;
    }

    my $cells_count = $hint->count;
    my $partial_sum = 0;
    my @letter_cells;
    my @empty;
    foreach my $c_ ($self->_hint_cells($hint))
    {
        if (defined (my $d_ = $c_->digit))
        {
            if (_is_digit($d_))
            {
                $partial_sum += $d_;
                $cells_count--;
            }
            else
            {
                push @letter_cells, $c_;
            }
        }
        else
        {
            push @letter_cells, $c_;
        }
    }

    if (! @letter_cells)
    {
        return;
    }

    @letter_cells = sort { $self->_cell_min($a) <=> $self->_cell_min($b) } @letter_cells;

    my $pivot = shift@letter_cells;

    if ((--$cells_count) <= 0)
    {
        return;
    }

    my $pivot_val = $self->_cell_min($pivot);

    my $perms = _perms($cells_count, $sum - $partial_sum - $pivot_val);

    if (!defined$perms)
    {
        $self->_remove_option($pivot, $pivot_val);
        return;
    }

    my $combined = _combine_bitmasks(@$perms);

    foreach my $c_ (@letter_cells)
    {
        my $bitmask = $self->_cell_bitmask($c_);
        if (not $bitmask & $combined)
        {
            $self->_remove_option($pivot, $pivot_val);
            return;
        }
    }

    return;
}

sub _remove_cell_digit_opt
{
    my ($self, $c_, $d) = @_;
    my $o = $c_->options;
    if (exists($o->{$d}))
    {
        $self->_mark_as_dirty;
        delete $o->{$d};
    }

    my @k = keys %$o;
    if (@k == 1)
    {
        $self->_mark_as_dirty;
        $c_->digit($k[0]);
    }
    elsif (! @k)
    {
        die "Rarity - no options!";
    }
    return;
}

sub _remove_option
{
    my ($self,$c_, $opt) = @_;

    my $d = $c_->digit;

    if (! defined ($d))
    {
        $self->_remove_cell_digit_opt($c_, $opt);
        return;
    }
    if (_is_digit($d))
    {
        if ($d == $opt)
        {
            die "Discord forceord.";
        }
        return;
    }
    $self->_mark_as_not($self->_calc_l_i($d), $opt);
    return;
}

sub _cell_digits
{
    my ($self,$c_) = @_;
    my $d = $c_->digit;

    if (! defined ($d))
    {
        return [ sort {$a <=> $b } keys %{$c_->options} ];
    }
    if (_is_digit($d))
    {
        return [ $d ];
    }
    return $self->_lett_digits($d);
}

sub _cell_bitmask
{
    my ($self,$c_) = @_;
    return _combine_bitmasks(map { 1 << ($_ - 1) } @{$self->_cell_digits($c_)});
}

sub _cell_min
{
    my ($self,$c_) = @_;

    my $d = $c_->digit;

    if (! defined ($d))
    {
        return min keys %{$c_->options};
    }
    if (_is_digit($d))
    {
        return $d;
    }
    return $self->_min_lett_digit($d);
}

sub _unpack_bitmask
{
    my $b = shift;
    return [grep { $b & (1 << ($_ - 1)) } 1 .. 9];
}

sub _try_whole_sum
{
    my ($self, $sum, $hint) = @_;

    my $partial_sum = 0;
    my %masks;
    foreach my $c_ ($self->_hint_cells($hint))
    {
        my $bitmask;
        if (defined (my $d_ = $c_->digit))
        {
            if (_is_digit($d_))
            {
                $partial_sum += $d_;
            }
            else
            {
                $bitmask = $self->_cell_bitmask($c_);
            }
        }
        else
        {
            $bitmask = $self->_cell_bitmask($c_);
        }

        if (defined($bitmask))
        {
            if (!exists $masks{$bitmask})
            {
                my @k = @{_unpack_bitmask($bitmask)};
                $masks{$bitmask} = +{
                    num_bits => scalar@k,
                    count => 0,
                    sum => sum(@k),
                    cells => [],
                    bitmask => $bitmask,
                };
            }
            my $rec = $masks{$bitmask};
            $rec->{count}++;
            push @{$rec->{cells}}, $c_;
        }
    }
    my @ones;
    while (my ($bitmask, $rec) = each%masks)
    {
        if ($rec->{num_bits} != $rec->{count})
        {
            if ($rec->{count} == 1)
            {
                push @ones, $rec;
            }
            else
            {
                return;
            }
        }
        else
        {
            $partial_sum += $rec->{sum};
        }
    }
    if (! @ones)
    {
        foreach my $i (0 .. length($sum) - 1)
        {
            my $letter = substr($sum, $i, 1);
            if ($letter =~ /\A$LETT_RE\z/)
            {
                $self->_mark_as_yes($self->_calc_l_i($letter), substr($partial_sum, $i, 1));
            }
        }
    }
    elsif (@ones == 1)
    {
        if (_is_numeric($sum))
        {
            my $c_ = $ones[0]->{cells}->[0];
            my $d = $c_->digit;
            my $new_val = $sum - $partial_sum;
            if (!defined($d))
            {
                $c_->digit($new_val);
                foreach my $k (keys %{ $c_->options })
                {
                    if ($k != $new_val)
                    {
                        delete $c_->options->{$k};
                    }
                }
                $self->_mark_as_dirty;
            }
            else
            {
                $self->_mark_as_yes( $self->_calc_l_i($d), $new_val);
            }
        }
    }

    return;
}

sub _lett_digits
{
    my ($self, $letter) = @_;
    my $l_i = $self->_calc_l_i($letter);
    return [grep { $self->truth_table->[$l_i]->[$_] != $X } 0 .. 9];
}

sub _max_lett_digit
{
    my ($self, $letter) = @_;
    my $l_i = $self->_calc_l_i($letter);
    return (first { $self->truth_table->[$l_i]->[$_] != $X } reverse 0 .. 9);
}

sub _min_lett_digit
{
    my ($self, $letter) = @_;
    my $l_i = $self->_calc_l_i($letter);
    return (first { $self->truth_table->[$l_i]->[$_] != $X } 0 .. 9);
}

sub _process_partial_sum
{
    my ($self, $args) = @_;

    my $hint = $args->{hint};
    my $max = $args->{max};

    my $partial_sum = 0;
    my @digits = (1 .. 9);
    my %d = (map { $_ => 1 } @digits);
    my $num_empty = 0;
    my @to_trim;
    my @partial;

    foreach my $c_ ($self->_hint_cells($hint))
    {
        if (defined (my $d_ = $c_->digit))
        {
            my $d2;
            if (_is_digit($d_))
            {
                $d2 = $d_;
                delete $d{$d2};
            }
            else
            {
                $d2 = $self->_min_lett_digit($d_);
                if (!defined$d2)
                {
                    die "applebloom";
                }
                push @to_trim, +{ l => $self->_calc_l_i($d_), min => $d2, max => $self->_max_lett_digit($d_)};
            }
            $partial_sum += $d2;
        }
        else
        {
            my @k = keys %{$c_->options};
            if (@k < 9)
            {
                push @partial, $c_;
            }
            else
            {
                $num_empty++;
            }
        }
    }

    foreach my $i (1 .. $num_empty)
    {
        while (not exists $d{$digits[0]})
        {
            shift@digits;
        }
        $partial_sum += shift@digits;
    }
    foreach my $p (@partial)
    {
        $partial_sum += min(keys%{$p->options});
    }

    if (my ($letter) = $hint->sum =~ /\A($LETT_RE)/)
    {
        $self->_mark_as_not_out_of_range(
            $self->_calc_l_i($letter), $partial_sum, $max
        );
    }

    foreach my $t (@to_trim)
    {
        $self->_mark_as_not_out_of_range(
            $t->{l},
            $t->{min},
            $max - $partial_sum + $t->{min},
        );
    }

    return;
}

sub _calc_layout
{
    my $self = shift;

    use Text::Table;

    my $tb = Text::Table->new((map { ; "Col", \' | '; } 2 .. $self->x_lim), "Col", \' |');

    my $transform = sub {
        my $item = shift;

        if (! defined($item)) {
            return '';
        }
        elsif (ref$item eq '') {
           return $item =~ s#($LETT_RE)#
                my $l = $1;
                "{$l=[" . join('', @{$self->_lett_digits($l)}) . "]}"
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
    my $emit_cell = sub {
        my $cell = shift;
        if (defined (my $d = $cell->digit))
        {
            return $transform->($d);
        }
        else
        {
            return '[' . (join'', sort {$a <=> $b } keys%{$cell->options})
            . ']';
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
                    $cell->gray ? $transform->($cell->y_hint) . " \\ " . $transform->($cell->x_hint) : $emit_cell->($cell);
                } 0 .. $self->x_lim - 1
            ],
        }
        (0 .. $self->y_lim-1)
    );

    return "$tb";
}

sub _output_layout
{
    my $self = shift;

    $self->_out(sprintf "Current State == <<\n%s\n>>\n", $self->_calc_layout);

    return;
}

sub _mark_as_not_out_of_range
{
    my ($self, $l_i, $min, $max) = @_;

    my %l = (map { $_ => 1 } $min .. $max);

    foreach my $d (0 .. 9)
    {
        if (!exists $l{$d})
        {
            $self->_mark_as_not($l_i, $d);
        }
    }
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
    if ($$v_ref == $Y)
    {
        die "CheeseSandwich $l_i/$d!";
    }
    $self->_mark_as_dirty;

    $$v_ref = $X;

    {
        my @digit_opts = (grep { $self->truth_table->[$_]->[$d] != $X } 0 .. 9);
        $self->_out("Remaining values for digit=$d : " , (join ',', @digit_opts), "\n");
        if (none { $self->truth_table->[$_]->[$d] == $Y } 0 .. 9)
        {
            if (@digit_opts == 1)
            {
                $self->_out("_enqueue[digits] ({ type => '_mark_as_yes', d => $d, l => $digit_opts[0]})\n");
                $self->_enqueue({ type => '_mark_as_yes', d => $d, l => $digit_opts[0]});
            }
            elsif (! @digit_opts)
            {
                die "All Xs in digit=$d!";
            }
        }
    }
    {
        my @letter_opts = (grep { $self->truth_table->[$l_i]->[$_] != $X } 0 .. 9);
        $self->_out("Remaining values for letter=$l_i : " , (join ',', @letter_opts),
        "\n");

        if (none { $self->truth_table->[$l_i]->[$_] == $Y } 0 .. 9)

        {
            if (@letter_opts == 1)
            {
                $self->_out("_enqueue({ type => '_mark_as_yes', d => $letter_opts[0], l => $l_i});\n");
                $self->_enqueue({ type => '_mark_as_yes', d => $letter_opts[0], l => $l_i});
            }
            elsif (! @letter_opts)
            {
                die "All Xs in letter=$l_i!";
            }
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
    if ($$v_ref == $X)
    {
        die "ShiningArmour $letter/$digit!";
    }
    $self->_out("Matching $letter=$digit\n");
    $$v_ref = $Y;
    $self->_found_letters->{$l_i} = $digit;
    $self->_found_digits->{$digit} = $l_i;

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
    $self->_mark_as_dirty;

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

sub load_line
{
    my ($class, $args) = @_;

    my $line = $args->{line};
    my $output_cb = $args->{output_cb};

    $line =~ s#\A([67]),##
        or die "ill format for <<$line>>";
    my $len = $1;
    my $puz = $class->new({
            y_lim => $len,
            x_lim => $len,
            ($output_cb ? (output_cb => $output_cb) : ()),
        });
    $puz->populate_from_string($line);

    return $puz;
}

1;
