package Euler377;

use strict;
use warnings;

use integer;
use bytes;

use Math::GMP;

use Moo;

# use Math::GMP ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

=head1 The Plan.

We want to calculate the $n-vector where the top element is the count of 1-9
strings of $n and the rest are of $n-1 $n-2 $n-3, etc.

We start with the 0-vector of:

[ 1 ]
[ 0 ]
[ 0 ]
..
[ 0 ]

And we multiply it repetitively by the transformation matrix:

The first row is [(1) x 9 , 0]
The second row is [1 , 0, 0 ... 0]
The third row is [0, 1, 0...]
The final row is [0 ... 0 1 0]


=cut


our $NUM_DIGITS = 10;
our $MAX_DIGIT = $NUM_DIGITS - 1;
our @DIGITS = (0 .. $MAX_DIGIT);

sub gen_empty_matrix
{
    return [map { [ map { 0 } @DIGITS] } @DIGITS];
}

sub assign
{
    my ($m, $m_t, $to, $from, $val) = @_;

    $m->[$to]->[$from] = $m_t->[$from]->[$to] = $val;

    return;
}

sub multiply
{
    my ($m1, $m2_t) = @_;

    my $ret = gen_empty_matrix();
    my $ret_t = gen_empty_matrix();

    foreach my $row_idx (@DIGITS)
    {
        my $m1_row = $m1->[$row_idx];
        foreach my $col_idx (@DIGITS)
        {
            my $sum = 0;
            my $m2_col = $m2_t->[$col_idx];
            foreach my $i (@DIGITS)
            {
                ($sum += $m1_row->[$i] * $m2_col->[$i]) %= 1_000_000_000;
            }
            assign($ret, $ret_t, $row_idx, $col_idx, $sum);
        }
    }
    return {normal => $ret, transpose => $ret_t };
}

my $matrix1 = gen_empty_matrix();
my $matrix1_t = gen_empty_matrix();

for my $i (1 .. $MAX_DIGIT)
{
    assign($matrix1, $matrix1_t, $i, $i-1, 1);
    assign($matrix1, $matrix1_t, 0, $i-1, 1);
}

my %init_count_cache = (1 => +{normal => $matrix1, transpose => $matrix1_t});

has 'count_cache' => (is => 'rw', default => sub { return +{%init_count_cache}; });

sub calc_count_matrix
{
    my ($self, $n) = @_;

    return $self->count_cache->{"$n"} //= sub {
    # return $count_cache{"$n"} // sub {
        # Extract the lowest bit.
        my $recurse_n = $n - ($n & ($n-1));
        my $second_recurse_n = $n - $recurse_n;

        if ($recurse_n == 0)
        {
            ($recurse_n, $second_recurse_n) = ($second_recurse_n, $recurse_n);
        }

        if ($second_recurse_n == 0)
        {
            $recurse_n = $second_recurse_n = ($n >> 1);
        }

        return multiply($self->calc_count_matrix($recurse_n)->{normal}, $self->calc_count_matrix($second_recurse_n)->{transpose});
    }->();
}

sub calc_count
{
    my ($self, $n) = @_;

    return ($n == 0) ? 1 : $self->calc_count_matrix($n)->{normal}->[0]->[0];
}

sub print_rows
{
    my ($mat) = @_;

    foreach my $row (@$mat)
    {
        print "Row = ", sum(@$row), "\n";
    }
}


has 'BASE' => (is => 'rw', default => sub { return 13;},);
has 'N_s' => (is => 'rw', default => sub {
        my ($self) = @_;
        my @N_s = ($self->BASE());

        for my $i (2 .. 17)
        {
            push @N_s, $N_s[-1] * $self->BASE();
        }
        return \@N_s;
    }
);


has 'mult_cache' => (is => 'rw', default => sub { return +{}; });

sub calc_multiplier
{
    my ($self, $sum) = @_;

    return ($self->mult_cache->{$sum} //= sub {
        my $ret = 0;

        for my $n (@{$self->N_s()})
        {
            # print "calc_multiplier for $n\n";
            if ($n >= $sum)
            {
                $ret += $self->calc_count($n-$sum);
                $ret %= 1_000_000_000;
            }
        }

        return $ret;
    }->());
}

