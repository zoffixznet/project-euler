#!/usr/bin/perl

use strict;
use warnings;

open my $primes_fh, "primes 2|";
my $count = 0;
my $total = 1;
my $n = 1;
my $l_p = 1;

my $last_prime = <$primes_fh>;
chomp($last_prime);
while (1)
{
    my $len = $l_p*2;

    # We can exclude the squares
    for my $i (1 .. 3)
    {
        $n += $len;
        # print "N = $n\n";
        while ($last_prime < $n)
        {
            $last_prime = <$primes_fh>;
            chomp($last_prime);
        }
        if ($last_prime == $n)
        {
            # print "Bump $n\n";
            $count++;
        }
    }
    $n += $len;
    $total += 4;
    # print "Len = " . ($len + 1) . ", Percent =" . ($count/$total*100) . "%\n";
    if ($count*10 < $total)
    {
        print "Len = ", $len+1, "\n";
        print "N = ", $n, "\n";
        exit;
    }
}
continue
{
    $l_p++;
}
