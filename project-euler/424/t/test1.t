#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Euler424_v1;
use IO::All qw / io /;

{
    foreach my $line ( io->file('./p424_kakuro200.txt')->getlines() )
    {
        my $puz = Euler424_v1::Puzzle->load_line( { line => $line } );
    }
}

# TEST
ok( 1, "All puzzles loaded fine." );
