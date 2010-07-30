package main;

use strict;
use warnings;

my @primes = `primes 2 10000`;
chomp(@primes);

my @cache;

sub get_combinations
{
    my ($prefix, $start_from_max_prime_idx, $sum, $out_combinations_ref) = @_;

    my $combinations = [];
    
    if ($sum == 0)
    {
        push @$combinations, [];
    }
    elsif (defined($cache[$sum][$start_from_max_prime_idx]))
    {
        $combinations = $cache[$sum][$start_from_max_prime_idx];
    }
    else
    {
        MAX_PRIME:
        foreach my $max_prime_idx ($start_from_max_prime_idx .. $#primes)
        {
            my $max_prime = $primes[$max_prime_idx];

            if ($max_prime > $sum)
            {
                last MAX_PRIME;
            }

            get_combinations(
                [$max_prime], 
                $max_prime_idx, 
                $sum-$max_prime, 
                $combinations
            );
        }

        $cache[$sum][$start_from_max_prime_idx] = $combinations;
    }


    push @$out_combinations_ref, (map { [@$prefix, @$_] } @$combinations);

    return;
}

sub get_num_primes_combinations
{
    my $n = shift;

    my @combinations;

    MAX_PRIME:
    foreach my $max_prime_idx (0 .. $#primes)
    {
        my $max_prime = $primes[$max_prime_idx];

        if ($max_prime > $n)
        {
            last MAX_PRIME;
        }
        get_combinations([$max_prime], $max_prime_idx, $n-$max_prime, \@combinations);
    }
    return scalar(@combinations);
}

1;

