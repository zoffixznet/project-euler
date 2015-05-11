#!/usr/bin/perl

use strict;
use warnings;

s/\A([0-9]+):\s*//;
my $n = $1;
my %f;
foreach my $f (split/\s+/, $_)
{
    die if $f !~ /\S/;
    $f{$f}++;
}

my @t;
while (my ($k, $v) = each%f)
{
    push @t, [$k => $v];
}
my $root = sqrt($n);

sub f
{
    if (!@_)
    {
        return (1);
    }
    else
    {
        my ($f, $m) = @{shift(@_)};
        my @r = f(@_);

        my $x = 1;
        my @ret;
        for my $e (0 .. $m)
        {
            push @ret, map { $x * $_ } @r;
        }
        continue
        {
            $x *= $f;
        }
        return @ret;
    }
}

print join " ", $n, (sort { $a <=> $b } grep { $_ > 1 and $_ <= $root } f(@t));
