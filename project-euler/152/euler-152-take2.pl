#!/usr/bin/perl

use strict;
use warnings;

use v5.16;

use Math::BigRat only => 'GMP';
use List::MoreUtils qw(any all uniq);
use Math::BigInt ( only => 'GMP' );

sub slow_sq_frac
{
    my ($n) = @_;

    return Math::BigRat->new( '1/' . ( $n * $n ) );
}

sub is_prime
{
    my ($n) = @_;

    if ( $n <= 1 )
    {
        return 0;
    }

    my $top = int( sqrt($n) );

    for my $i ( 2 .. $top )
    {
        if ( $n % $i == 0 )
        {
            return 0;
        }
    }

    return 1;
}

sub factorize
{
    my ($n) = @_;
    my @ret;

    my $factor = 2;
    while ( $n > 1 )
    {
        if ( $n % $factor == 0 )
        {
            push @ret, $factor;
            $n /= $factor;
        }
        else
        {
            $factor++;
        }
    }
    return \@ret;
}

my $target = Math::BigRat->new('1/2');
my $limit  = 80;

my $found_count = 0;

# We exclude 2 because the target is divided by it.
my @primes = ( grep { is_prime($_) } ( 3 .. $limit ) );

my @sq_fracs = ( map { $_ ? slow_sq_frac($_) : $_ } ( 0 .. $limit ) );

my %primes_lookup = ( map { $_ => 1 } @primes );

my @remaining_sums;

$remaining_sums[ $limit + 1 ] = 0;

for my $n ( reverse( 2 .. $limit ) )
{
    $remaining_sums[$n] = $remaining_sums[ $n + 1 ] + $sq_fracs[$n];
}

my @end_at;
$end_at[2] = $limit + 1;
for my $p (@primes)
{
    $end_at[$p] = int( $limit / $p ) * $p + 1;
}

my @valid_primes_multiples_sets;

