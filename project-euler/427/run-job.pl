#!/usr/bin/perl

use strict;
use warnings;

my ($start, $end) = shift(@ARGV) =~ /\A([0-9]+)_([0-9]+)\z/
    or die "Invalid range!";

my $FN =sprintf("results/%08d_%08d.txt", $start, $end);

if (! -e $FN)
{
system(sprintf("./e427-2-prod.exe %d %d > %s", $start, $end, $FN));
}

print STDERR "Done $start -> $end\n";
