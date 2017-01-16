#!/usr/bin/perl

use strict;
use warnings;
use autodie;

my @series;

my %found;

my $elem = 14025256;

while ( !exists( $found{$elem} ) )
{
    $found{$elem} = scalar(@series);
    push @series, $elem;
}
continue
{
    $elem = ( ( $elem * $elem ) % 20300713 );
}

print "Prefix:\n";
for my $x ( @series[ 0 .. $found{$elem} - 1 ] )
{
    print $x;
}
print "\n";

print "Repeat:\n";
open my $out, '>', 'input.txt';
for my $x ( @series[ $found{$elem} .. $#series ] )
{
    print $x;
    $out->print($x);
}
print "\n";
close($out);

