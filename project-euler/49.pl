#!/usr/bin/perl

use strict;
use warnings;

my $primes_bitmask = "";

for my $p (2 .. int(sqrt(9999)))
{
    if (vec($primes_bitmask, $p, 1) == 0)
    {
        my $i = $p + $p;
        while ($i < 10_000)
        {
            vec($primes_bitmask, $i, 1) = 1;
        }
        continue
        {
            $i += $p;
        }
    }
}

sub gen_perms
{
    my ($set) = @_;

    if (@$set == 0)
    {
        return [[]];
    }

    my $elem;
    my @prev_elems;
    my @perms;
    while (defined($elem = shift(@$set)))
    {
        push @perms, (map { [$elem,@{$_}] } @{gen_perms([@prev_elems,@$set])});
        push @prev_elems, $elem;
    }

    return \@perms;
}

my @perms = @{gen_perms([0..3])};
# Shift the trivial permutation.
shift(@perms);

N_LOOP:
foreach my $n (1000 .. 9999)
{
    if (vec($primes_bitmask, $n, 1))
    {
        next N_LOOP;
    }
    my @d = split(m{}, $n);
    my $n_sorted = join("", sort {$a cmp $b } @d);
    PERM_LOOP:
    foreach my $p (@perms)
    {
        my $m = join("", @d[@$p]);

        if ($m <= $n)
        {
            next PERM_LOOP;
        }

        if (vec($primes_bitmask, $m, 1))
        {
            next PERM_LOOP;
        }

        my $k = $m + ($m - $n);

        if (vec($primes_bitmask, $k, 1))
        {
            next PERM_LOOP;
        }

        if (join("", sort { $a cmp $b } split(//, $k)) eq $n_sorted)
        {
            print "Found $n,$m,$k\n";
        }
    }
}