my @FACTs = (1);

for my $i (1 .. 9)
{
    push @FACTs, $i*$FACTs[-1];
}

sub recurse_digits
{
    my ($self, $count, $digits, $sum) = @_;

    if ($count == $MAX_DIGIT)
    {
        # print "Trace: ", (map { ($_->[0]) x $_->[1] } @$digits), "\n";
        my $multiplier = $self->calc_multiplier($sum);

        my $digit_base = 0;

        # my $count_variations = $FACTs[9]->gmp_copy;
        my $count_variations = $FACTs[9] + 0;

        for my $digit (@$digits)
        {
            $count_variations /= $FACTs[$digit->[1]];
        }
        for my $digit (@$digits)
        {
            $digit_base += $count_variations * $digit->[1] * $digit->[0];
        }
        $digit_base /= $count;

        my $ret = (((Math::GMP->new($digit_base) * Math::GMP->new(111_111_111))  * Math::GMP->new($multiplier)) % 1_000_000_000);

        # print "Trace: ", (map { ($_->[0]) x $_->[1] } @$digits), " += $ret\n";

        return $ret . '';
    }
    else
    {
        my ($last_digit, $last_digit_count) = @{$digits->[-1]};

        my $ret = 0;

        $ret += $self->recurse_digits($count+1, [
                @$digits[0 .. $#$digits-1],
                [$last_digit, $last_digit_count+1],
            ],
            $sum + $last_digit
        );

        $ret %= 1_000_000_000;

        foreach my $new_digit ($last_digit + 1 .. 9)
        {
            $ret += $self->recurse_digits(
                $count+1,
                [@$digits, [$new_digit, 1]],
                $sum + $new_digit,
            );
            $ret %= 1_000_000_000;
        }

        return $ret;
    }
}

sub calc_result_above
{
    my ($self) = @_;

    my $result = 0;
    foreach my $new_digit (1 .. 9)
    {
        $result += $self->recurse_digits(
            1,
            [[$new_digit, 1]],
            $new_digit,
        );
        $result %= 1_000_000_000;
    }

    return $result;
}

sub calc_result_below
{
    my ($self) = @_;

    if ($self->BASE() > 9*9)
    {
        return 0;
    }

    return $self->recurse_below('', 0);
}

sub calc_result
{
    my ($self) = @_;

    my $ret = $self->calc_result_above() + $self->calc_result_below();

    $ret %= 1_000_000_000;

    return $ret;
}

# Calculate the sum of the numbers below 1e9 whose sum-of-digits equal 13.
# as it is absent from the total sum.

sub recurse_below
{
    my ($self, $n, $sum) = @_;

    if (length($n) == 9)
    {
        return 0;
    }
    if ($sum == $self->BASE())
    {
        # print "Trace[have]: ", (sort { $a <=> $b } split//,$n), " += $n\n";
        return $n;
    }

    my $ret = 0;
    NEW:
    foreach my $new_digit (1 .. $MAX_DIGIT)
    {
        if ($sum + $new_digit > $self->BASE())
        {
            last NEW;
        }
        $ret += $self->recurse_below($new_digit.$n, $sum + $new_digit);
    }
    return $ret;
}

sub _mod
{
    my ($n) = @_;

    my $ret = substr($n, -9);

    $ret =~ s/\A0+//;

    return $ret;
}

sub recurse_brute_force
{
    my ($TARGET, $n, $sum) = @_;

    if ($sum == $TARGET)
    {
        my $ret = _mod($n);
        # print "Trace[want]: ", (sort { $a <=> $b } split//,$ret), " += $ret\n";
        return $ret;
    }

    my $ret = 0;
    NEW:
    foreach my $new_digit (1 .. $MAX_DIGIT)
    {
        if ($sum + $new_digit > $TARGET)
        {
            last NEW;
        }
        $ret += recurse_brute_force($TARGET, $new_digit.$n, $sum + $new_digit);
        $ret = _mod($ret);
    }
    return $ret;
}

sub calc_using_brute_force
{
    my ($self, $TARGET) = @_;

    return recurse_brute_force($TARGET , '', 0);
}

1;
