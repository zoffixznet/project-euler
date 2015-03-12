#!/usr/bin/perl

use strict;
use warnings;

package Row;

use MooX qw/late/;

has 'idx' => (isa => 'Int', is => 'ro', required => 1,);

has 'start' => (isa => 'Int', is => 'ro', lazy => 1, default => sub {
        my $self = shift;
        my $n = $self->idx - 1;
        return ((($n * ($n+1)) >> 1) + 1);
    }
);

package main;

use Test::More tests => 4;

# TEST
is (Row->new({idx => 1})->start(), 1, "Row[1].start");

# TEST
is (Row->new({idx => 2})->start(), 2, "Row[2].start");

# TEST
is (Row->new({idx => 3})->start(), 4, "Row[3].start");

# TEST
is (Row->new({idx => 4})->start(), 7, "Row[4].start");
