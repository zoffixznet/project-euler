#!/usr/bin/perl

use strict;
use warnings;

use bytes;

use List::Util qw(sum);
use List::MoreUtils qw(uniq);

STDOUT->autoflush(1);

my $MAX = shift(@ARGV);

if ($MAX !~ /\A[0-9]+\z/)
{
    die "Argument is not an integer!";
}

my @primes = `primes 2 "$MAX"`;
chomp(@primes);

my @prime_powers = map {
    my $p = $_; my $e = int ( log($MAX)/log($p) ); $p ** $e
} @primes;

my @factors = (0, map {
        my $x = $_; chomp($x); $x =~ s/[^:]*:\s+//; [uniq(split/\s+/,$x)]
    } `seq 1 "$MAX" | factor`
);

my @remaining1 = (grep { !($factors[$_][0] == $_ and $_ >= ($MAX>>1)) } 2 .. $#factors);
my @remaining2 = (grep { not ($factors[$_][0]*$_ <= $MAX) } @remaining1);

my %state = (map { $primes[$_] => $prime_powers[$_] } keys@primes);
my @remaining3 = (grep {
        my $n = $_;
        not
            (@{$factors[$n]} > 1
                and
            sum(@state{@{$factors[$n]}}) > $n
            )
        } @remaining2);

# for my $n (reverse(2 .. $MAX))
N:
for my $n (2 .. $MAX)
{
    if ($n * $factors[$n][0] <= $MAX)
    {
        next N;
    }
    my @f = @{$factors[$n]};
    my @products = uniq(@state{@f});
    my @state_f = uniq (map { @{$factors[$_]} } @products);
    if (sum( uniq(@state{@f})) < $n)
    {
        foreach my $factor (@f)
        {
            $state{$factor} = $n;
        }
    }
}

# 1 can be a part of the coprimes.
print 1 + sum(uniq(values%state));
print "\n";

