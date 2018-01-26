#!/usr/bin/perl

use strict;
use warnings;

use integer;

# use Math::GMP qw(:constant);

use List::Util qw(sum reduce);
use List::MoreUtils qw(any);

my @sq;

sub sq
{
    my ($n) = @_;
    return $n * $n;
}

my $COUNT_TRAILING_DIGITS = 9;
my $COUNT_ALL_DIGITS      = 20;

# ### Temporary: remove later.
# $COUNT_TRAILING_DIGITS = 3;
# $COUNT_ALL_DIGITS = 7;

my $LIMIT = sq(9) * $COUNT_ALL_DIGITS;

{
    my $n = 0;

    my $sq = sq($n);
    while ( $sq <= $LIMIT )
    {
        push @sq, $sq;
        $sq = sq( ++$n );
    }
}

my @facts = (1);

for my $n ( 1 .. 20 )
{
    push @facts, $n * $facts[-1];
}

sub nCr
{
    my ( $n, $k ) = @_;

    if ( $n < $k )
    {
        die "N=$n K=$k";
    }
    return $facts[$n] / $facts[ $n - $k ] * $facts[$k];
}

sub _count_permutations
{
    my ( $n, $k_s ) = @_;

    my $p = 1;

    foreach my $k (@$k_s)
    {
        $p *= $facts[$k];
    }

    return ( $facts[$n] / $p );
}

sub square_sum_combinations
{
    my ( $COUNT_DIGITS, $trailing_sq_sum, $cb ) = @_;

    my $trail_cb;

    $trail_cb = sub {
        my ( $digits, $num, $next_digit, $sq, $remaining_sum ) = @_;

        if ( $num == $COUNT_DIGITS )
        {
            if ($remaining_sum)
            {
                return;
            }
            $cb->($digits);

            return;
        }
        elsif ( $sq > $remaining_sum )
        {
            my $next = $next_digit - 1;
            return $trail_cb->( $digits, $num, $next, $sq[$next],
                $remaining_sum );
        }
        elsif ( $remaining_sum > $sq * ( $COUNT_DIGITS - $num ) )
        {
            return;
        }
        elsif ( $next_digit == 0 )
        {
            my @new_digits = @$digits;
            if ( !@new_digits or $new_digits[-1][0] != 0 )
            {
                push @new_digits, [ 0, 0 ];
            }
            else
            {
                $new_digits[-1] = [ @{ $new_digits[-1] } ];
            }
            $new_digits[-1][1] += $COUNT_DIGITS - $num;

            return $trail_cb->( \@new_digits, $COUNT_DIGITS, 0, 0, 0 );
        }
        else
        {
            for my $next ( reverse( 0 .. $next_digit ) )
            {
                my @new_digits = @$digits;
                if ( @new_digits and $new_digits[-1][0] == $next )
                {
                    $new_digits[-1] = [ $next, $new_digits[-1][1] + 1 ];
                }
                else
                {
                    push @new_digits, [ $next, 1 ];
                }
                my $new_sq            = $sq[$next];
                my $new_remaining_sum = $remaining_sum - $new_sq;

                if ( $new_remaining_sum >= 0 )
                {
                    $trail_cb->(
                        \@new_digits, $num + 1, $next, $new_sq,
                        $new_remaining_sum,
                    );
                }
            }
        }
    };

    $trail_cb->( [], 0, 9, $sq[9], $trailing_sq_sum, );

    undef($trail_cb);

    return;
}

my $MOD = 10**$COUNT_TRAILING_DIGITS;

my $COUNT_LEADING_DIGITS = $COUNT_ALL_DIGITS - $COUNT_TRAILING_DIGITS;

my $total_mod  = 0;
my $INC        = 0 + ( '1' x $COUNT_TRAILING_DIGITS );
my $COUNT_FACT = $COUNT_TRAILING_DIGITS - 1;

STDOUT->autoflush(1);

foreach my $trailing_sq_sum ( 1 .. $sq[9] * $COUNT_TRAILING_DIGITS )
{
    print "trailing_sq_sum = $trailing_sq_sum\n";

    # First calculate the trailing mod.
    my $trailing_mod = 0;

    square_sum_combinations(
        $COUNT_TRAILING_DIGITS,
        $trailing_sq_sum,
        sub {
            my ($digits) = @_;

            my $delta =
                ( $INC *
                    sum( map { $_->[0] * $_->[1] } @$digits ) *
                    $facts[$COUNT_FACT] ) /
                ( reduce { $a * $b } ( @facts[ map { $_->[1] } @$digits ] ) );
            ( $trailing_mod += $delta ) %= $MOD;

# print "$trailing_sq_sum: ", join(",", map { "$_->[1]*$_->[0]" } @$digits), "\n";
# print "==delta=$delta\n";
# Sanity checks.
            if ( sum( map { $_->[1] } @$digits ) != $COUNT_TRAILING_DIGITS )
            {
                die "Foo";
            }
            if ( sum( map { $_->[1] * $_->[0] * $_->[0] } @$digits ) !=
                $trailing_sq_sum )
            {
                die "Bazzoka";
            }

            return;
        }
    );

    if ($trailing_mod)
    {
        my $leading_count = 0;

        foreach my $all_digits_sq_sum (@sq)
        {
            my $remaining = $all_digits_sq_sum - $trailing_sq_sum;
            if ( $remaining >= 0 )
            {
                square_sum_combinations(
                    $COUNT_LEADING_DIGITS,
                    $remaining,
                    sub {
                        my ($digits) = @_;

                        my $delta = _count_permutations(
                            $COUNT_LEADING_DIGITS,
                            [ map { $_->[1] } @$digits ],
                        );

                        $leading_count += $delta;

                    # print "leading_count = $leading_count ; Delta = $delta\n";

                        if ( sum( map { $_->[1] } @$digits ) !=
                            $COUNT_LEADING_DIGITS )
                        {
                            die "Bar";
                        }
                        if ( sum( map { $_->[1] * $_->[0] * $_->[0] } @$digits )
                            != $remaining )
                        {
                            die "Enigmatic";
                        }
                        return;
                    }
                );
            }
        }

        ( $total_mod += ( $leading_count * $trailing_mod ) ) %= $MOD;
    }
}

printf "Last digits = <%0${COUNT_TRAILING_DIGITS}d>\n", $total_mod;

# Brute force
if (0)
{
    my $sum = 0;
    for my $n ( 1 .. '9' x $COUNT_ALL_DIGITS )
    {
        my $sq_sum = sum( map { $sq[$_] } split //, $n );
        my $root = int( sqrt($sq_sum) );
        if ( $root * $root == $sq_sum )
        {
            $sum += $n;
        }
    }
    print "Sum=<$sum>\n";
}

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
