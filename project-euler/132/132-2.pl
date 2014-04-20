#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt 'lib' => 'GMP', ':constant';

use List::Util qw(reduce min);

my @divisors;

foreach my $power_of_2 (0 .. 9)
{
    foreach my $power_of_5 (0 .. 9)
    {
        my $num_digits = 2 ** $power_of_2 * 5 ** $power_of_5;
        push @divisors, +{ l => $num_digits+1, n =>
            sub { return ("1" . "0" x ($num_digits-1) . "1") },
        };

        push @divisors, +{ l => $num_digits*4+1, n =>
            sub { return (("1" . "0" x ($num_digits-1)) x 4 . "1") },
        };
    }
}

@divisors = sort { $a->{l} <=> $b->{l} } @divisors;

my %factors;
foreach my $div (@divisors)
{
    my $n = $div->{n}->();

    print "Checking $n\n";
    my $factor_string = `factor "$n"`;

    $factor_string =~ s{\A[^:]*:\s*}{}ms;

    foreach my $f (split(/\s+/, $factor_string))
    {
        $factors{$f}++;
    }
    my @factors_sorted = sort { $a <=> $b } keys(%factors);
    print "Num found factors: ", scalar(@factors_sorted), "\n";
    print "Factors == @factors_sorted\n";
    print "Sum first 40:", (reduce { $a + $b } 0, 0, @factors_sorted[0 .. min($#factors_sorted .. 39)]), "\n";
}
