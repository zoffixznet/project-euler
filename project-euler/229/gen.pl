#!/usr/bin/perl

use strict;
use warnings;

use feature qw/say/;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

# my $L = (1e7-1);
my $L = (2e9-1);
my $v = '';

my $dx = 1;
for (my $xs = 1; $xs < $L; $xs += ($dx += 2))
{
    say "Reached xs=$xs";
    my $dy = $dx;
    for (my $xys=($xs<<1); $xys < $L; $xys += ($dy += 2))
    {
        vec($v, $xys, 1) = 1;
    }
}

my $o = \$v;
my $t = do { \(my $foo = '') };

for my $f (2, 3, 7)
{
    my $ddy = ($f<<1);
    my $dx = 1;
    for (my $xs = 1; $xs < $L; $xs += ($dx += 2))
    {
        say "Reached f=$f xs=$xs";
        my $dy = $f;
        for (my $xys=$xs+$dy; $xys < $L; $xys += ($dy += $ddy))
        {
            if (vec($$o, $xys, 1))
            {
                vec($$t, $xys, 1) = 1;
            }
        }
    }
}
continue
{
    $o = $t;
    $t = do { \(my $foo = '') };
}

my $c = 0;
for my $n (2 .. $L)
{
    if (vec($$o, $n, 1))
    {
        say "Found ", (++$c), "\n";
    }
}
