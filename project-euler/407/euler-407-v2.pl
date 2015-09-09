#!/usr/bin/perl

use strict;
use warnings;

use v5.16;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);


my $bitmask = '';

my $dummy_line = <>;

my $LIM = 10_000_000;
my $STEP = 10_000;

my $count = 0;
my $sum = 0;
my $pr = $LIM - $STEP;
MAIN:
while (my $l = <>)
{
    my ($A, $Asq, @p) = ($l =~ /([0-9]+)/g);
    if (!@p)
    {
        last MAIN;
    }
    my %q;
    for my $p (@p)
    {
        $q{$p}++;
    }
    my $rec = sub {
        my ($n, $d) = @_;

        if (!@$d)
        {
            if ($n > $A)
            {
                if (!vec($bitmask, $n, 1))
                {
                    vec($bitmask, $n, 1) = 1;
                    $sum += $A;
                    $count++;
                }
            }
            return;
        }
        my $p = shift(@$d);
        my $e = shift(@$d);
        for my $m (0 .. $e)
        {
            __SUB__->($n, [@$d]);
        }
        continue
        {
            if (($n *= $p) >= $LIM)
            {
                return;
            }
        }
        return;
    };
    $rec->(1, [%q]);
    if ($A == $pr)
    {
        print "A=$A sum=$sum\n";
        $pr -= $STEP;
    }
}

$sum += 10_000_000 - $count;
print "Sum = $sum\n";