sub recurse
{
    my ( $to_check, $so_far, $sum, $denom_factors_so_far ) = @_;

    # print "Checking: ToCheck=@$to_check ; $sum+[@$so_far]\n";

    if ( $sum == $target )
    {
        $found_count++;
        print "Found {", join( ',', @$so_far ), "}\n";
        print "Found so far: $found_count\n";
        return;
    }

    if ( !@$to_check )
    {
        return;
    }

    my $start_from = $to_check->[0];

    if ( $sum + $remaining_sums[$start_from] < $target )
    {
        # print "Remaining sum prune\n";
        return;
    }

    if (
        any { $_ > 2 && $end_at[$_] <= $start_from }
        @{ factorize( $sum->denominator() ) }
        )
    {
        return;
    }

FIRST_LOOP:
    foreach my $first_idx ( keys(@$to_check) )
    {
        my $first   = $to_check->[$first_idx];
        my $new_sum = ( $sum + $sq_fracs[$first] )->bnorm();
        if ( $new_sum > $target )
        {
            next FIRST_LOOP;
        }

        my @new_factors =
            grep { $_ > 2 } uniq( @{ factorize( $new_sum->denominator() ) } );
        my $new_to_check = [ @$to_check[ $first_idx + 1 .. $#$to_check ] ];

        if ( !@new_factors )
        {
            recurse( $new_to_check, [ sort { $a <=> $b } ( @$so_far, $first ) ],
                $new_sum, $denom_factors_so_far, );
            next FIRST_LOOP;
        }

        my @new_factors_contains = (
            map {
                my $new_factor = $_;
                [
                    grep { $new_to_check->[$_] % $new_factor == 0 }
                        keys @$new_to_check
                ]
            } @new_factors
        );

        if ( all { scalar(@$_) } @new_factors_contains )
        {
            my %new_factors_contains_lookup = (
                map {
                    map { $_ => 1 }
                        @$_
                } @new_factors_contains
            );

            my @factors_not_contains = (
                grep { !exists( $new_factors_contains_lookup{$_} ) }
                    keys @$new_to_check
            );

            my %encountered_factors;

            # my $sum_threshold = $target - $remaining_sums[$new_to_check->[0]];
            my $sum_threshold = $target;

            my $iter_factors_recurse = sub {
                my ( $idx, $factor_idx, $factors_href, $new_new_sum,
                    $new_denom_factors_so_far )
                    = @_;

                if ( $new_new_sum > $sum_threshold )
                {
                    return;
                }
                if ( $idx == @new_factors )
                {
                    my @factors = sort { $a <=> $b } keys(%$factors_href);
                    if ( !$encountered_factors{ join( ',', @factors ) }++ )
                    {
                        recurse(
                            [ @$new_to_check[@factors_not_contains] ],
                            [
                                sort { $a <=> $b }
                                    ( @$so_far, $first, @factors )
                            ],
                            $new_new_sum->bnorm(),
                            $new_denom_factors_so_far
                        );
                    }
                    return;
                }

                if ( $factor_idx == @{ $new_factors_contains[$idx] } )
                {
                    my $denom = $new_new_sum->bnorm->denominator();
                    my $next_factors_so_far =
                        { %$new_denom_factors_so_far, $new_factors[$idx] => 1 };

          # if (any { exists($next_factors_so_far->{$_}) } @{factorize($denom)})
                    if ( any { $denom % $_ == 0 } keys(%$next_factors_so_far) )
                    {
                        return;
                    }
                    else
                    {
                        return __SUB__->(
                            $idx + 1, 0, $factors_href, $new_new_sum,
                            $next_factors_so_far,
                        );
                    }
                }

                my $factor =
                    $new_to_check->[ $new_factors_contains[$idx][$factor_idx] ];

                if ( !exists( $factors_href->{$factor} ) )
                {
                    __SUB__->(
                        $idx,
                        $factor_idx + 1,
                        { %$factors_href, $factor => 1 },
                        $new_new_sum + $sq_fracs[$factor],
                        $new_denom_factors_so_far
                    );
                }
                __SUB__->(
                    $idx, $factor_idx + 1,
                    $factors_href, $new_new_sum, $new_denom_factors_so_far
                );

                return;
            };

            $iter_factors_recurse->(
                0, 0, +{}, $new_sum, $denom_factors_so_far
            );
        }

        # recurse($first+1, [@$so_far, $first], $new_sum);
    }

    return;
}

# Filter out the large primes and the primes which only have 2*p in the limit
# and their product.
my @init_to_check = (
    grep {
        (
            !(
                exists( $primes_lookup{$_} ) || ( ( ( $_ & 0x1 ) == 0 )
                    && exists( $primes_lookup{ $_ >> 1 } ) )
            )
            )
            || $_ < $limit / 3
    } ( 2 .. $limit )
);

foreach my $p (@init_to_check)
{
    if ( $p > 2 && ( exists( $primes_lookup{$p} ) ) )
    {
        print "Processing $p\n";
        my @products = ( map { $p * $_ } ( 1 .. int( $limit / $p ) ) );
        my @sq = ( map { $_ * $_ } @products );

        my $lcm = Math::BigInt::blcm(@sq);
        print "LCM=$lcm\n";
        my $bef_mod = $lcm;
        while ( $bef_mod % $p == 0 )
        {
            $bef_mod /= $p;
        }

        my $mod = $lcm / $bef_mod;

        my @numers = map { $lcm / $_ } @sq;
        my @combos;

        my @rev_sums;
        {
            my $s = 0;
            foreach my $n ( reverse @numers )
            {
                $s += $n;
                unshift( @rev_sums, $s );
            }
        }

        my $half_lcmed_limit = ( $lcm >> 1 );

        my $recurse = sub {
            my ( $i, $sum, $combo_so_far ) = @_;

            # print "Combo=@$combo_so_far\n";
            if ( $i == @sq )
            {
                return;
            }
            my $m = $sum % $mod;
            if ( $sum and $m == 0 )
            {
                print "Found [@$combo_so_far]\n for $p\n";

                # We can combine distinct combos later.
                push @combos, $combo_so_far;
                return;
            }
            if ( $rev_sums[ $i + 1 ] < $mod - $m or $sum >= $half_lcmed_limit )
            {
                # print "Flavoo = {$i}\n";
                return;
            }
            __SUB__->( $i + 1, $sum, $combo_so_far );
            __SUB__->( $i + 1, $sum + $numers[$i], [ @$combo_so_far, $i ] );

            return;
        };
        $recurse->( 0, 0, [] );

        $valid_primes_multiples_sets[$p] = \@combos;
    }
}

recurse( [@init_to_check], [], Math::BigRat->new('0/1'), +{} );

=begin removed

        foreach my $mask (1 .. ((1 << @products)-1))
        {
            # print "M=$mask\n";
            my $sum = 0;

            my @combo;

            foreach my $i (keys(@products))
            {
                if (($mask>>$i)&0x1)
                {
                    my $prod = $products[$i];
                    push @combo, $prod;
                    $sum += $sq_fracs[$prod];
                }
            }

            if ($sum->bnorm()->denominator() % $p)
            {
                push @combos, {map { $_ => 1 } @combo};
            }
        }

=end removed

=cut

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
