#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat only => 'GMP';

sub sq_frac
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

my $target = Math::BigRat->new('1/2');
my $limit = 80;

my $found_count = 0;

# We exclude 2 because the target is divided by it.
my @primes = (grep { is_prime($_) } (3 .. $limit));

my %primes_lookup = (map { $_ => 1 } @primes);

my @remaining_sums;

$remaining_sums[81] = 0;

for my $n (reverse(2 .. 80))
{
    $remaining_sums[$n] = $remaining_sums[$n+1] + sq_frac($n);
}

sub recurse
{
    my ($start_from, $so_far, $sum) = @_;

    print "Checking: Start=$start_from ; $sum+[@$so_far]\n";

    if ($sum == $target)
    {
        $found_count++;
        print "Found {", join(',', @$so_far), "}\n";
        print "Found so far: $found_count\n";
        return;
    }

    if ($sum + $remaining_sums[$start_from] < $target)
    {
        return;
    }

    FIRST_LOOP:
    foreach my $first ($start_from .. $limit)
    {
        my $new_sum = $sum + sq_frac($first);
        if ($new_sum > $target)
        {
            return;
        }

        if ($primes_lookup{$first})
        {
            # It can never be balanced.
            if ($first > $limit/2)
            {
                next FIRST_LOOP;
            }

=begin removed
            my $test_sum = $new_sum->copy();
            my $first_product = $first*2;
            
            while(
                ($test_sum->denominator() % $first == 0)
            )
            {
                $test_sum += Math::BigRat->new(
                    '1/' . ($first_product * $first_product)
                );
                
                if ($test_sum > $target)
                {
                    next FIRST_LOOP;
                }
                if (($first_product += $first) > $limit)
                {
                    next FIRST_LOOP;
                }
            }
=end removed

=cut
        }
        recurse($first+1, [@$so_far, $first], $new_sum);
    }

    return;
}

recurse(2, [], 0);


