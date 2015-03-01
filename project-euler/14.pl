#!/usr/bin/perl

use strict;
use warnings;


use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();
use List::UtilsBy qw(max_by);

STDOUT->autoflush(1);

sub calc_seq_rank
{
    my ($n) = @_;

    my $r = 0;

    while ($n != 1)
    {
        $r++;
        if ($n & 1)
        {
            ($n *= 3) += 1;
        }
        else
        {
            $n >>= 1;
        }
    }

    return $r;
}

print "N = " , ( max_by { calc_seq_rank($_)} 2 .. 999_999), "\n";
