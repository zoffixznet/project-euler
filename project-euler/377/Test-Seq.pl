#!/usr/bin/perl

use strict;
use warnings;

use Euler377;

STDOUT->autoflush(1);

my $BASE = shift(@ARGV) || 1;

while (1)
{
    print "BASE=$BASE\n";
    my $obj = Euler377->new({BASE => $BASE, N_s => [$BASE]});
    my $have = $obj->calc_result();
    my $want = ($obj->calc_using_brute_force($BASE) % 1_000_000_000);
    if ($have != $want)
    {
        die "have = $have ; want = $want ; BASE = $BASE!";
    }
}
continue
{
    $BASE++;
}
