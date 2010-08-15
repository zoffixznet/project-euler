#!/usr/bin/perl 

use strict;
use warnings;

sub factorial
{
    my $n = shift;

    if ($n <= 1)
    {
        return $n;
    }
    else
    {
        return $n * factorial($n-1);
    }
}

my $perm = 1_000_000 - 1;
my @digits = (0 .. 9);

my $place = 9;
my @result;

while ($perm)
{
    my $f = factorial($place);
    my $p = int ($perm / $f);
    
    push @result, splice(@digits,$p,1);

    $perm %= $f;
    $place--;
}
push @result, @digits;
print join("",@result), "\n";
