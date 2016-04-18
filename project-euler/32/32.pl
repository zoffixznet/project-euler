#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

use Data::Dumper;

sub gen_perms
{
    my ($set) = @_;

    if (@$set < 5)
    {
        return [[]];
    }

    my $elem;
    my @prev_elems;
    my @perms;
    while ($elem = shift(@$set))
    {
        push @perms, (map { [$elem,@{$_}] } @{gen_perms([@prev_elems,@$set])});
        push @prev_elems, $elem;
    }

    return \@perms;
}

my %products;
my $good = join("K", 1..9);
foreach my $p (@{gen_perms([1..9])})
{
    {
        my $result = join("", @$p[0..1]) * join("", @$p[2..4]);
        if (join("K", sort { $a <=> $b } (@$p,split(//, $result))) eq $good)
        {
            $products{$result}++;
        }
    }
    {
        my $result = join("", @$p[0]) * join("", @$p[1..4]);
        if (join("K", sort { $a <=> $b } (@$p,split(//, $result))) eq $good)
        {
            $products{$result}++;
        }
    }
}

print sum(keys(%products)), "\n";
