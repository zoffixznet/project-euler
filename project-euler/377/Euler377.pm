package Euler377;

use strict;
use warnings;

use integer;
use bytes;

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

my %count_cache;

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

$count_cache{1} = {normal => $matrix1, transpose => $matrix1_t};

sub calc_count_matrix
{
    my ($n) = @_;

    return $count_cache{"$n"} //= sub {
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

        return multiply(calc_count_matrix($recurse_n)->{normal}, calc_count_matrix($second_recurse_n)->{transpose});
    }->();
}

sub calc_count
{
    my ($n) = @_;

    return ($n == 0) ? 1 : calc_count_matrix($n)->{normal}->[0]->[0];
}

sub print_rows
{
    my ($mat) = @_;

    foreach my $row (@$mat)
    {
        print "Row = ", sum(@$row), "\n";
    }
}


our $BASE = 13;

our @N_s = ($BASE);

for my $i (2 .. 17)
{
    push @N_s, $N_s[-1] * $BASE;
}

my %mult_cache;

sub calc_multiplier
{
    my ($sum) = @_;

    return ($mult_cache{$sum} //= sub {
        my $ret = 0;

        for my $n (@N_s)
        {
            # print "calc_multiplier for $n\n";
            if ($n >= $sum)
            {
                $ret += calc_count($n-$sum);
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
    my ($count, $digits, $sum) = @_;

    if ($count == $MAX_DIGIT)
    {
        print "Trace: ", (map { ($_->[0]) x $_->[1] } @$digits), "\n";
        my $multiplier = calc_multiplier($sum);

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

        my $ret = ($digit_base * 111_111_111 * $multiplier) % 1_000_000_000;

        return $ret;
    }
    else
    {
        my ($last_digit, $last_digit_count) = @{$digits->[-1]};

        my $ret = 0;

        $ret += recurse_digits($count+1, [
                @$digits[0 .. $#$digits-1],
                [$last_digit, $last_digit_count+1],
            ],
            $sum + $last_digit
        );

        $ret %= 1_000_000_000;

        foreach my $new_digit ($last_digit + 1 .. 9)
        {
            $ret += recurse_digits(
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
    my $result = 0;
    foreach my $new_digit (1 .. 9)
    {
        $result += recurse_digits(
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
    return recurse_below('', 0);
}

sub calc_result
{
    return calc_result_above();
}

# Calculate the sum of the numbers below 1e9 whose sum-of-digits equal 13.
# as it is absent from the total sum.

sub recurse_below
{
    my ($n, $sum) = @_;

    if (length($n) == 9)
    {
        return 0;
    }
    if ($sum == $BASE)
    {
        return $n;
    }

    my $ret = 0;
    NEW:
    foreach my $new_digit (1 .. $MAX_DIGIT)
    {
        if ($sum + $new_digit > $BASE)
        {
            last NEW;
        }
        $ret += recurse_below($new_digit.$n, $sum + $new_digit);
    }
    return $ret;
}

1;
