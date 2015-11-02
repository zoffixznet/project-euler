package Euler377;

use strict;
use warnings;

use integer;
use bytes;

use Math::GMP ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

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
                $sum += $m1_row->[$i] * $m2_col->[$i];
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
    my $from = $i;
    my $to = $i - 1;

    assign($matrix1, $matrix1_t, $to, $from, 1);
    assign($matrix1, $matrix1_t, $MAX_DIGIT, $to, 1);
}

$count_cache{1} = {normal => $matrix1, transpose => $matrix1_t};

sub calc_count_matrix
{
    my ($n) = @_;

    return $count_cache{"$n"} //= sub {
        # Extract the lowest bit.
        my $recurse_n = $n - ($n & ($n-1));
        my $second_recurse_n = $n - $recurse_n;

        print "Before : n=$n recurse_n=$recurse_n second_recurse_n=$second_recurse_n\n";
        if ($recurse_n == 0)
        {
            ($recurse_n, $second_recurse_n) = ($second_recurse_n, $recurse_n);
        }

        if ($second_recurse_n == 0)
        {
            $recurse_n = $second_recurse_n = ($n >> 1);
        }

        {
            print "n=$n recurse_n=$recurse_n second_recurse_n=$second_recurse_n\n";
            return multiply(calc_count_matrix($recurse_n)->{normal}, calc_count_matrix($second_recurse_n)->{transpose});
        }
    }->();
}

sub calc_count
{
    my ($n) = @_;

    return calc_count_matrix($n)->{normal}->[0]->[0];
}

sub print_rows
{
    my ($mat) = @_;

    foreach my $row (@$mat)
    {
        print "Row = ", sum(@$row), "\n";
    }
}

print calc_count(5);

print_rows(calc_count_matrix(1)->{normal});
print_rows(calc_count_matrix(1)->{transpose});

1;
