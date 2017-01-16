#!/usr/bin/perl

use strict;
use warnings;

my @counts = ( 0, 0 );
for ( my $n = 1 ; ; $n++ )
{
    my $s = join "", sort { $a <=> $b } split //, $n;

    $counts[ ( $n eq $s ) || ( $n eq scalar( reverse($s) ) ) || 0 ]++;

=begin foo
    if ($n == 538)
    {
        print "@counts\n";
    }
=end foo

=cut

    if ( $n % 100_000 == 0 )
    {
        print "$n: @counts\n";
    }

    if ( $counts[1] * 100 == $n )
    {
        print "Least n = $n\n";
        exit(0);
    }
}
