#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use bigint;

my $MAX = 1000000000000;

open my $fh, "primesieve -p 1000160 1000000000000|";

my $c   = 0;
my $s   = 0;
my $d   = 1000000;
my $inv = $MAX / $d;

my $MIN_d = 28;
STDOUT->autoflush(1);
while ( my $p = <$fh> )
{
    chomp $p;
    while ( $p > $inv )
    {
        print "d = $d count = $c sum = $s\n";
        if ( --$d == $MIN_d )
        {
            close $fh;
            exit;
        }
        $inv = $MAX / $d;
    }
    ++$c;
    $s += $p;
}
