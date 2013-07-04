#!/usr/bin/perl

use strict;
use warnings;

use v5.16;

use Math::BigRat only => 'GMP';
use List::MoreUtils qw(any uniq);


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

    # print "Checking: Start=@$to_check ; $sum+[@$so_far]\n";

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

    my $factors = factorize($sum->denominator());

    if (any { $_ > 2 && $end_at[$_] <= $start_from } @$factors)
    {
        return;
    }

    my %factors_lookup = (map { $_ => 1 } @$factors);

    FIRST_LOOP:
    foreach my $first_idx (keys(@$to_check))
    {
        my $first = $to_check->[$first_idx];
        my $new_sum = ($sum + $sq_fracs[$first])->bnorm();
        if ($new_sum > $target)
        {
            return;
        }

        my @new_factors = grep { $_ > 2 } uniq(@{ factorize($new_sum->denominator()) });
        my $new_to_check = [@$to_check[$first_idx+1..$#$to_check]];

        if (! @new_factors)
        {
            recurse(
                $new_to_check,
                [@$so_far, $first],
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
        my %new_factors_contains_lookup =
            (map { map { $_ => 1 } @$_ } @new_factors_contains);

        my @factors_not_contains = (grep
            { !exists($new_factors_contains_lookup{$_}) }
            keys @$new_to_check
        );

        my $iter_factors_recurse = sub {
            my ($masks) = @_;
            my $idx = @$masks;

            if ($idx == @new_factors)
            {
                my @factors = sort {$a <=> $b } uniq (map {
                    my $i = $_;
                    @{$new_factors_contains[$i]}[grep { (($masks->[$i]>>$_)&0x1) } keys(@{$new_factors_contains[$i]})]
                    } (0 .. $#$masks));

                my $new_new_sum = $new_sum;

                foreach my $f (@factors)
                {
                    $new_new_sum += $sq_fracs[$new_to_check->[$f]];
                }

                recurse([@$new_to_check[@factors_not_contains]],
                    [sort { $a <=> $b} @$so_far, $first, @$new_to_check[@factors]],
                    $new_new_sum->bnorm(),
                );
                return;
            }

            foreach my $new_mask (1 .. ((1 << @{$new_factors_contains[$idx]})-1))
            {
                __SUB__->([@$masks, $new_mask]);
            }

            return;
        };

        $iter_factors_recurse->([]);

        # recurse($first+1, [@$so_far, $first], $new_sum);
    }

    return;
}

# Filter out the large primes.
my @init_to_check = (grep { !exists($primes_lookup{$_}) || $_ < $limit/2 } (2 .. $limit));

recurse([@init_to_check], [], Math::BigRat->new('0/1'));


