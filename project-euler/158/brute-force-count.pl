#!/usr/bin/perl

use strict;
use warnings;

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

my $COUNT = shift(@ARGV);

my @perms = @{gen_perms([1 .. $COUNT])};

foreach my $len (0 .. $COUNT)
{
    my %found = ();

    my $count = 0;

    foreach my $p (@perms)
    {
        my @sub_p = @$p[0 .. $len-1];

        if (! $found{join(',',@sub_p)}++ )
        {
            if (1 == grep { $sub_p[$_+1] < $sub_p[$_] } (0 .. $#sub_p-1))
            {
                $count++;
            }
        }
    }
    printf "Count[%2d] == %d\n", $len, $count;
}
