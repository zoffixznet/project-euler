#!/usr/bin/perl

use strict;
use warnings;

my @n = ( split //, shift(@ARGV) );

while ( my $l = <> )
{
    chomp($l);
    my $i = 0;
    substr( $l, 0, scalar(@n) ) =~ s/(\d)/$n[$i++] eq $1 ? 'X' : $1/ge;
    print "$l\n";
}

