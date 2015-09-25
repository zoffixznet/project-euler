#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);


my $n = shift(@ARGV);

my $start = $n + 8;

open my $fh, qq#seq "$start" -1 2 | factor|#
    or die "Cannot open pipeline - $!";

sub myr
{
    my $l = <$fh>;
    chomp($l);
    my ($i) = $l =~ /([0-9]+)$/;
    return $i;
}

my @f_s;
my $sum = 0;

sub update
{
    my $x = myr();
    $sum += $x;
    push @f_s, $x;
}

for my $i (0 .. 8)
{
    update();
}

my $max = 0;
my $i = $n;

while ($i >= 3)
{
    if ($sum > $max)
    {
        $max = $sum;
        print "Found New Max g($i) = $max\n";
    }
    $sum -= shift(@f_s);
    update();
}
continue
{
    $i--;
}
