#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 11;
use lib '.';

use Euler424_v1;
use IO::All qw / io /;

{
    my $sum = 0;

    foreach
        my $line ( ( io->file('./p424_kakuro200.txt')->getlines() )[ 0 .. 9 ] )
    {
        my $puz = Euler424_v1::Puzzle->load_line( { line => $line } );
        $puz->solve;
        my $result = $puz->result;

        # TEST*10
        is_deeply(
            [ sort { $a <=> $b } split //, $result ],
            [ 0 .. 9 ],
            "Result is a 0..9 permutation",
        );
        $sum += $result;
    }

    # TEST
    is( $sum, 64414157580, "Sum of first ten is right." );
}
