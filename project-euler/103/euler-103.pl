#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

=head1 DESCRIPTION

Let S(A) represent the sum of elements in set A of size n. We shall call it a
special sum set if for any two non-empty disjoint subsets, B and C, the
following properties are true:

    S(B) ≠ S(C); that is, sums of subsets cannot be equal.
    If B contains more elements than C then S(B) > S(C).

If S(A) is minimised for a given n, we shall call it an optimum special sum
set. The first five optimum special sum sets are given below.

n = 1: {1}
n = 2: {1, 2}
n = 3: {2, 3, 4}
n = 4: {3, 5, 6, 7}
n = 5: {6, 9, 11, 12, 13}

It seems that for a given optimum set, A = {a1, a2, ... , an}, the next optimum
set is of the form B = {b, a1+b, a2+b, ... ,an+b}, where b is the "middle"
element on the previous row.

By applying this "rule" we would expect the optimum set for n = 6 to be A =
{11, 17, 20, 22, 23, 24}, with S(A) = 117. However, this is not the optimum
set, as we have merely applied an algorithm to provide a near optimum set. The
optimum set for n = 6 is A = {11, 18, 19, 20, 22, 25}, with S(A) = 115 and
corresponding set string: 111819202225.

Given that A is an optimum special sum set for n = 7, find its set string.

NOTE: This problem is related to problems 105 and 106.

=head1 ANALYSIS

* If A is a special sum set then any subset S in A is also a special sum set.

* If A = (a1,a2...a7) in ascending order then:

* * a1+a2 > a7.

* * a1+a2+a3 > a6+a7

* * a1+a2+a3+a4 > a5+a6+a7

* 20, 20+11, 20+18, 20+19, 20+20,  20+22, 20+25 = 
= 20, 31, 38, 39, 40, 42, 45 is a special sum set.

=cut

sub is_special_sum_set
{
    my $A = shift;

    my $recurse;
    
    $recurse = sub {
        my ($i, $B_sum, $B_count, $C_sum, $C_count) = @_;

        if ($i == @$A)
        {
            if (
                (!$B_count) || (!$C_count)
                    ||
            (
                ($B_sum != $C_sum)
                    && 
                (($B_count > $C_count) ? ($B_sum > $C_sum) : 1)
                    &&
                (($C_count > $B_count) ? ($C_sum > $B_sum) : 1)
            )
            )
            {
                # Everything is OK.
                return;
            }
            else
            {
                die "Not a special subset sum.";
            }
        };

        $recurse->(
            $i+1, $B_sum+$A->[$i], $B_count+1, $C_sum, $C_count
        );
        $recurse->(
            $i+1, $B_sum, $B_count, $C_sum+$A->[$i], $C_count+1
        );
        $recurse->(
            $i+1, $B_sum, $B_count, $C_sum, $C_count
        );
    };

    eval {
        $recurse->(0, 0, 0, 0, 0);
    };

    return !$@;
}

print is_special_sum_set([20, 31, 38, 39, 40, 42, 45]), "\n";
# print is_special_sum_set([6, 9, 11, 12, 13]), "\n";
# print is_special_sum_set([1,2,3]), "\n";

my $min_sum = sum(20, 31, 38, 39, 40, 42, 45);

sub check_A
{
    my ($A_so_far) = @_;

    if (!is_special_sum_set($A_so_far))
    {
        return;
    }
    
    if (@$A_so_far == 7)
    {
        print "@$A_so_far\n";
        my $s = sum(@$A_so_far);
        if ($s < $min_sum)
        {
            $min_sum = $s;
            print "min_sum = $min_sum\n";
            print "\@A = ", join(",",@$A_so_far), "[", @$A_so_far, "]\n"
        }

        return;
    }
    else
    {
        for my $next_item ($A_so_far->[-1]+1 .. 45-(6-@$A_so_far))
        {
            check_A([@$A_so_far, $next_item]);
        }
        return;
    }
}

for my $a1 (reverse(1 .. 20))
{
    print "A[0] = $a1\n";
    check_A([$a1]);
}
