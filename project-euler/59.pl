#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);
use IO::All;

my $cipher = join("", map { chr($_) } split /,/, scalar(io("cipher1.txt")->slurp()));

foreach my $i ('a' .. 'z')
{
    foreach my $j ('a' .. 'z')
    {
        foreach my $k ('a' .. 'z')
        {
            my $key = "$i$j$k";
            my $pad = (($key x int(length($cipher)/3)).substr($key, 0, length($cipher)%3));
            my $plain = ($cipher ^ $pad);
            if ($plain =~ m{ (?:and|or) }i)
            {
                my $sum = sum(map { ord($_) } split(//, $plain));
                print qq{KEY == "$key"\nPlain="$plain"\nSum=\"$sum"\n};
            }
        }
    }
}

