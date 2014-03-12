#!/usr/bin/perl

use strict;
use warnings;

# use Math::BigInt lib => 'GMP', ':constant';

# use List::Util qw(sum);
# use List::MoreUtils qw();

=head1 DESCRIPTION

Taking three different letters from the 26 letters of the alphabet, character
strings of length three can be formed.

Examples are 'abc', 'hat' and 'zyx'.

When we study these three examples we see that for 'abc' two characters come
lexicographically after its neighbour to the left.

For 'hat' there is exactly one character that comes lexicographically after its
neighbour to the left. For 'zyx' there are zero characters that come
lexicographically after its neighbour to the left.

In all there are 10400 strings of length 3 for which exactly one character
comes lexicographically after its neighbour to the left.

We now consider strings of n ≤ 26 different characters from the alphabet.
For every n, p(n) is the number of strings of length n for which exactly one character comes lexicographically after its neighbour to the left.

What is the maximum value of p(n)?

=head1 ANALYSIS

If the string is of the form:

    a[0] a[1] a[2] a[3] ... a[m] b[0] b[1] ... b[n-m]

Then it is clear that:

    a[1] < a[0]
    a[2] < a[1]
    a[3] < a[2]

    Foreach x a[x+1] < a[x]

    b[0] > a[m]

    b[1] < b[0]
    b[2] < b[1]

    Foreach x b[x+1] < b[x]

And also all the a[i]s and b[i]s are different.

=cut

my @counts;

=head1 FACT

sub fact
{
    return shift->copy->bfac;
}

=cut

sub fact
{
    my ($n) = @_;

    my $r = 1;

    for my $i (2 .. $n)
    {
        $r *= $i;
    }

    return $r;
}

sub nCr
{
    my ($n, $k) = @_;
    $n += 0;
    $k += 0;

    if ($n < $k)
    {
        die "N=$n K=$k";
    }
    return fact($n) / (fact($n-$k) * fact($k));
}

# TODO : this can be optimised to oblivion and exclude recursion.
sub after_bump_recurse
{
    my ($num, $remain, $multiplier) = @_;

    foreach my $i (0 .. $remain)
    {
        my $val = ($counts[$num+$i] += (nCr($remain,$i) * $multiplier));
        # print "C[@{[$num+$i]}] == $val\n";
    }
    return;
}

my $COUNT_LETTERS = 26;

# So we have:
# [e1] [e2] [e3]...  [first_max] [second_min such that < first_max] [f1] [f2]...
#
#

sub before_bump_recurse
{
    my ($num_remain) = @_;

    foreach my $first_max (1 .. $num_remain)
    {
        foreach my $num_elems_in_e_series (1 .. $first_max-1)
        {
            my $num_letters_less_than_first_max_and_not_in_e_series =
            $first_max - $num_elems_in_e_series;

            foreach my $count_of_elems_in_second_series_below_first_max (1 .. $num_letters_less_than_first_max_and_not_in_e_series)
            {
                after_bump_recurse(
                    $count_of_elems_in_second_series_below_first_max + $num_elems_in_e_series,
                    $num_remain - $first_max,
                    (
                        nCr($first_max-1, $count_of_elems_in_second_series_below_first_max)
                        * nCr($first_max,$num_elems_in_e_series)
                    )
                );
            }
            # after_bump_recurse($num, $num_discarded, nCr($num_remain, $num));
        }
    }


    return;
}

before_bump_recurse($COUNT_LETTERS);

foreach my $i (keys(@counts))
{
    print "Count[", sprintf("%2d", $i), "] = ", ($counts[$i] // 0), "\n";
}

=begin NOTWORKING

my @_cache;

sub lookup
{
    my ($len, $last_letter, $count) = @_;

    return ($_cache[$len][$last_letter][$count] // 0);
}

sub set
{
    my ($len, $last_letter, $count, $new_val) = @_;

    $_cache[$len][$last_letter][$count] = $new_val;

    return;
}

sub add
{
    my ($len, $last_letter, $count, $delta) = @_;

    set ($len, $last_letter, $count,
        (lookup($len, $last_letter, $count) + $delta),
    );

    return;
}

my $COUNT_LETTERS = 26;
my $MAX_LETTER = $COUNT_LETTERS - 1;

# Initialise the letters of length 1.
foreach my $letter (0 .. $MAX_LETTER)
{
    set(1, $letter, 0, 1);
}

foreach my $len (2 .. $COUNT_LETTERS)
{
    my $prev_len = $len - 1;
    my $sum = 0;
    foreach my $next_letter (0 .. $MAX_LETTER)
    {
        foreach my $prev_letter (0 .. $MAX_LETTER)
        {
            my $add_cb = sub {
                my ($old_count, $new_count) = @_;

                my $delta = lookup( $prev_len, $prev_letter, $old_count);
                add($len, $next_letter, $new_count, $delta);
                $sum += $delta;

                return;
            };

            if ($next_letter > $prev_letter)
            {
                $add_cb->(0 => 1);
            }
            else
            {
                foreach my $count (0 .. 1)
                {
                    $add_cb->($count => $count);
                }
            }
        }
    }
    print "p($len) = $sum\n";
}

=end NOTWORKING

=cut
