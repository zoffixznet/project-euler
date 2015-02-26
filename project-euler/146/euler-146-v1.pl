#!/usr/bin/perl

use strict;
use warnings;
use autodie;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw(all none);

STDOUT->autoflush(1);

sub get_mods
{
    open my $in, '<', 'db.txt';
    my @l = <$in>;
    my $last_line = pop(@l);
    my ($div) = $last_line =~ /\AFor ([0-9]+):/;
    return ($div, [map { $_ + 0 } split/ /, $last_line =~ s/\A[^\[]*\[//r =~ s/\][^\]]*\z//r ]);
}

my ($div, $mods) = get_mods();

my @primes = (map { $_ + 0 } `primes 2 151000000`);

sub is_prime
{
    my ($n) = @_;

    my $lim = int(sqrt($n));

    foreach my $p (@primes)
    {
        if ($p > $lim)
        {
            return 1;
        }
        if ($n % $p == 0)
        {
            return 0;
        }
    }

    return 1;
}

my @y_off = (1,3,7,9,13,27);
my @n_off = (grep { my $n = $_; ($n % 2 == 1) && (none { $_ == $n } @y_off) } 1 .. 27);

my $sum = 0;
my $LIMIT = 150_000_000;
my $offset = 0;

MAIN:
while (1)
{
    for my $m (@$mods)
    {
        my $n = $offset + $m;
        if ($n > $LIMIT)
        {
            last MAIN;
        }

        my $sq = $n * $n;

        if ((all { is_prime($sq+$_) } @y_off) && (none { is_prime($sq+$_) } @n_off))
        {
            print "Found N=$n\n";
            $sum += $n;
        }

    }
}
continue
{
    $offset += $div;
}

print "Sum = $sum\n";
