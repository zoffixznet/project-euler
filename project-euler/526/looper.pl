#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $log_fn = "reached-log.txt";

sub get_last
{
    my $l = `cat "$log_fn" | tail -3`;

    my ($n) = ( $l =~ /([0-9]+)/g );

    return $n;
}

my $max = ( -e $log_fn ) ? get_last() : 10000000000000000;
open my $reached, '>>', $log_fn;

$reached->autoflush(1);
my $step = 1000000000;

my $s1 = $step - 1;
while ( $max > 0 )
{
    my $min = $max - $s1;

    system( '/home/shlomif/apps/primesieve/bin/primesieve',
        $min, $max, '--print=4' );
    $reached->print("Reached $max\n");
    $max = $min - 1;
}

close($reached);
