#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my @db = path("factor.db")->lines_raw;
chomp @db;

for my $base ( 2 .. 1_000_000 )
{
    my $exp     = 2;
    my $n       = $base * $base;
    my @factors = $db[$base] =~ s#[^:]*:##r =~ /([0-9]+)/g;
    while ( $n <= 1000000000000 )
    {
        my @exp_factors = $db[$exp] =~ s#[^:]*:##r =~ /([0-9]+)/g;
        my @tot = sort { $a <=> $b } @factors, @exp_factors;
        if ( @tot >= 4 or ( @tot == 3 and $tot[-1] > 2 ) )
        {
            print "$n\n";
        }
    }
    continue
    {
        ++$exp;
        $n *= $base;
    }
}

