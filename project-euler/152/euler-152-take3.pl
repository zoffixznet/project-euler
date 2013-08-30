#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt (only => 'GMP', ':constant');

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

my $MIN = 2;
my $MAX = 80;

my (@keys, $lcm, @ints, $target);

my @primes = (grep { is_prime($_) } (3 .. $MAX));
my %primes_lookup = (map { $_ => 1 } @primes);

my @init_to_check = (grep { (!(exists($primes_lookup{$_}) || ((($_&0x1) == 0) && exists($primes_lookup{$_>>1})))) || $_ < $MAX/3 } ($MIN .. $MAX));

@keys = @init_to_check;

sub calc_stuff
{
    $lcm = Math::BigInt::blcm(map { $_ * $_ } @keys);

    @ints = (map { $lcm / ($_ * $_) } @keys);

    $target = $lcm / 2;

    return;
}

calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 100 == 0 } keys(@keys)];
calc_stuff();

# Deduced by semi-manual deduction.
@keys = @keys[grep { $ints[$_] % 2 == 0 } keys(@keys)];
calc_stuff();

print join("\n", @ints), "\n";
print "TARGET ==\n$target\n";
