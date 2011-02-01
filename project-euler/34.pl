#!/usr/bin/perl 

use strict;
use warnings;

use List::Util (qw(sum));

sub factorial
{
    my $n = shift;

    if ($n <= 1)
    {
        return 1;
    }
    else
    {
        return $n * factorial($n-1);
    }
}

my @facts = (map { factorial($_) } (0 .. 9));

my $total;
foreach my $n (3 .. 1e7)
{
    if ($n % 1e5 == 0)
    {
        print "$n\n";
    }
    if (sum(@facts[split//,$n]) == $n)
    {
        $total += $n;
    }
}
print "$total\n";
