#!/usr/bin/perl

use strict;
use warnings;

use IO::All qw/io/;

my ($out_fn) = @ARGV;

my $NUM_BITS = 8;
io->file($out_fn)->print(
    "static const int NUM_BITS = $NUM_BITS;\n",
    "static const int zero_bitcounts[1 << NUM_BITS] = {\n",
        join(", ", map { sprintf("%08b", $_) =~ tr/0/0/ }
            0 .. ((1 << $NUM_BITS) - 1)
        ),
    "};\n\n",
);
