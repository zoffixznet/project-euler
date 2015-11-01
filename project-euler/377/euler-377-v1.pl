#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::GMP ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %count_cache;

sub gen_empty_matrix
{
    return [map { [ map { 0 } 1 .. 10] } 1 .. 10];
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

    foreach my $ret_from (0 .. 9)
    {
        my $m1_row = $m1->[$ret_from];
        foreach my $ret_to (0 .. 9)
        {
            my $sum = 0;
            my $m2_col = $m2_t->[$ret_to];
            foreach my $i (0 .. 9)
            {
                $sum += $m1_row->[$i] * $m2_col->[$i];
            }
            assign($ret, $ret_t, $ret_from, $ret_to, $sum);
        }
    }
    return {normal => $ret, transpose => $ret_t };
}

my $matrix1 = gen_empty_matrix();
my $matrix1_t = gen_empty_matrix();

for my $i (1 .. 9)
{
    my $from = $i;
    my $to = $i - 1;

    assign($matrix1, $matrix1_t, $to, $from, 1);
    assign($matrix1, $matrix1_t, 9, $to, 1);
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
