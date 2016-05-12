#!/usr/bin/perl

use strict;
use warnings;

use Euler424_v1;
use IO::All qw / io /;

{
    my @lines = io->file('./p424_kakuro200.txt')->getlines();
    foreach my $line (@lines[defined $ENV{I} ? (split/,/,$ENV{I}) : keys@lines])
    {
        my $puz = Euler424_v1::Puzzle->load_line({
            line => $line,
            output_cb => sub { print@_; return; },
        });
        $puz->solve;
        print "==NEXT PUZZLE==\n";
    }
}
