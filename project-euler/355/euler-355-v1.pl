#!/usr/bin/perl

use strict;
use warnings;

use bytes;

use List::Util qw(sum);
use List::MoreUtils qw(all none uniq);

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

my @remaining1 = (grep { !($factors[$_][0] == $_ and (($_ << 1) >= $MAX)) } 2 .. $#factors);
my @remaining2 = (grep { not ($factors[$_][0]*$_ <= $MAX) } @remaining1);

my %rem1 = (map { $_ => 1 } @remaining1);
my @definitely_included2 = (grep { !exists$rem1{$_} } 2 .. $#factors);
my %def_inc2 = (map { $_ => 1 } @definitely_included2);

my %prime_powers = (map { $primes[$_] => $prime_powers[$_] } keys@primes);
my %state = %prime_powers;

foreach my $d (@definitely_included2)
{
    delete $state{$d};
}

my @remaining3 = (grep {
        my $n = $_;
        not
            (@{$factors[$n]} > 1
                and
            sum(@state{@{$factors[$n]}}) > $n
            )
        } @remaining2);

my %rem3 = (map { $_ => 1 } @remaining3);

my @definitely_included1 = (grep {
        my $n = $_;
        $factors[$n][0] == $n and
        none { exists($rem3{$_*$n}) } 2 .. int($MAX/$n)
        ;
    } @remaining3);

my %def_inc1 = (map { $_ => 1 } @definitely_included1);

my @remaining4 = (grep { !exists($def_inc1{$_}) } @remaining3);
# for my $n (reverse(2 .. $MAX))
#

foreach my $d (@definitely_included1)
{
    delete $state{$d};
}
my $dirty = 1;

while ($dirty)
{
    $dirty = 0;
    N:
    for my $n (2 .. $MAX)
    {
        if ($n * $factors[$n][0] <= $MAX)
        {
            next N;
        }
        my @f = @{$factors[$n]};
        if (all { exists$state{$_} } @f)
        {
            my @products = uniq(@state{@f});
            if (sum( @products ) < $n)
            {
                my %n_factors = (map { $_ => 1 } @f);
                my @state_f = uniq (map { @{$factors[$_]} } @products);
                foreach my $factor (@state_f)
                {
                    $dirty = 1;
                    $state{$factor} = exists($n_factors{$factor}) ? $n : $prime_powers{$factor};
                }
            }
        }
    }
}
# 1 can be a part of the coprimes.
print 1 + sum(uniq(values%state), @definitely_included1, @definitely_included2);
print "\n";

