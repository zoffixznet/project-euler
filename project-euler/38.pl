#!/usr/bin/perl

use strict;
use warnings;

my $max = -1;
INT_LOOP:
for my $int (9, 91..99, 911..999, 9111..9999)
{

    if ($int =~ /0/)
    {
        next INT_LOOP;
    }

    my $n = 1;
    my $pan = "";
    while (length($pan) < 9)
    {
        $pan .= $int * $n++;
    }
    if (length($pan) == 9)
    {
        if (join("", sort { $a <=> $b } split(//, $pan)) eq "123456789")
        {
            # $pan is a pan-digital number.
            if ($pan > $max)
            {
                $max = $pan;
            }
        }
    }
}
print "max = $max\n";

