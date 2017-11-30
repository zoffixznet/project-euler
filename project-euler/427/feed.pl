#!/usr/bin/perl

use strict;
use warnings;

my $i = 3199844;

my $FIN = 2;

while ($i >= $FIN)
{
    my $e = $i - 100;
    if ($e < $FIN)
    {
        $e = $FIN;
    }
    print "${e}_${i}\n";
    $i = $e-1;
}
