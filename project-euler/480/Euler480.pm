package Euler480;

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(reduce sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $MAX_LEN = 15;

my $WORD = "thereisasyetinsufficientdataforameaningfulanswer";

my %MAP;

foreach my $l (split//,$WORD)
{
    $MAP{$l}++;
}

my @LETTERS = (map { [$_,$MAP{$_}] } sort keys %MAP);

sub calc_num_words_with_letters
{
    my ($letters, $max_len) = @_;

    my $
}

sub calc_W
{
    my ($i) = @_;

}
