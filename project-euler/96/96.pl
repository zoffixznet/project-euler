#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";

use Games::Sudoku::CPSearch;
use IO::All;

my $in = io()->file("sudoku.txt");

my $sum = 0;
foreach my $i (1 .. 50)
{
    $in->getline();

    my @lines = (map { $in->getline() } (1 .. 9));

    s/\r// for @lines;

    my $s = join("", @lines);

    $s =~ tr/0/./;
    $s =~ s/\s//g;

    my $sud = Games::Sudoku::CPSearch->new($s);
    $sum += substr(scalar($sud->solve()), 0, 3);

    print "Finished $i - sum = $sum\n";
}


