#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat only => 'GMP';

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

sub recurse
{
    my ($start_from, $so_far, $sum) = @_;

    # print "Checking: Start=$start_from ; $sum+[@$so_far]\n";

    if ($sum == $target)
    {
        $found_count++;
        print "Found {", join(',', @$so_far), "}\n";
        print "Found so far: $found_count\n";
        return;
    }

    FIRST_LOOP:
    foreach my $first ($start_from .. $limit)
    {
        my $new_sum = $sum + Math::BigRat->new('1/' . ($first * $first));
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
        }
        recurse($first+1, [@$so_far, $first], $new_sum);
    }
}

recurse(2, [], 0);


