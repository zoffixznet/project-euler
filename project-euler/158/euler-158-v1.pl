#!/usr/bin/perl

use strict;
use warnings;

# use Math::BigInt lib => 'GMP', ':constant';

# use List::Util qw(sum);
# use List::MoreUtils qw();

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

sub fact
{
    my ($n) = @_;

    my $r = 1;

    for my $i ( 2 .. $n )
    {
        $r *= $i;
    }

    return $r;
}

sub nCr
{
    my ( $n, $k ) = @_;
    $n += 0;
    $k += 0;

    if ( $n < $k )
    {
        die "N=$n K=$k";
    }
    return fact($n) / ( fact( $n - $k ) * fact($k) );
}

sub nCr3
{
    my ( $n, $k1, $k2 ) = @_;
    $n  += 0;
    $k1 += 0;
    $k2 += 0;

    if ( $n < $k1 + $k2 )
    {
        die "N=$n K1=$k1 K2=$k2";
    }
    return fact($n) / ( fact( $n - $k1 - $k2 ) * fact($k1) * fact($k2) );
}

# TODO : this can be optimised to oblivion and exclude recursion.
sub after_bump
{
    my ( $num, $remain, $factor ) = @_;

    foreach my $i ( 0 .. $remain )
    {
        my $val = ( $counts[ $num + $i ] += ( nCr( $remain, $i ) * $factor ) );

        # print "C[@{[$num+$i]}] == $val\n";
    }
    return;
}

sub before_bump
{
    my ($COUNT) = @_;

    # The first_max cannot be 0 because second_min must be less than that.
    foreach my $first_max ( 1 .. $COUNT - 1 )
    {
        foreach my $e_elems_count ( 1 .. $first_max )
        {
            my $not_in_e_below_first_max = ( $first_max + 1 ) - $e_elems_count;

            # my $factor = nCr($first_max, $e_elems_count);

            foreach my $num_below_1max_in_2nd ( 1 .. $not_in_e_below_first_max )
            {
                after_bump(
                    $num_below_1max_in_2nd + $e_elems_count,
                    $COUNT - ( $first_max + 1 ),
                    (
                        nCr3(
                            $first_max, $num_below_1max_in_2nd,
                            $e_elems_count - 1
                        )
                    )
                );
            }
        }
    }

    return;
}

my $COUNT_LETTERS = shift(@ARGV);

# So we have:
# [e1] [e2] [e3]...  [first_max] [second_min such that < first_max] [f1] [f2]...
#
#

before_bump($COUNT_LETTERS);

foreach my $i ( keys(@counts) )
{
    print "Count[", sprintf( "%2d", $i ), "] = ", ( $counts[$i] // 0 ), "\n";
}

__END__

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
