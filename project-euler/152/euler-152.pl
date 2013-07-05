#!/usr/bin/perl

use strict;
use warnings;

use v5.16;

use Math::BigRat only => 'GMP';
use List::MoreUtils qw(any all uniq);


sub slow_sq_frac
{
    my ($n) = @_;

    return Math::BigRat->new('1/' . ($n*$n));
}

sub is_prime
{
    my ($n) = @_;

    if ($n <= 1)
    {
        return 0;
    }

    my $top = int(sqrt($n));

    for my $i (2 .. $top)
    {
        if ($n % $i == 0)
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
    while ($n > 1)
    {
        if ($n % $factor == 0)
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
my $limit = 35;

my $found_count = 0;

# We exclude 2 because the target is divided by it.
my @primes = (grep { is_prime($_) } (3 .. $limit));

my @sq_fracs = (map { $_ ? slow_sq_frac($_) : $_ } (0 .. $limit));

my %primes_lookup = (map { $_ => 1 } @primes);

my @remaining_sums;

$remaining_sums[$limit+1] = 0;

for my $n (reverse(2 .. $limit))
{
    $remaining_sums[$n] = $remaining_sums[$n+1] + $sq_fracs[$n];
}

my @end_at;
$end_at[2] = $limit+1;
for my $p (@primes)
{
    $end_at[$p] = int($limit/$p) * $p + 1;
}

sub recurse
{
    my ($to_check, $so_far, $sum) = @_;

    # print "Checking: ToCheck=@$to_check ; $sum+[@$so_far]\n";

    if ($sum == $target)
    {
        $found_count++;
        print "Found {", join(',', @$so_far), "}\n";
        print "Found so far: $found_count\n";
        return;
    }

    if (! @$to_check)
    {
        return;
    }

    my $start_from = $to_check->[0];

    if ($sum + $remaining_sums[$start_from] < $target)
    {
        # print "Remaining sum prune\n";
        return;
    }

    if (any { $_ > 2 && $end_at[$_] <= $start_from } @{factorize($sum->denominator())})
    {
        return;
    }

    FIRST_LOOP:
    foreach my $first_idx (keys(@$to_check))
    {
        my $first = $to_check->[$first_idx];
        my $new_sum = ($sum + $sq_fracs[$first])->bnorm();
        if ($new_sum > $target)
        {
            next FIRST_LOOP;
        }

        my @new_factors = grep { $_ > 2 } uniq(@{ factorize($new_sum->denominator()) });
        my $new_to_check = [@$to_check[$first_idx+1..$#$to_check]];

        if (! @new_factors)
        {
            recurse(
                $new_to_check,
                [sort { $a <=> $b } (@$so_far, $first)],
                $new_sum,
            );
            next FIRST_LOOP;
        }

        my @new_factors_contains = (map {
            my $new_factor = $_;
            [
                grep
                { $new_to_check->[$_] % $new_factor == 0 }
                keys @$new_to_check
            ]
            }
            @new_factors
        );

        if (all { scalar(@$_) } @new_factors_contains)
        {
            my %new_factors_contains_lookup =
            (map { map { $_ => 1 } @$_ } @new_factors_contains);

            my @factors_not_contains = (grep
                { !exists($new_factors_contains_lookup{$_}) }
                keys @$new_to_check
            );

            my %encountered_factors;

            # my $sum_threshold = $target - $remaining_sums[$new_to_check->[0]];
            my $sum_threshold = $target;

            my $iter_factors_recurse = sub {
                my ($idx, $factor_idx, $factors_href, $new_new_sum) = @_;

                if ($new_new_sum > $sum_threshold)
                {
                    return;
                }
                if ($idx == @new_factors)
                {
                    my @factors = sort {$a <=> $b } keys(%$factors_href);
                    if (! $encountered_factors{join(',',@factors)}++)
                    {
                        recurse([@$new_to_check[@factors_not_contains]],
                            [sort { $a <=> $b } (@$so_far, $first, @factors)],
                            $new_new_sum->bnorm(),
                        );
                    }
                    return;
                }

                if ($factor_idx == @{$new_factors_contains[$idx]})
                {
                    if ($new_new_sum->bnorm->denominator() % $new_factors[$idx] == 0)
                    {
                        return;
                    }
                    else
                    {
                        return __SUB__->($idx+1, 0, $factors_href, $new_new_sum);
                    }
                }

                my $factor = $new_to_check->[$new_factors_contains[$idx][$factor_idx]];

                if (!exists($factors_href->{$factor}))
                {
                    __SUB__->($idx, $factor_idx+1, {%$factors_href, $factor => 1}, $new_new_sum + $sq_fracs[$factor]);
                }
                __SUB__->($idx, $factor_idx+1, $factors_href, $new_new_sum);

                return;
            };

            $iter_factors_recurse->(0, 0, +{}, $new_sum);
        }

        # recurse($first+1, [@$so_far, $first], $new_sum);
    }

    return;
}

# Filter out the large primes and the primes which only have 2*p in the limit
# and their product.
my @init_to_check = (grep { (!(exists($primes_lookup{$_}) || ((($_&0x1) == 0) && exists($primes_lookup{$_>>1})))) || $_ < $limit/3 } (2 .. $limit));

recurse([@init_to_check], [], Math::BigRat->new('0/1'));


