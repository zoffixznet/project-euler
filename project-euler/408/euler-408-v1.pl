#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $is_sq = '';

my $LIM = shift(@ARGV);
my $MOD = 1_000_000_007;
for my $x (0 .. sqrt(2*$LIM))
{
    vec($is_sq, $x*$x, 1) = 1;
}

# $prev maps ($x) => P($x, $path_len-$x)
my $prev = [1];
for my $path_len (1 .. $LIM)
{
    my $next = [];
    for my $x (0)
    {
        push @$next, $prev->[0];
    }
    my $y = $path_len - 1;
    for my $x (1 .. $path_len - 1)
    {
        if (vec($is_sq, $path_len, 1) && vec($is_sq, $x, 1) && vec($is_sq, $y, 1))
        {
            push @$next, 0;
        }
        else
        {
            push @$next, (($prev->[$x-1]+$prev->[$x]) % $MOD);
        }
    }
    continue
    {
        $y--;
    }
    push @$next, $prev->[-1];
    # print "Prev = [@$prev] ; Next = [@$next]\n";
    $prev = $next;
}

my $max_x = $LIM;
my $max_y = $LIM;
my $min_x = 1;
for my $path_len ($LIM+1 .. (($LIM << 1)))
{
    my $next = [];
    my $y = $max_y;
    my $i = 1;
    for my $x ($min_x .. $max_x)
    {
        # print "($x,$y,@{[$x+$y,$path_len]})\n";
        if (vec($is_sq, $path_len, 1) && vec($is_sq, $x, 1) && vec($is_sq, $y, 1))
        {
            push @$next, 0;
        }
        else
        {
            push @$next, (($prev->[$i-1]+$prev->[$i]) % $MOD);
        }
    }
    continue
    {
        $i++;
        $y--;
    }
    $min_x++;
    # print "Prev = [@$prev] ; Next = [@$next]\n";
    $prev = $next;
}

print "Result = ", $prev->[0], "\n";
