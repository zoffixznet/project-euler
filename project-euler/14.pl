#!/usr/bin/perl

use strict;
use warnings;

no warnings 'recursion';

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();
use List::UtilsBy qw(max_by);

STDOUT->autoflush(1);

{
    my %c = (1 => 0);
sub calc_seq_rank
{
    my ($n) = @_;

    return ($c{$n} //=
        (1 + calc_seq_rank(($n & 1) ? ($n*3+1) : ($n >> 1)))
    );
}
}

print "N = " , ( max_by { calc_seq_rank($_)} 2 .. 999_999), "\n";
