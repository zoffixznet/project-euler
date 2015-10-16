#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $log_fn = 'found-log.txt';

sub get_last
{
    my $s = `cat "$log_fn" | tail -3`;

    my @n = $s =~ /Max = \K([0-9]+)/g;

    return $n[-1];
}

my $max = ((-e $log_fn) ? get_last() : 0);

open my $log_fh, '>>', $log_fn;
$log_fh->autoflush(1);
while (my $l = <ARGV>)
{
    my ($n) = ($l =~ /([0-9]+)/g);
    my $sum = `seq "$n" "@{[$n+8]}" | factor | perl -lane '\$s += \$F[-1]; END { print \$s }'`;
    chomp($sum);
    if ($sum > $max)
    {
        $max = $sum;
        my $str = "Found n = $n Max = $max\n";
        print $str;
        $log_fh->print($str);
    }
}

close($log_fh);
