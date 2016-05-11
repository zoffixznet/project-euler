#!/usr/bin/perl

use strict;
use warnings;

use Euler424_v1;
use IO::All qw / io /;

{
    foreach my $line (io->file('./p424_kakuro200.txt')->getlines())
    {
        $line =~ s#\A([67]),##
            or die "ill format for <<$line>>";
        my $len = $1;
        my $puz = Euler424_v1::Puzzle->new({y_lim => $len, x_lim => $len,});
        $puz->populate_from_string($line);
        $puz->solve;
    }
}
