package Euler424_v1;

use strict;
use warnings;

package Euler424_v1::Puzzle;

use Moose;

my $EMPTY = 0;
my $X = 1;
my $Y = 2;

my $NUM_DIGITS = 10;

has 'height' => (is => 'ro', isa => 'Int');
has 'width' => (is => 'ro', isa => 'Int');
has 'truth_table' => (is => 'rw', default => sub { return [map { [($EMPTY) x $NUM_DIGITS]} (1 .. $NUM_DIGITS)]; });

1;
