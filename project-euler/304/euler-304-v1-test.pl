#!/usr/bin/perl

use strict;
use warnings;

my $BASE = 1234567891011;

my $n    = 1;
my $prev = 0;
my $this = 1;

my %r;
while ( !exists( $r{"$prev;$this"} ) )
{
    $r{"$prev;$this"} = $n;
    ( $prev, $this ) = ( $this, ( $prev + $this ) % $BASE );
    $n++;
}

print "Repeat from ", $r{"$prev;$this"}, " to $n\n";
