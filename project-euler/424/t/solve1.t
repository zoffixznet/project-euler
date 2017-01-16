#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Euler424_v1;
use IO::All qw / io /;

{
    my $line = ( io->file('./p424_kakuro200.txt')->getlines() )[0];
    {
        my $puz = Euler424_v1::Puzzle->load_line( { line => $line } );
        $puz->solve;

        # TEST
        is( $puz->result(), '8426039571', 'Puzzle #1 was solved correctly' );
    }
}
