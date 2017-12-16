#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my @db = path("factor.db")->lines_raw;
foreach my $i ( @db[ 2 .. $#db ] )
{
    $i = [ map { int $_ } $i =~ s#[^:]*:##r =~ /([0-9]+)/g ];
}

for my $base ( 2 .. 1_000_000 )
{
    my $exp          = 2;
    my $n            = $base * $base;
    my $base_factors = $db[$base];
    while ( $n <= 1000000000000 )
    {
        my @tot = sort { $a <=> $b } @$base_factors, @{ $db[$exp] };
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

